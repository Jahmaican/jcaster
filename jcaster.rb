IMGW = 320
IMGH = 240
SCRW = 1024
SCRH = 768
VERSION = "0.03"
DEBUG = true

def debug(message)
  puts "#{Time.now.strftime("%H:%M:%S.%L")} - \t#{message}" if DEBUG
end

require 'gosu'
require 'texplay'
include Gosu

debug("jCaster v#{VERSION} \n\t\tby Jahmaican")

require './worldMap.rb'
require './playerClass.rb'
require './mapClassBasic.rb'
 
class JCaster < Window
attr_reader :gracz, :mapa
  def initialize
    super SCRW, SCRH, true
    self.caption = "jCaster"
    enable_undocumented_retrofication
    @font = Gosu::Font.new(self, default_font_name, 20)

    @gracz = Player.new(self)
    @mapa = Map.new(self)
  end
    
  def update
    @mapa.update
    @gracz.update
    close if button_down? KbEscape
  end
  
  def draw
    @font.draw("#{fps} fps", 10, 10, 10, 1, 1, color = 0xffffffff, :default) if DEBUG
    
    @gracz.draw
    @mapa.draw
  end
end

debug("Wszystko gra!")
JCaster.new.show
