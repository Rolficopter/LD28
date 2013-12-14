local class = require 'lib/middleclass'
local Drawable = require 'Drawable'

Entity = class('Entity', Drawable)

function Entity:initialize(world)
  self.world = world
  
  self.body = nil
  self.shape = nil
end
function Entity:createFixture()
  love.physics.newFixture(self.body, self.shape)
end

function Entity:update(dt)
  -- stub
end

function Entity:render()
  -- stub
  if self.body and self.shape then
    self:applyColor()
    love.graphics.polygon('fill', self.body:getWorldPoints(self.shape:getPoints()))
    self:resetColor()
  end
end

return Entity
