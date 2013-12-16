local Constants = require 'conf'
local Entity = require 'Entity'

Player = class('Player', Entity)

local instance = nil
-- Callbacks
local _checkForGroundCollision = function(a, b, coll, begin)
  if a == instance.groundSensor.fixture or b == instance.groundSensor.fixture then

    local userData = nil
    if a == instance.groundSensor.fixture then
      userData = b:getUserData()
    elseif b == instance.groundSensor.fixture then
      userData = a:getUserData()
    end
    if userData == "map" or userData == "player" or userData == "bullet" then
      instance.onGround = begin
    end

  end
end
local _worldCollision_BeginContact = function(a, b, coll)
  _checkForGroundCollision(a, b, coll, true)
end
local _worldCollision_EndContact = function(a, b, coll)
  _checkForGroundCollision(a, b, coll, false)
end

-- Init logic
function Player:initialize(world, x, y, inputSource)
  Entity:initialize(world)
  assert(inputSource:isInstanceOf(InputSource), "Specify a input source!")

  self.inputSource = inputSource
  self.body = love.physics.newBody(self:getWorld(), x, y, 'dynamic')

  self.body:setFixedRotation(true)
  self.shape = love.physics.newRectangleShape(Constants.SIZES.PLAYER.X, Constants.SIZES.PLAYER.Y)
  self:createFixture()
  self.fixture:setUserData('player')
  self.fixture:setFriction(self.fixture:getFriction() * 1.75)
  -- jump sensor
  self.groundSensor = {}
  self.groundSensor.body = love.physics.newBody(self:getWorld(), self.body:getX(), (self.body:getY() + Constants.SIZES.PLAYER.Y / 2) - 5, 'dynamic')
  self.groundSensor.shape = love.physics.newRectangleShape(Constants.SIZES.PLAYER.X - 10, 10)
  self.groundSensor.fixture = love.physics.newFixture(self.groundSensor.body, self.groundSensor.shape)
  self.groundSensor.fixture:setFriction(0)
  self.groundSensor.fixture:setSensor(true)
  self.groundSensor.joint = love.physics.newWeldJoint(self.body, self.groundSensor.body, self.body:getX(), self.body:getY(), false)
  self:getWorld():setCallbacks(_worldCollision_BeginContact, _worldCollision_EndContact, nil, nil)
  instance = self

  self.bodyTexture = love.graphics.newImage('assets/textures/player/body.png')
  self.armTexture = love.graphics.newImage('assets/textures/player/arm.png')
  self.leftLegTexture = love.graphics.newImage('assets/textures/player/leg_left.png')
  self.rightLegTexture = love.graphics.newImage('assets/textures/player/leg_right.png')
  self.leftWeaponTexture = love.graphics.newImage('assets/textures/weapon_l.png')
  self.rightWeaponTexture = love.graphics.newImage('assets/textures/weapon_r.png')

  self.color = { 200, 0, 0, 255 }

  self.jumpWasPressed = false
  self.onGround = false

  self.armRotation = 0
  self.leftLegRotation = 0
  self.rightLegRotation = 0

  self.leftGoingLeft = true
  self.rightGoingLeft = true

  self.canShoot = true
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
  if self.inputSource:shouldJump() then
    if self.onGround then
      self.onGround = false
      self.body:applyLinearImpulse(0, Constants.SIZES.PLAYER.JUMP)
    end
  end

  local baseX = self.body:getX() - Constants.SIZES.PLAYER.X / 2
  local baseY = self.body:getY() - Constants.SIZES.PLAYER.Y / 2
  local scaleArmX = self.armTexture:getWidth() / Constants.SIZES.PLAYER.SCALE / self.armTexture:getWidth()
  local scaleArmY = self.armTexture:getHeight() / Constants.SIZES.PLAYER.SCALE / self.armTexture:getHeight()
  local scaleWeaponX = self.rightWeaponTexture:getWidth() / Constants.SIZES.PLAYER.SCALE / self.rightWeaponTexture:getWidth()
  local scaleWeaponY = self.rightWeaponTexture:getHeight() / Constants.SIZES.PLAYER.SCALE / self.rightWeaponTexture:getHeight()
   
  self.armRotationLeft = self.inputSource:getArmAngle(Constants.SIZES.PLAYER.ARM_X_OFFSET, -Constants.SIZES.PLAYER.ARM_Y_OFFSET + self.armTexture:getWidth() * scaleArmX / 2)
  self.armRotationRight = self.inputSource:getArmAngle(-Constants.SIZES.PLAYER.ARM_X_OFFSET, -Constants.SIZES.PLAYER.ARM_Y_OFFSET)

  -- Determine if Player shot
  if self.inputSource:shouldShoot() then
    if self.world and self.canShoot then
      local bulletRotation = self.inputSource:getArmAngle(0, -Constants.SIZES.PLAYER.ARM_Y_OFFSET)
      local magicNumber = 35
      self.world = self.world:insertBullet(bulletRotation, baseX - math.cos(bulletRotation) * magicNumber + Constants.SIZES.PLAYER.ARM_X_OFFSET + 10, baseY - math.sin(bulletRotation) * magicNumber + Constants.SIZES.PLAYER.ARM_Y_OFFSET - self.leftWeaponTexture:getHeight() * scaleWeaponY / 2)
      self.canShoot = false
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
  local weaponAngle = self.inputSource:getArmAngle(0, -Constants.SIZES.PLAYER.ARM_Y_OFFSET) - 1.5 * math.pi

  if not ((weaponAngle > 0 and weaponAngle < math.pi * 0.5) or  (weaponAngle > -(1.5 * math.pi) and weaponAngle < -math.pi)) then
    love.graphics.draw(self.armTexture, baseX + Constants.SIZES.PLAYER.ARM_X_OFFSET + self.armTexture:getWidth() * scaleArmX - 5, baseY + Constants.SIZES.PLAYER.ARM_Y_OFFSET, self.armRotationLeft, scaleArmX, scaleArmY, self.armTexture:getWidth(), self.armTexture:getHeight() / 2)
    love.graphics.draw(self.leftWeaponTexture, baseX - Constants.SIZES.PLAYER.ARM_X_OFFSET + self.armTexture:getWidth() * scaleArmX - 5 + self.armTexture:getWidth() / Constants.SIZES.PLAYER.SCALE + 3, baseY + Constants.SIZES.PLAYER.ARM_Y_OFFSET, self.armRotationLeft, scaleWeaponX, scaleWeaponY, self.leftWeaponTexture:getWidth(), self.leftWeaponTexture:getHeight()/2)
    love.graphics.draw(self.armTexture, baseX - Constants.SIZES.PLAYER.ARM_X_OFFSET + self.armTexture:getWidth() * scaleArmX - 5, baseY + Constants.SIZES.PLAYER.ARM_Y_OFFSET, self.armRotationRight, scaleArmX, scaleArmX, self.armTexture:getWidth(), self.armTexture:getHeight() / 2)
  else
    love.graphics.draw(self.armTexture, baseX - Constants.SIZES.PLAYER.ARM_X_OFFSET + self.armTexture:getWidth() * scaleArmX - 5, baseY + Constants.SIZES.PLAYER.ARM_Y_OFFSET, self.armRotationRight, scaleArmX, scaleArmX, self.armTexture:getWidth(), self.armTexture:getHeight() / 2)
    love.graphics.draw(self.rightWeaponTexture, baseX + Constants.SIZES.PLAYER.ARM_X_OFFSET + self.armTexture:getWidth() * scaleArmX - 5 - self.armTexture:getWidth() / Constants.SIZES.PLAYER.SCALE - 3, baseY + Constants.SIZES.PLAYER.ARM_Y_OFFSET, self.armRotationRight, scaleWeaponX, scaleWeaponY, self.rightWeaponTexture:getWidth(), self.rightWeaponTexture:getHeight()/2)
    love.graphics.draw(self.armTexture, baseX + Constants.SIZES.PLAYER.ARM_X_OFFSET + self.armTexture:getWidth() * scaleArmX - 5, baseY + Constants.SIZES.PLAYER.ARM_Y_OFFSET, self.armRotationLeft, scaleArmX, scaleArmY, self.armTexture:getWidth(), self.armTexture:getHeight() / 2)
  end
end

return Player
