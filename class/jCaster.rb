VERSION = "0.2"
DEBUG = true

def debug(message)
  puts "#{Time.now.strftime("%H:%M:%S.%L")} - \t#{message}" if DEBUG
end

require 'gosu'
include Gosu

debug("jCaster v#{VERSION} \n\t\tby Jahmaican")
 
class JCaster < Window
attr_reader :gracz, :mapa, :scrW, :scrH, :imgW, :imgH
  def initialize
    settings = Array.new
    IO.foreach("settings") do |str| 
      str.tr!("\n", "")
      settings.push(str)
    end
    
    @scrW = settings[0].to_i
    @scrH = settings[1].to_i
    
    super @scrW, @scrH, true
    self.caption = "jCaster v#{VERSION}"
    
    case settings[2].to_i
      when 0
        @imgW = 160
        @imgH = 90
      when 1
        @imgW = 320
        @imgH = 180
      when 2
        @imgW = @scrW>>1
        @imgH = @scrH>>1
      when 3
        @imgW = @scrW
        @imgH = @scrH
    end
    
    enable_undocumented_retrofication
    @font = Gosu::Font.new(self, "media/boxybold.ttf", 20)
    @state = :loading
    @timer = Timer.new
    
    @gracz = Player.new(self, 18, 3)
    @mapa = Map.new(self)
    debug("Wszystko gra!")
  end
    
  def update
    case @state
      when :loading
        @state = :game if fps > 0 and @gracz.init and @mapa.init
        
      when :game
        @mapa.update
        @gracz.update
        close if button_down? KbEscape
        if button_down? KbP and @timer.time > 256
          @timer.reset
          @state = :pause
        end
        
      when :pause
        close if button_down? KbEscape
        if button_down? KbP and @timer.time > 256
          @timer.reset
          @state = :game
        end

    end
  end
  
  def draw
    case @state
      when :loading
        @font.draw("LOADING", 10, 10, 10, 1, 1, color = 0xffffffff)
      when :game
        @font.draw("#{fps} fps", 10, 10, 10, 1, 1, color = 0xffffffff) if DEBUG
        @gracz.draw
        @mapa.draw
      when :pause
        @font.draw("PAUSED", 10, 10, 10, 1, 1, color = 0xffffffff)
        @gracz.draw
        @mapa.draw
    end
  end
end
