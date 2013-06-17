IMGW = 320
IMGH = 240
SCRW = 640
SCRH = 480
VERSION = "0.02"
DEBUG = true

def debug(message)
  puts "#{Time.now.strftime("%H:%M:%S.%L")} - \t#{message}" if DEBUG
end

require 'gosu'
require 'texplay'
include Gosu

debug("jCaster v" + VERSION + "\n\t\tby Jahmaican")

require './worldMap.rb'
require './playerClass.rb'
require './mapClass.rb'
 
class JCaster < Window
attr_reader :gracz, :mapa
  def initialize
    super SCRW, SCRH, false
    self.caption = "jCaster"
    enable_undocumented_retrofication

    @gracz = Player.new
    @mapa = Map.new(self)
  end
  
  def update
    @mapa.update
    @gracz.up if button_down? KbUp or button_down? KbW
    @gracz.down if button_down? KbDown or button_down? KbS
    @gracz.left if button_down? KbLeft or button_down? KbA
    @gracz.right if button_down? KbRight or button_down? KbD
    close if button_down? KbEscape
  end
  
  def draw
    @mapa.draw
  end
end

debug("Wszystko gra!")
JCaster.new.show