class Map
  def initialize(window)
    @window = window
    
    @map = @window.record(IMGW, IMGH) {}
    @bg = @window.record(IMGW, IMGH) do
      sky_c = Color.argb(0xFFA6E0D9)
      flr_c = Color.argb(0xFF575757)
      @window.draw_quad(0, 0, sky_c, IMGW, 0, sky_c, 0, IMGH>>1, sky_c, IMGW, IMGH>>1, sky_c) 
      @window.draw_quad(0, IMGH>>1, flr_c, IMGW, IMGH>>1, flr_c, 0, IMGH, flr_c, IMGW, IMGH, flr_c) 
    end

    @wallset = [Image.load_tiles(window, "media/walls.png", 1, 64, true),       #see what I did there? 
                Image.load_tiles(window, "media/wallsd.png", 1, 64, true)]
  end
  
  def update
    @map = @window.record(IMGW, IMGH) do
      (0..IMGW).each do |x|
        cameraX = 2*x.fdiv(IMGW)-1
        rayPosX = @window.gracz.posX
        rayPosY = @window.gracz.posY
        rayDirX = @window.gracz.dirX + @window.gracz.planeX * cameraX
        rayDirY = @window.gracz.dirY + @window.gracz.planeY * cameraX
        
        mapX = rayPosX.to_i
        mapY = rayPosY.to_i
        
        deltaDistX = Math::sqrt(1 + (rayDirY * rayDirY) / (rayDirX * rayDirX))
        deltaDistY = Math::sqrt(1 + (rayDirX * rayDirX) / (rayDirY * rayDirY))
        
        hit = 0 
  
        if rayDirX < 0
          stepX = -1
          sideDistX = (rayPosX - mapX) * deltaDistX
        else
          stepX = 1
          sideDistX = (mapX + 1.0 - rayPosX) * deltaDistX
        end
  
        if rayDirY < 0
          stepY = -1
          sideDistY = (rayPosY - mapY) * deltaDistY
        else
          stepY = 1
          sideDistY = (mapY + 1.0 - rayPosY) * deltaDistY
        end
        
        while hit==0
          if sideDistX < sideDistY
            sideDistX += deltaDistX
            mapX += stepX
            side = 0
          else
            sideDistY += deltaDistY
            mapY += stepY
            side = 1
          end
          hit = 1 if $worldMap[mapX][mapY] > 0
        end
        
        side == 0 ? perpWallDist = ((mapX - rayPosX + (1 - stepX) / 2) / rayDirX).abs : perpWallDist = ((mapY - rayPosY + (1 - stepY) / 2) / rayDirY).abs
        
        lineHeight = (IMGH/perpWallDist).abs
        
        drawStart = -lineHeight/2 + IMGH/2
        drawEnd = lineHeight/2 + IMGH/2
  
        side == 1 ? wallX = rayPosX + ((mapY-rayPosY + (1-stepY)/2)/rayDirY)*rayDirX : wallX = rayPosY + ((mapX-rayPosX + (1-stepX)/2)/rayDirX)*rayDirY
        wallX = wallX - wallX.to_i
  
        texX = (wallX * 64).to_i
        texX = 64 - texX - 1 if (side == 0 && rayDirX > 0)
        texX = 64 - texX - 1 if (side == 1 && rayDirY < 0) 
        
        @wallset[side][($worldMap[mapX][mapY]-1)*64+texX].draw(x,drawStart,1, 1.0, lineHeight.fdiv(64))
      end
    end
  end

  def draw
    @bg.draw(0, 0, 0, SCRW.fdiv(IMGW), SCRH.fdiv(IMGH))
    @map.draw(0, 0, 1, SCRW.fdiv(IMGW), SCRH.fdiv(IMGH))
  end
end
