local Constants = require 'conf'
local class = require 'lib/middleclass'
local Menu = require 'menu/Menu'

MainMenu = class('MainMenu', Menu)

function MainMenu:initialize()
  Menu:initialize()
end

function MainMenu:update(dt)
  if love.keyboard.isDown("escape") then
    love.event.quit()
  end
  
  if love.keyboard.isDown("1") then
    self:switchToMenu(Constants.MENU.GAME)
  end
end

function MainMenu:render()
  local text = "Welcome to " .. Constants.TITLE .. " by " .. Constants.AUTHOR
  love.graphics.print(text, 10, 10)
  
  love.graphics.print("1: Start game", 10, 50)
  love.graphics.print("ESC: Quit", 10, 70)
end

return MainMenu
