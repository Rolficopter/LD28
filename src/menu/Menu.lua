local class = require 'lib/middleclass'
local Drawable = require 'Drawable'

Menu = class('Menu', Drawable)

function Menu:initialize()
  Drawable:initialize()
end

function Menu:switchToMenu(menu)
  self.nextMenu = menu
end

return Menu
