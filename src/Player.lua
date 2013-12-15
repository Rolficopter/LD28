local Constants = require 'conf'
local class = require 'lib/middleclass'
local Entity = require 'Entity'

Player = class('Player', Entity)

-- Init logic
function Player:initialize(world, x, y, inputSource, gameWorld)
  Entity:initialize(gameWorld)

  print(self.world)
  self.inputSource = inputSource
  self.body = love.physics.newBody(self:getWorld(), x, y, 'dynamic')

  self.body:setFixedRotation(true)
  self.shape = love.physics.newRectangleShape(Constants.SIZES.PLAYER.X, Constants.SIZES.PLAYER.Y)
  self:createFixture()
  self.fixture:setFriction(self.fixture:getFriction() * 1.75)

  self.bodyTexture = love.graphics.newImage('assets/textures/player/body.png')
  self.armTexture = love.graphics.newImage('assets/textures/player/arm.png')
  self.leftLegTexture = love.graphics.newImage('assets/textures/player/leg_left.png')
  self.rightLegTexture = love.graphics.newImage('assets/textures/player/leg_right.png')
  self.leftWeaponTexture = love.graphics.newImage('assets/textures/weapon_l.png')
  self.rightWeaponTexture = love.graphics.newImage('assets/textures/weapon_r.png')

  self.color = { 200, 0, 0, 255 }

  self.jumpWasPressed = false
  self.hasFallen = false
  self._oldVY = 0

  self.armRotation = 0
  self.leftLegRotation = 0
  self.rightLegRotation = 0

  self.leftGoingLeft = true
  self.rightGoingLeft = true
end

function Player:update(dt)
  local direction = self.inputSource:getDirection()
  local vX, vY = self.body:getLinearVelocity()

  if math.abs(vX) > 2 or math.abs(vY) > 2 then
    -- left leg
    if self.leftGoingLeft then
      self.leftLegRotation = self.leftLegRotation + dt * Constants.SIZES.PLAYER.LEG_MOVEMENT_SPEED * math.abs(vX) / 100
      if self.leftLegRotation > 2 / (math.pi * 2) then
        self.leftGoingLeft = false
      end
    else
      self.leftLegRotation = self.leftLegRotation - dt * Constants.SIZES.PLAYER.LEG_MOVEMENT_SPEED * math.abs(vX) / 100
      if self.leftLegRotation < - 2 / (math.pi * 2) then
        self.leftGoingLeft = true
      end
    end

    -- right leg
    if self.rightGoingLeft then
      self.rightLegRotation = self.rightLegRotation - dt * Constants.SIZES.PLAYER.LEG_MOVEMENT_SPEED * math.abs(vX) / 100
      if self.rightLegRotation < - 2 / (math.pi * 2) then
        self.rightGoingLeft = false
      end
    else
      self.rightLegRotation = self.rightLegRotation + dt * Constants.SIZES.PLAYER.LEG_MOVEMENT_SPEED * math.abs(vX) / 100
      if self.rightLegRotation > 2 / (math.pi * 2) then
        self.rightGoingLeft = true
      end
    end
 else
    self.leftLegRotation = 0
    self.rightLegRotation = 0
  end

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

  self.armRotation = self.inputSource:getArmAngle()

 -- Determine if Player shot
  if love.mouse.isDown("l") then
    if self.world then
      self.world = self.world:insertBullet(self.armRotation)
      print(self.world)
    end
  end
end

