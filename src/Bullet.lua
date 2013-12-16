local Constants = require 'conf'
local class = require 'lib/middleclass'
local Entity = require 'Entity'

Bullet = class('Bullet', Entity)

-- Init logic
function Bullet:initialize(gameWorld, x, y, angle)
  Entity:initialize(world)

  self.gameWorld = gameWorld
  self.body = love.physics.newBody(gameWorld.world, x, y, 'dynamic')
  self.body:setFixedRotation(true)
  self.shape = love.physics.newRectangleShape(Constants.SIZES.BULLET.X, Constants.SIZES.BULLET.Y)
  self.color = { 0, 0, 0, 255 }
  self:createFixture()
  self.fixture:setUserData("bullet")

  self.body:setGravityScale(0)
  if angle < math.pi then
    if(angle > 1/2 * math.pi) then
      self.body:applyLinearImpulse(Constants.SIZES.BULLET.SPEED, -math.abs(Constants.SIZES.BULLET.SPEED * math.tan(angle)))
    else
      self.body:applyLinearImpulse(-Constants.SIZES.BULLET.SPEED, -math.abs(Constants.SIZES.BULLET.SPEED * math.tan(angle)))
    end
  elseif(angle < 1.5 * math.pi) then
    self.body:applyLinearImpulse(Constants.SIZES.BULLET.SPEED, math.abs(Constants.SIZES.BULLET.SPEED * math.tan(angle)))
  else
    self.body:applyLinearImpulse(-Constants.SIZES.BULLET.SPEED, math.abs(Constants.SIZES.BULLET.SPEED * math.tan(angle)))
  end
end


function Bullet:update(dt)
	Entity:update(dt)

end

return Bullet
