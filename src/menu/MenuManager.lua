local Constants = require 'conf'
local class = require 'lib/middleclass'

local MainMenu = require 'menu/MainMenu'
local GameMenu = require 'menu/GameMenu'

MenuManager = class('MenuManager')

function MenuManager:initialize()
  self.currentMenu = nil
  self.menus = {}
end

local loadMenu = function(self, menu)
  if not self.menus[menu] then
    if menu == Constants.MENU.MAIN then
      self.menus[menu] = MainMenu:new()
    elseif menu == Constants.MENU.GAME then
      self.menus[menu] = GameMenu:new()
    end
  end
  
  self.currentMenu = self.menus[menu]
end
function MenuManager:switchTo(menu)
  loadMenu(self, menu)
end
MenuManager.static.switchTo = switchTo

function MenuManager:update(dt)
  if self.currentMenu.nextMenu then
    local nextMenu = self.currentMenu.nextMenu
    self.currentMenu.nextMenu = nil
    
    self:switchTo(nextMenu)
  end
  self.currentMenu:update(dt)
end
function MenuManager:render()
  self.currentMenu:render()
end

return MenuManager
