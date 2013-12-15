local class = require 'lib/middleclass'
local Drawable = require 'Drawable'
local Constants = require 'conf'

Entity = class('Entity', Drawable)

-- Init logic
function Entity:initialize(world)
  self.world = world

  self.body = nil
  self.shape = nil
  self.fixture = nil
end
function Entity:createFixture()
  self.fixture = love.physics.newFixture(self.body, self.shape, 1)
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

return Entity
