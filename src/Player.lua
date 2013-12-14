local Constants = require 'conf'
local class = require 'lib/middleclass'
local Entity = require 'Entity'

Player = class('Player', Entity)

-- Init logic
function Player:initialize(world, x, y)
  Entity:initialize(world)
  
  self.body = love.physics.newBody(self.world, x, y, 'dynamic')
  self.shape = love.physics.newRectangleShape(Constants.SIZES.PLAYER.X, Constants.SIZES.PLAYER.Y)
  self:createFixture()

  self.color = {255, 0, 0, 255}
end

return Player
