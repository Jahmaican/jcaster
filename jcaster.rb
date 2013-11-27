IMGW = 1600
IMGH = 900
SCRW = 1600
SCRH = 900
VERSION = "0.13"
DEBUG = true

def debug(message)
  puts "#{Time.now.strftime("%H:%M:%S.%L")} - \t#{message}" if DEBUG
end

require 'gosu'
include Gosu

debug("jCaster v#{VERSION} \n\t\tby Jahmaican")

require './worldMap.rb'
require './playerClass.rb'
require './mapClass.rb'
require './timer.rb'
 
class JCaster < Window
attr_reader :gracz, :mapa
  def initialize
    super SCRW, SCRH, true
    self.caption = "jCaster"
    enable_undocumented_retrofication
    @font = Gosu::Font.new(self, "media/boxybold.ttf", 20)
    @state = :loading
    @timer = Timer.new
    
    @gracz = Player.new(self, 18, 3)
    @mapa = Map.new(self)
    @init = true
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

debug("Wszystko gra!")
JCaster.new.show
