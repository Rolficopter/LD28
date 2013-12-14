local Constants = require 'conf'
local class = require 'lib/middleclass'
local Entity = require 'Entity'

Player = class('Player', Entity)

-- Init logic
function Player:initialize(world, x, y, inputSource)
  Entity:initialize(world)
  self.inputSource = inputSource
  
  self.body = love.physics.newBody(self.world, x, y, 'dynamic')
  self.body:setFixedRotation(true)
  self.shape = love.physics.newRectangleShape(Constants.SIZES.PLAYER.X, Constants.SIZES.PLAYER.Y)
  self:createFixture()
  self.texture = love.graphics.newImage('assets/textures/man.png')

  self.color = { 255, 0, 0, 255 }

  self.jumpWasPressed = false
  self.hasFallen = false
end

function Player:update(dt)
  local direction = self.inputSource:getDirection()
  local vX, vY = self.body:getLinearVelocity()
  
  -- X
  if direction == InputSource.Direction.left then
    if vX > 0 then
      self.body:applyLinearImpulse(Constants.SIZES.PLAYER.LEFT, 0)
    else
      self.body:applyForce(Constants.SIZES.PLAYER.LEFT, 0)
    end
  elseif direction == InputSource.Direction.right then
    if vX < 0 then
      self.body:applyLinearImpulse(Constants.SIZES.PLAYER.RIGHT, 0)
    else
      self.body:applyForce(Constants.SIZES.PLAYER.RIGHT, 0)
    end
  end
  
  -- Y
  if vY < 0 then
    self.hasFallen = true
  end
  if self.inputSource:shouldJump() then
    if self.hasFallen then
      self.body:applyLinearImpulse(0, Constants.SIZES.PLAYER.JUMP)
    end
  end
end

function Player:render()
  love.graphics.draw(self.texture, self.body:getX() - Constants.SIZES.PLAYER.X/2, self.body:getY() -  Constants.SIZES.PLAYER.Y/2, 0, Constants.SIZES.PLAYER.X / self.texture:getWidth(), Constants.SIZES.PLAYER.Y / self.texture:getHeight())
end

return Player
