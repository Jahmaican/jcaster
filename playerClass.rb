BOBBING = true

class Player
attr_reader :posX, :posY, :dirX, :dirY, :planeX, :planeY, :moveSpeed, :rotSpeed
  def initialize(window, posX, posY)
    @window = window
    @posX, @posY = posX, posY
    @dirX, @dirY = -1.0, 0.0
    @planeX, @planeY = 0.0, 1.0
    @moveSpeed = 0.12

    @window.mouse_x = @window.width >> 1
    @mousePos = @window.mouse_x
    @mouseSpeed = 0.008
    
    @weapon = Image.new(window, "media/uzi.gif", false)
    @weapon_offset = 0
    @weapon_ratio = 0.3*SCRH.fdiv(@weapon.height)
    
    @cross = @window.record(5, 5) do
      @window.draw_quad(2, 0, Color::WHITE, 3, 0, Color::WHITE, 2, 2, Color::WHITE, 3, 2, Color::WHITE) 
      @window.draw_quad(2, 3, Color::WHITE, 3, 3, Color::WHITE, 2, 5, Color::WHITE, 3, 5, Color::WHITE) 
      @window.draw_quad(0, 2, Color::WHITE, 0, 3, Color::WHITE, 2, 2, Color::WHITE, 2, 3, Color::WHITE) 
      @window.draw_quad(3, 2, Color::WHITE, 3, 3, Color::WHITE, 5, 2, Color::WHITE, 5, 3, Color::WHITE) 
    end
  end
  
  def up
    @posX += @dirX * @moveSpeed if $worldMap[(@posX + @dirX * @moveSpeed).to_i][@posY.to_i] == 0
    @posY += @dirY * @moveSpeed if $worldMap[@posX.to_i][(@posY + @dirY * @moveSpeed).to_i] == 0
  end
  
  def down
    @posX -= @dirX * @moveSpeed if $worldMap[(@posX - @dirX * @moveSpeed).to_i][@posY.to_i] == 0
    @posY -= @dirY * @moveSpeed if $worldMap[@posX.to_i][(@posY - @dirY * @moveSpeed).to_i] == 0
  end
  
  def right
    @posX += @planeX * @moveSpeed if $worldMap[(@posX + @planeX * @moveSpeed).to_i][@posY.to_i] == 0
    @posY += @planeY * @moveSpeed if $worldMap[@posX.to_i][(@posY + @planeY * @moveSpeed).to_i] == 0
  end
  
  def left
    @posX -= @planeX * @moveSpeed if $worldMap[(@posX - @planeX * @moveSpeed).to_i][@posY.to_i] == 0
    @posY -= @planeY * @moveSpeed if $worldMap[@posX.to_i][(@posY - @planeY * @moveSpeed).to_i] == 0
  end
    
  def turn
    oldDirX = @dirX;
    @dirX = @dirX * Math::cos((@mousePos-@window.mouse_x)*@mouseSpeed) - @dirY * Math::sin((@mousePos-@window.mouse_x)*@mouseSpeed)
    @dirY = oldDirX * Math::sin((@mousePos-@window.mouse_x)*@mouseSpeed) + @dirY * Math::cos((@mousePos-@window.mouse_x)*@mouseSpeed)
    oldPlaneX = @planeX
    @planeX = @planeX * Math::cos((@mousePos-@window.mouse_x)*@mouseSpeed) - @planeY * Math::sin((@mousePos-@window.mouse_x)*@mouseSpeed)
    @planeY = oldPlaneX * Math::sin((@mousePos-@window.mouse_x)*@mouseSpeed) + @planeY * Math::cos((@mousePos-@window.mouse_x)*@mouseSpeed)
    @window.mouse_x = @window.width >> 1
    @mousePos = @window.mouse_x
  end
  
  def gun_bobbing
    @weapon_offset =2 * Math::sin((milliseconds/100)%6)
  end
  
  def update
    if @window.button_down? KbUp or @window.button_down? KbW
      up 
      gun_bobbing if BOBBING
    end
    
    if @window.button_down? KbDown or @window.button_down? KbS
      down
      gun_bobbing if BOBBING
    end
    
    if @window.button_down? KbA
      left 
      gun_bobbing if BOBBING
    end
    
    if @window.button_down? KbD
      right 
      gun_bobbing if BOBBING
    end
    
    turn if @mousePos != @window.mouse_x
  end
  
  def draw
    @weapon.draw(0.6*SCRW, SCRH-(@weapon.height-@weapon_offset-5)*@weapon_ratio, 2, @weapon_ratio, @weapon_ratio)
    @cross.draw_rot(SCRW>>1, SCRH>>1, 2, 0, 0, 0, 2.0, 2.0)				# draw_rot to avoid struggling with finding the exact center of screen
  end
end
