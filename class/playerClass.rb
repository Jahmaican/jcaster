BOBBING = true
MOV_SPD = 0.1

class Player
attr_reader :pos_x, :pos_y, :dir_x, :dir_y, :plane_x, :plane_y, :move_speed, :rot_speed, :init
  def initialize(window, pos_x, pos_y)
    @window = window
    @pos_x, @pos_y = pos_x, pos_y
    @dir_x, @dir_y = -1.0, 0.0
    @plane_x, @plane_y = 0.0, 1.0

    @window.mouse_x = @window.width >> 1
    @mouse_pos = @window.mouse_x
    @mouse_speed = 0.005
    
    @weapon = Image.new(window, "media/uzi.png", false)
    @weapon_offset = 0
    @weapon_ratio = 0.3*@window.scrH.fdiv(@weapon.height)
    
    @cross = @window.record(5, 5) do
      @window.draw_quad(2, 0, Color::WHITE, 3, 0, Color::WHITE, 2, 2, Color::WHITE, 3, 2, Color::WHITE) 
      @window.draw_quad(2, 3, Color::WHITE, 3, 3, Color::WHITE, 2, 5, Color::WHITE, 3, 5, Color::WHITE) 
      @window.draw_quad(0, 2, Color::WHITE, 0, 3, Color::WHITE, 2, 2, Color::WHITE, 2, 3, Color::WHITE) 
      @window.draw_quad(3, 2, Color::WHITE, 3, 3, Color::WHITE, 5, 2, Color::WHITE, 5, 3, Color::WHITE) 
    end
    @init = true
  end
  
  def up
    @pos_x += @dir_x * @move_speed if $world_map[(@pos_x + @dir_x * @move_speed).to_i][@pos_y.to_i] == 0
    @pos_y += @dir_y * @move_speed if $world_map[@pos_x.to_i][(@pos_y + @dir_y * @move_speed).to_i] == 0
  end
  
  def down
    @pos_x -= @dir_x * @move_speed if $world_map[(@pos_x - @dir_x * @move_speed).to_i][@pos_y.to_i] == 0
    @pos_y -= @dir_y * @move_speed if $world_map[@pos_x.to_i][(@pos_y - @dir_y * @move_speed).to_i] == 0
  end
  
  def right
    @pos_x += @plane_x * @move_speed if $world_map[(@pos_x + @plane_x * @move_speed).to_i][@pos_y.to_i] == 0
    @pos_y += @plane_y * @move_speed if $world_map[@pos_x.to_i][(@pos_y + @plane_y * @move_speed).to_i] == 0
  end
  
  def left
    @pos_x -= @plane_x * @move_speed if $world_map[(@pos_x - @plane_x * @move_speed).to_i][@pos_y.to_i] == 0
    @pos_y -= @plane_y * @move_speed if $world_map[@pos_x.to_i][(@pos_y - @plane_y * @move_speed).to_i] == 0
  end
    
  def turn
    old_dir_x = @dir_x;
    @dir_x = @dir_x * Math::cos((@mouse_pos-@window.mouse_x)*@mouse_speed) - @dir_y * Math::sin((@mouse_pos-@window.mouse_x)*@mouse_speed)
    @dir_y = old_dir_x * Math::sin((@mouse_pos-@window.mouse_x)*@mouse_speed) + @dir_y * Math::cos((@mouse_pos-@window.mouse_x)*@mouse_speed)
    old_plane_x = @plane_x
    @plane_x = @plane_x * Math::cos((@mouse_pos-@window.mouse_x)*@mouse_speed) - @plane_y * Math::sin((@mouse_pos-@window.mouse_x)*@mouse_speed)
    @plane_y = old_plane_x * Math::sin((@mouse_pos-@window.mouse_x)*@mouse_speed) + @plane_y * Math::cos((@mouse_pos-@window.mouse_x)*@mouse_speed)
    @window.mouse_x = @window.width >> 1 if @window.mouse_x <= 1 or @window.mouse_x >= @window.scrW-1 
    @mouse_pos = @window.mouse_x
  end
  
  def gun_bobbing
    @weapon_offset = 2*Math::sin((milliseconds/100)%6)
  end
  
  def update
    @move_speed = double_keys? ? MOV_SPD/Math::sqrt(2) : MOV_SPD
    
    if @window.button_down? KbW
      up 
      gun_bobbing if BOBBING
    end
    
    if @window.button_down? KbS
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
    
    turn if @mouse_pos != @window.mouse_x
  end
  
  def double_keys?
    (@window.button_down? KbW or @window.button_down? KbS) and (@window.button_down? KbA or @window.button_down? KbD)
  end
  
  def draw
    @weapon.draw(0.6*@window.scrW, @window.scrH-(@weapon.height-@weapon_offset-5)*@weapon_ratio, 2, @weapon_ratio, @weapon_ratio)
    @cross.draw_rot(@window.scrW>>1, @window.scrH>>1, 2, 0, 0, 0, 2.0, 2.0)				      # draw_rot to avoid struggling with finding the exact center of screen
  end
end
