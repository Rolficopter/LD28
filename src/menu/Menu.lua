local Drawable = require 'Drawable'

Menu = class('Menu', Drawable)

function Menu:initialize()
  Drawable:initialize()
end

function Menu:switchToMenu(menu, data)
	self.nextMenu = menu
	self.nextMenuData = data
end

return Menu
