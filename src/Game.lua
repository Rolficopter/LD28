local class = require 'lib/middleclass'
local Drawable = require 'Drawable'
local World = require 'World'

Game = class('Game', Drawable)

-- Init logic
function Game:initialize()
  Drawable:initialize()
  self.world = World:new()
  
  self.color = { 255, 0, 0, 255 }
  love.graphics.setBackgroundColor(self.color)
end

-- Update logic
function Game:update(dt)
  self.world:update(dt)
end

-- Render Logic
function Game:render()
  self.world:render()
end

return Game
