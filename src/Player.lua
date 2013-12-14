local Constants = require 'conf'
local class = require 'lib/middleclass'
local Entity = require 'Entity'

Player = class('Player', Entity)

function Player:initialize(world, x, y)
  Entity:initialize(world)
  
  self.body = love.physics.newBody(self.world, x, y, 'dynamic')
  self.shape = love.physics.newRectangleShape(Constants.SIZES.PLAYER.X, Constants.SIZES.PLAYER.Y)
  self:createFixture()
end

return Player