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

  self.body:setFixedRotation(true)

  self.color = {255, 0, 0, 255}

  self.texture = love.graphics.newImage('assets/textures/man.png')
end

function Player:update(dt)
  if love.keyboard.isDown("d") then
    self.body:applyForce(400, 0)
  elseif love.keyboard.isDown("a") then
    self.body:applyForce(-400, 0)
  end
end

function Player:render()
  love.graphics.draw(self.texture, self.body:getX() - Constants.SIZES.PLAYER.X/2, self.body:getY() -  Constants.SIZES.PLAYER.Y/2, 0, Constants.SIZES.PLAYER.X / self.texture:getWidth(), Constants.SIZES.PLAYER.Y / self.texture:getHeight())
end

return Player
