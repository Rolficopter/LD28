local class = require 'lib/middleclass'

Drawable = class('Drawable')

function Drawable:initialize(world)
  self.world = world
  
  self.body = nil
  self.shape = nil
end
function Drawable:createFixture()
  love.physics.newFixture(self.body, self.shape)
end

function Drawable:update(dt)
  -- stub
end

function Drawable:render()
  -- stub
end
