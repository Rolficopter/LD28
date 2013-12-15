local Constants = require 'conf'

local MainMenu = require 'menu/MainMenu'
local GameMenu = require 'menu/GameMenu'
local MultiplayerMenu = require 'menu/MultiplayerMenu'

MenuManager = class('MenuManager')

function MenuManager:initialize()
  self.currentMenu = nil
  self.menus = {}
end

local loadMenu = function(self, menu, data)
  if not self.menus[menu] then
    if menu == Constants.MENU.MAIN.NAME then
      self.menus[menu] = MainMenu:new()
    elseif menu == Constants.MENU.GAME.NAME then
      self.menus[menu] = GameMenu:new()
    elseif menu == Constants.MENU.NET.NAME then
      self.menus[menu] = MultiplayerMenu:new(data)
    end
  end
  
  self.currentMenu = self.menus[menu]
end
function MenuManager:switchTo(menu, data)
  loadMenu(self, menu, data)
end

function MenuManager:update(dt)
  if self.currentMenu.nextMenu then
    local nextMenu = self.currentMenu.nextMenu
    local nextMenuData = self.currentMenu.nextMenuData
    self.currentMenu.nextMenu = nil
    self.currentMenu.nextMenuData = nil
    
    self:switchTo(nextMenu, nextMenuData)
  end
  self.currentMenu:update(dt)
end
function MenuManager:render()
  self.currentMenu:render()
end

return MenuManager
