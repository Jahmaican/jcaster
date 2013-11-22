IMGW = 640
IMGH = 480
SCRW = 1366
SCRH = 768
VERSION = "0.12"
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
 
class JCaster < Window
attr_reader :gracz, :mapa
  def initialize
	super SCRW, SCRH, true
    self.caption = "jCaster"
    enable_undocumented_retrofication
    @font = Gosu::Font.new(self, default_font_name, 20)

    @gracz = Player.new(self, 18, 3)
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
