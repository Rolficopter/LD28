local class = require 'lib/middleclass'
local Drawable = require 'Drawable'

Game = class('Game', Drawable)

local initWorld = function(self)
  self.world = love.physics.newWorld(0, 9.81, true)
end
function Game:initialize()
  initWorld(self)
  Drawable:initialize(self.world)
end

function Game:update(dt)
  self.world:update(dt)
end
function Game:render()
  love.graphics.print('Hello World', 10, 10)
end

return Game
