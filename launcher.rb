require 'gosu'
include Gosu

require './class/jCaster.rb'
require './class/worldMap.rb'
require './class/playerClass.rb'
require './class/mapClass.rb'
require './class/timer.rb'
 
class Launcher < Window
  DETAILS = { 0 => "Very low", 1=> "Low", 2 => "Medium", 3 => "High" } 
  def initialize
    super 640, 480, false
    self.caption = "jCaster Launcher"
    enable_undocumented_retrofication
    @title = Image.new(self, "media/title.jpg", true)
    @font = Font.new(self, "media/boxybold.ttf", 20)
    settings = Array.new
    IO.foreach("settings") do |str| 
      settings.push(str.to_i)
    end
    @scrW = settings[0]
    @scrH = settings[1]
    @details = settings[2]
    @timer = Timer.new
  end
    
  def update
    if button_down? KbD and @timer.time > 100
      @details == 3 ? @details = 0 : @details += 1
      save_settings
      @timer.reset
    end
    if button_down? KbReturn
      JCaster.new.show
      close
    end
    close if button_down? KbEscape
  end
  
  def save_settings
    file = File.new("settings", 'w')
    if file
      file.syswrite(@scrW.to_s + "\n" + @scrH.to_s + "\n" + @details.to_s)
    else
      puts "File access error"
    end
    file.close
  end
  
  def draw
    @title.draw(0,0,10,2,2)
    @font.draw("v#{VERSION}!", 460, 140, 10, 1, 1, color = 0xffffffff)
    @font.draw("<c=6a6a6a>R</c>esolution: #{@scrW} x #{@scrH}", 20, 240, 10, 1, 1, color = 0xffffffff)
    @font.draw("<c=6a6a6a>D</c>etails: #{DETAILS[@details]}", 20, 300, 10, 1, 1, color = 0xffffffff)
    @font.draw_rel("PRESS ENTER TO START", 320, 440, 10, 0.5, 0.5, 1, 1, color = 0xffffffff) if (milliseconds/500)%2 == 0
  end
end

Launcher.new.show
