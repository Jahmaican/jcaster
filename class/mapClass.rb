TEXW=64
TEXH=64

class Map
attr_reader :init
  def initialize(window)
    @window = window
    
    @map = @window.record(@window.imgW, @window.imgH) {}
    @bg = @window.record(@window.imgW, @window.imgH) do
      sky_c = Color.argb(0xFF86A0D9)
      flr_c = Color.argb(0xFF343434)
      @window.draw_quad(0, 0, sky_c, @window.imgW, 0, sky_c, 0, @window.imgH>>1, sky_c, @window.imgW, @window.imgH>>1, sky_c) 
      @window.draw_quad(0, @window.imgH>>1, flr_c, @window.imgW, @window.imgH>>1, flr_c, 0, @window.imgH, flr_c, @window.imgW, @window.imgH, flr_c) 
    end

    @wallset = [Image.load_tiles(window, "media/walls.png", 1, TEXH, true),       #see what I did there? 
                Image.load_tiles(window, "media/wallsd.png", 1, TEXH, true)]
                
    @init = true
  end
  
  def update
    @map = @window.record(@window.imgW, @window.imgH) do
      (0..@window.imgW).each do |x|
        camera_x = 2*x.fdiv(@window.imgW)-1
        ray_pos_x = @window.gracz.pos_x
        ray_pos_y = @window.gracz.pos_y
        ray_dir_x = @window.gracz.dir_x + @window.gracz.plane_x * camera_x
        ray_dir_y = @window.gracz.dir_y + @window.gracz.plane_y * camera_x
        
        map_x = ray_pos_x.to_i
        map_y = ray_pos_y.to_i
        
        delta_dist_x = Math::sqrt(1 + (ray_dir_y * ray_dir_y) / (ray_dir_x * ray_dir_x))
        delta_dist_y = Math::sqrt(1 + (ray_dir_x * ray_dir_x) / (ray_dir_y * ray_dir_y))
        
        hit = false 
  
        if ray_dir_x < 0
          step_x = -1
          side_dist_x = (ray_pos_x - map_x) * delta_dist_x
        else
          step_x = 1
          side_dist_x = (map_x + 1.0 - ray_pos_x) * delta_dist_x
        end
  
        if ray_dir_y < 0
          step_y = -1
          side_dist_y = (ray_pos_y - map_y) * delta_dist_y
        else
          step_y = 1
          side_dist_y = (map_y + 1.0 - ray_pos_y) * delta_dist_y
        end
        
        while !hit
          if side_dist_x < side_dist_y
            side_dist_x += delta_dist_x
            map_x += step_x
            side = 0
          else
            side_dist_y += delta_dist_y
            map_y += step_y
            side = 1
          end
          hit = true if $world_map[map_x][map_y] > 0
        end
        
        side == 0 ? perp_wall_dist = ((map_x - ray_pos_x + (1 - step_x) / 2) / ray_dir_x).abs : perp_wall_dist = ((map_y - ray_pos_y + (1 - step_y) / 2) / ray_dir_y).abs
        
        line_height = (@window.imgH/perp_wall_dist).abs
        
        draw_start = -line_height/2 + @window.imgH/2
        #draw_end = line_height/2 + @window.imgH/2
  
        side == 1 ? wall_x = ray_pos_x + ((map_y-ray_pos_y + (1-step_y)/2)/ray_dir_y)*ray_dir_x : wall_x = ray_pos_y + ((map_x-ray_pos_x + (1-step_x)/2)/ray_dir_x)*ray_dir_y
        wall_x = wall_x - wall_x.to_i
  
        tex_x = (wall_x*TEXW).to_i
        tex_x = TEXW - tex_x - 1 if (side == 0 && ray_dir_x > 0)
        tex_x = TEXW - tex_x - 1 if (side == 1 && ray_dir_y < 0) 
        
        
        @wallset[side][(($world_map[map_x][map_y]-1)*TEXW)+tex_x].draw(x,draw_start,1, 1.0, line_height.fdiv(TEXH))
      end
    end
  end

  def draw
    @bg.draw(0, 0, 0, @window.scrW.fdiv(@window.imgW), @window.scrH.fdiv(@window.imgH))
    @map.draw(0, 0, 1, @window.scrW.fdiv(@window.imgW), @window.scrH.fdiv(@window.imgH))
  end
end
