local Constants = require 'conf'
local class = require 'lib/middleclass'
local Entity = require 'Entity'

Player = class('Player', Entity)

-- Init logic
function Player:initialize(world, x, y)
  Entity:initialize(world)
  
  self.body = love.physics.newBody(self.world, x, y, 'dynamic')
  self.body:setFixedRotation(true)
  self.shape = love.physics.newRectangleShape(Constants.SIZES.PLAYER.X, Constants.SIZES.PLAYER.Y)
  self:createFixture()
  self.texture = love.graphics.newImage('assets/textures/man.png')

  self.color = {255, 0, 0, 255}

  self.jumpWasPressed = false
end

function Player:update(dt)
  if love.keyboard.isDown("d") then
    self.body:applyForce(5000, 0)
  elseif love.keyboard.isDown("a") then
    self.body:applyForce(-5000, 0)
  end
  if love.keyboard.isDown("w") and not self.jumpWasPressed then
    self.body:applyLinearImpulse(0, -5000)
    self.jumpWasPressed = true
  elseif love.keyboard.isDown("w") then
    self.jumpWasPressed = true
  else
    self.jumpWasPressed = false
  end
end

function Player:render()
  love.graphics.draw(self.texture, self.body:getX() - Constants.SIZES.PLAYER.X/2, self.body:getY() -  Constants.SIZES.PLAYER.Y/2, 0, Constants.SIZES.PLAYER.X / self.texture:getWidth(), Constants.SIZES.PLAYER.Y / self.texture:getHeight())
end

return Player
