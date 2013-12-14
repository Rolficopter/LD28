local class = require 'lib/middleclass'
local Menu = require 'menu/Menu'

MainMenu = class('MainMenu', Menu)

function MainMenu:initialize()
  Menu:initialize()
end

function MainMenu:render()
  love.graphics.print("Welcome", 10, 10)
end

return MainMenu
