local class = require 'lib/middleclass'
local Drawable = require 'Drawable'

Menu = class('Menu', Drawable)

function Menu:initialize()
  Drawable:initialize()
end

return Menu
