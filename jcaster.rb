MAPW = 24
MAPH = 24
IMGW = 320
IMGH = 240
SCRW = 640
SCRH = 480
VERSION = "0.01"
DEBUG = true

def debug(message)
  puts "#{Time.now.strftime("%H:%M:%S.%L")} - \t#{message}" if DEBUG
end

require 'gosu'
require 'texplay'
include Gosu

debug("jCaster v" + VERSION + "\n\t\tby Jahmaican")

$worldMap = [[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
            [1,0,0,0,0,0,2,2,2,2,2,0,0,0,0,3,0,3,0,3,0,0,0,1],
            [1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,1],
            [1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,3,0,0,0,3,0,0,0,1],
            [1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,1],
            [1,0,0,0,0,0,2,2,0,2,2,0,0,0,0,3,0,3,0,3,0,0,0,1],
            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
            [1,4,4,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
            [1,4,0,4,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
            [1,4,0,0,0,0,5,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
            [1,4,0,4,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
            [1,4,0,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
            [1,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
            [1,4,4,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
            [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]]
            
class JCaster < Window
  def initialize
    super SCRW, SCRH, false
    self.caption = "jCaster"
    enable_undocumented_retrofication
    
    @posX, @posY = 22.0, 12.0
    @dirX, @dirY = -1.0, 0.0
    @planeX, @planeY = 0.0, 1.0
    @img = TexPlay::create_blank_image(self, IMGW, IMGH)
  end
  
  def update
    @img.clear
    (0..IMGW).each do |x|
      cameraX = 2*x/IMGW.to_f-1
      rayPosX = @posX
      rayPosY = @posY
      rayDirX = @dirX + @planeX * cameraX
      rayDirY = @dirY + @planeY * cameraX
      
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
      
      lineHeight = (IMGH / perpWallDist).to_i.abs
      
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
        
      @img.line(x, drawStart, x, drawEnd, :color => color)
      
    end
    
    moveSpeed = 10.0/60
    rotSpeed = 5.0/60
    
    if button_down? KbUp or button_down? KbW
      @posX += @dirX * moveSpeed if $worldMap[(@posX + @dirX * moveSpeed).to_i][@posY.to_i] == 0
      @posY += @dirY * moveSpeed if $worldMap[@posX.to_i][(@posY + @dirY * moveSpeed).to_i] == 0
    end

    if button_down? KbDown or button_down? KbS
      @posX -= @dirX * moveSpeed if $worldMap[(@posX - @dirX * moveSpeed).to_i][@posY.to_i] == 0
      @posY -= @dirY * moveSpeed if $worldMap[@posX.to_i][(@posY - @dirY * moveSpeed).to_i] == 0
    end
    
    if button_down? KbRight or button_down? KbD
      oldDirX = @dirX;
      @dirX = @dirX * Math::cos(-rotSpeed) - @dirY * Math::sin(-rotSpeed)
      @dirY = oldDirX * Math::sin(-rotSpeed) + @dirY * Math::cos(-rotSpeed)
      oldPlaneX = @planeX
      @planeX = @planeX * Math::cos(-rotSpeed) - @planeY * Math::sin(-rotSpeed)
      @planeY = oldPlaneX * Math::sin(-rotSpeed) + @planeY * Math::cos(-rotSpeed)
    end

    if button_down? KbLeft or button_down? KbA
      oldDirX = @dirX
      @dirX = @dirX * Math::cos(rotSpeed) - @dirY * Math::sin(rotSpeed)
      @dirY = oldDirX * Math::sin(rotSpeed) + @dirY * Math::cos(rotSpeed)
      oldPlaneX = @planeX
      @planeX = @planeX * Math::cos(rotSpeed) - @planeY * Math::sin(rotSpeed)
      @planeY = oldPlaneX * Math::sin(rotSpeed) + @planeY * Math::cos(rotSpeed)
    end
    
    close if button_down? KbEscape
  end
  
  def draw
    @img.draw(0, 0, 1, SCRW/IMGW.to_f, SCRH/IMGH.to_f)
  end

end

debug("Wszystko gra!")
JCaster.new.show