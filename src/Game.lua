local Constants = require 'conf'
local Drawable = require 'Drawable'
local MenuManager = require 'menu/MenuManager'

Game = class('Game', Drawable)

-- Init logic
function Game:initialize()
  Drawable:initialize()
  self.menu = MenuManager:new()

  if Constants.DEBUG then
  	self.menu:switchTo(Constants.MENU.GAME.NAME)
  else
  	self.menu:switchTo(Constants.MENU.MAIN.NAME)
  end
end

-- Update logic
function Game:update(dt)
  self.menu:update(dt)
end

-- Render Logic
function Game:render()
  self.menu:render()
end

return Game
