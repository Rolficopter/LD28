local Drawable = require 'Drawable'
local Constants = require 'conf'

Entity = class('Entity', Drawable)

-- Init logic
function Entity:initialize(worldObject)
  Drawable:initialize()

  self.world = worldObject -- this is our own class!
  self.body = nil
  self.shape = nil
  self.fixture = nil
end

function Entity:createFixture()
  self.fixture = love.physics.newFixture(self.body, self.shape, 1)
  self.fixture:setUserData(Entity.name)
end

function Entity:getWorld()
  return self.world.world
end

-- Update logic
function Entity:update(dt)
  -- stub
end

-- Render logic
function Entity:render()
  -- stub
  if self.body and self.shape then
    self:applyColor()
    love.graphics.polygon('fill', self.body:getWorldPoints(self.shape:getPoints()))
    self:resetColor()
  end
end

function Entity:worldCollisionBeginContact(a, b, coll)
  --stub
end

function Entity:worldCollisionEndContact(a, b, coll)
  --stub
end

function Entity:destroy()
  if self.fixture then
    self.fixture:destroy()
  end

  if self.body then
    self.body:destroy()
  end
end

return Entity