function Player:render()
  love.graphics.setColor(self.color)

  local baseX = self.body:getX() - Constants.SIZES.PLAYER.X / 2
  local baseY = self.body:getY() - Constants.SIZES.PLAYER.Y / 2

  local scaleBodyX = self.bodyTexture:getWidth() / Constants.SIZES.PLAYER.SCALE / self.bodyTexture:getWidth()
  local scaleBodyY = self.bodyTexture:getHeight() / Constants.SIZES.PLAYER.SCALE / self.bodyTexture:getHeight()

  local scaleArmX = self.armTexture:getWidth() / Constants.SIZES.PLAYER.SCALE / self.armTexture:getWidth()
  local scaleArmY = self.armTexture:getHeight() / Constants.SIZES.PLAYER.SCALE / self.armTexture:getHeight()

  local scaleLeftLegX = self.leftLegTexture:getWidth() / Constants.SIZES.PLAYER.SCALE / self.leftLegTexture:getWidth()
  local scaleLeftLegY = self.leftLegTexture:getHeight() / Constants.SIZES.PLAYER.SCALE / self.leftLegTexture:getHeight()

  local scaleRightLegX = self.rightLegTexture:getWidth() / Constants.SIZES.PLAYER.SCALE / self.rightLegTexture:getWidth()
  local scaleRightLegY = self.rightLegTexture:getHeight() / Constants.SIZES.PLAYER.SCALE / self.rightLegTexture:getHeight()

  local scaleWeaponX = self.rightWeaponTexture:getWidth() / Constants.SIZES.PLAYER.SCALE / self.rightWeaponTexture:getWidth()
  local scaleWeaponY = self.rightWeaponTexture:getHeight() / Constants.SIZES.PLAYER.SCALE / self.rightWeaponTexture:getHeight()

  love.graphics.draw(self.bodyTexture, baseX, baseY, 0, scaleBodyX, scaleBodyY)
  love.graphics.draw(self.leftLegTexture, baseX - Constants.SIZES.PLAYER.LEG_X_OFFSET + self.leftLegTexture:getWidth() * scaleLeftLegX + 12.5, baseY + Constants.SIZES.PLAYER.LEG_Y_OFFSET, self.leftLegRotation, scaleLeftLegX, scaleLeftLegY, self.leftLegTexture:getWidth() / 2, 2)
  love.graphics.draw(self.rightLegTexture, baseX + Constants.SIZES.PLAYER.LEG_X_OFFSET + self.rightLegTexture:getWidth() * scaleRightLegX + 10, baseY + Constants.SIZES.PLAYER.LEG_Y_OFFSET, self.rightLegRotation, scaleRightLegX, scaleRightLegY, self.rightLegTexture:getWidth() / 2, 2)

 if self.armRotation < -14.22 then
	love.graphics.draw(self.armTexture, baseX + Constants.SIZES.PLAYER.ARM_X_OFFSET + self.armTexture:getWidth() * scaleArmX - 5, baseY + Constants.SIZES.PLAYER.ARM_Y_OFFSET, self.armRotation, scaleArmX, scaleArmY, self.armTexture:getWidth(), self.armTexture:getHeight() / 2)
	love.graphics.draw(self.leftWeaponTexture, baseX - Constants.SIZES.PLAYER.ARM_X_OFFSET + self.armTexture:getWidth() * scaleArmX - 5 + self.armTexture:getWidth() / Constants.SIZES.PLAYER.SCALE + 3, baseY + Constants.SIZES.PLAYER.ARM_Y_OFFSET, self.armRotation, scaleWeaponX, scaleWeaponY, self.leftWeaponTexture:getWidth(), self.leftWeaponTexture:getHeight()/2)
	love.graphics.draw(self.armTexture, baseX - Constants.SIZES.PLAYER.ARM_X_OFFSET + self.armTexture:getWidth() * scaleArmX - 5, baseY + Constants.SIZES.PLAYER.ARM_Y_OFFSET, self.armRotation, scaleArmX, scaleArmX, self.armTexture:getWidth(), self.armTexture:getHeight() / 2)

  else
	love.graphics.draw(self.armTexture, baseX - Constants.SIZES.PLAYER.ARM_X_OFFSET + self.armTexture:getWidth() * scaleArmX - 5, baseY + Constants.SIZES.PLAYER.ARM_Y_OFFSET, self.armRotation, scaleArmX, scaleArmX, self.armTexture:getWidth(), self.armTexture:getHeight() / 2)
	love.graphics.draw(self.rightWeaponTexture, baseX + Constants.SIZES.PLAYER.ARM_X_OFFSET + self.armTexture:getWidth() * scaleArmX - 5 - self.armTexture:getWidth() / Constants.SIZES.PLAYER.SCALE - 3, baseY + Constants.SIZES.PLAYER.ARM_Y_OFFSET, self.armRotation, scaleWeaponX, scaleWeaponY, self.rightWeaponTexture:getWidth(), self.rightWeaponTexture:getHeight()/2)
	love.graphics.draw(self.armTexture, baseX + Constants.SIZES.PLAYER.ARM_X_OFFSET + self.armTexture:getWidth() * scaleArmX - 5, baseY + Constants.SIZES.PLAYER.ARM_Y_OFFSET, self.armRotation, scaleArmX, scaleArmY, self.armTexture:getWidth(), self.armTexture:getHeight() / 2)
  end
end

return Player
