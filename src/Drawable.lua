local Updateable = require 'Updateable'

Drawable = class('Drawable', Updateable)

function Drawable:initialize()
	Updateable:initialize()

	self.color = { 255, 255, 255, 255 }
	self._drawColor = nil
end

function Drawable:render()
  -- stub
end

-- Render Helpers Functions
function Drawable:applyColor()
  local r, g, b, a = love.graphics.getColor()
  self._drawColor = { r, g, b, a }
  love.graphics.setColor(self.color)
end
function Drawable:resetColor()
  love.graphics.setColor(self._drawColor)
end

return Drawable
