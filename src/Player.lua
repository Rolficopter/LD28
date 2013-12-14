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
  self.fixture:setFriction(self.fixture:getFriction() * 1.75)
  self.texture = love.graphics.newImage('assets/textures/man.png')

  self.color = { 255, 0, 0, 255 }

  self.jumpWasPressed = false
  self.hasFallen = false
  self._oldVY = 0
end

function Player:update(dt)
  local direction = self.inputSource:getDirection()
  local vX, vY = self.body:getLinearVelocity()
  
  -- X
  if math.abs(vX) < Constants.SIZES.PLAYER.MAXVELOCITY then
    if direction == InputSource.Direction.left then
      if vX > 0 then
        self.body:applyLinearImpulse(Constants.SIZES.PLAYER.LEFT / 10, 0)
      else
        self.body:applyForce(Constants.SIZES.PLAYER.LEFT, 0)
      end
    elseif direction == InputSource.Direction.right then
      if vX < 0 then
        self.body:applyLinearImpulse(Constants.SIZES.PLAYER.RIGHT / 10, 0)
      else
        self.body:applyForce(Constants.SIZES.PLAYER.RIGHT, 0)
      end
    end
  end
  
  -- Y
  if vY < 0 then
    self.hasFallen = true
  elseif vY == 0 and self._oldVY - vY < 1 then
    self.hasFallen = false
  end
  if self.inputSource:shouldJump() then
    if not self.hasFallen then
      self.body:applyLinearImpulse(0, Constants.SIZES.PLAYER.JUMP)
    end
  end
  self._oldVY = vY
end

function Player:render()
  love.graphics.draw(self.texture, self.body:getX() - Constants.SIZES.PLAYER.X/2, self.body:getY() -  Constants.SIZES.PLAYER.Y/2, 0, Constants.SIZES.PLAYER.X / self.texture:getWidth(), Constants.SIZES.PLAYER.Y / self.texture:getHeight())
end

return Player
