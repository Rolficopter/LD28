local class = require 'lib/middleclass'
local Drawable = require 'Drawable'
local Entity = require 'Entity'
local Constants = require 'conf'

Game = class('Game', Drawable)

-- Init logic
local createTempWorld = function(self)
  self.ground = Entity:new(self.world)
  self.ground.color = { 50, 230, 50, 230 }
  self.ground.body = love.physics.newBody(self.world, Constants.SCREEN.WIDTH / 2, Constants.SCREEN.HEIGHT - 50, 'static')
  self.ground.shape = love.physics.newRectangleShape(Constants.SCREEN.WIDTH * 2, 100)
end
local initWorld = function(self)
  love.physics.setMeter(Constants.SIZES.METER)
  self.world = love.physics.newWorld(Constants.GRAVITY.X * Constants.SIZES.METER, Constants.GRAVITY.Y * Constants.SIZES.METER, true)
  -- TODO replace with Tiled map
  createTempWorld(self)
end
function Game:initialize()
  Drawable:initialize()
  initWorld(self)
  
  self.color = { 255, 0, 0, 255 }
  love.graphics.setBackgroundColor(self.color)
end

-- Update logic
local updateObjects = function(self, dt)
  self.ground:update(dt)
end
function Game:update(dt)
  self.world:update(dt)
  
  updateObjects(self, dt)
end

-- Render Logic
local renderObjects = function(self)
  self.ground:render()
end
function Game:render()
  renderObjects(self)
end

return Game
