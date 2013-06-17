class Player
attr_reader :posX, :posY, :dirX, :dirY, :planeX, :planeY, :moveSpeed, :rotSpeed
  def initialize
    @posX, @posY = 22.0, 12.0
    @dirX, @dirY = -1.0, 0.0
    @planeX, @planeY = 0.0, 1.0
    @moveSpeed = 0.16
    @rotSpeed = 0.08
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
    
    def turnRight
      oldDirX = @dirX;
      @dirX = @dirX * Math::cos(-@rotSpeed) - @dirY * Math::sin(-@rotSpeed)
      @dirY = oldDirX * Math::sin(-@rotSpeed) + @dirY * Math::cos(-@rotSpeed)
      oldPlaneX = @planeX
      @planeX = @planeX * Math::cos(-@rotSpeed) - @planeY * Math::sin(-@rotSpeed)
      @planeY = oldPlaneX * Math::sin(-@rotSpeed) + @planeY * Math::cos(-@rotSpeed)
    end

    def turnLeft
      oldDirX = @dirX
      @dirX = @dirX * Math::cos(@rotSpeed) - @dirY * Math::sin(@rotSpeed)
      @dirY = oldDirX * Math::sin(@rotSpeed) + @dirY * Math::cos(@rotSpeed)
      oldPlaneX = @planeX
      @planeX = @planeX * Math::cos(@rotSpeed) - @planeY * Math::sin(@rotSpeed)
      @planeY = oldPlaneX * Math::sin(@rotSpeed) + @planeY * Math::cos(@rotSpeed)
    end
end