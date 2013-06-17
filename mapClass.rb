class Map
  def initialize(window)
    @bg = TexPlay::create_blank_image(window, IMGW, IMGH)
    @map = TexPlay::create_blank_image(window, IMGW, IMGH)
    @window = window
    
    @bg.rect(0,0,SCRW,IMGH>>1, :color => [0.6, 0.7, 1.0], :fill => true)
    @bg.rect(0,IMGH>>1,SCRW,IMGH, :color => [0.1, 0.1, 0.1], :fill => true)
  end
  
  def update
    @map.clear
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
      
      drawStart = -lineHeight / 2 + IMGH / 2
      drawStart = 0 if drawStart < 0
      drawEnd = lineHeight / 2 + IMGH / 2
      drawEnd = IMGH - 1 if drawEnd >= IMGH
      
      case $worldMap[mapX][mapY]
      when 1
        color = [1.0, 0, 0]
      when 2
        color = [0, 1.0, 0]
      when 3
        color = [0, 0, 1.0]
      when 4
        color = [1.0, 1.0, 1.0]
      else
        color = [1.0, 1.0, 0]
      end

      color = color.collect {|i| i/2} if side == 1
        
      @map.line(x, drawStart, x, drawEnd, :color => color)
    end
  end
  
  def draw
    @bg.draw(0, 0, 0, SCRW.fdiv(IMGW), SCRH.fdiv(IMGH))
    @map.draw(0, 0, 1, SCRW.fdiv(IMGW), SCRH.fdiv(IMGH))
  end
end