local class = require 'lib/middleclass'
local Menu = require 'menu/Menu'

local World = require 'World'

GameMenu = class('GameMenu', Menu)

function GameMenu:initialize()
  Menu:initialize()
  
  self.world = World:new()
  
  self.color = { 255, 255, 255, 255 }
  love.graphics.setBackgroundColor(self.color)
end

function GameMenu:update(dt)
  self.world:update(dt)
end

function GameMenu:render()
  self.world:render()
end

return GameMenu
