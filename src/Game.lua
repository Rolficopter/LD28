local class = require 'lib/middleclass'
local Drawable = require 'Drawable'

Game = class('Game', Drawable)

function Game:initialize()
  Drawable:initialize(world)
end

function Game:render()
  love.graphics.print('Hello World', 10, 10)
end

return Game
