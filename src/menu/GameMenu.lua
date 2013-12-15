local class = require 'lib/middleclass'
local Menu = require 'menu/Menu'

local World = require 'World'

GameMenu = class('GameMenu', Menu)

function GameMenu:initialize()
  Menu:initialize()
  
  self.world = World:new()
  
  self.color = { 255, 255, 255, 255 }
  love.graphics.setBackgroundColor(self.color)

  self.ingameMusic = love.audio.newSource('assets/music/ingame.mp3')
end

function GameMenu:update(dt)
  if self.ingameMusic:isStopped() then
    self.ingameMusic:play()
  end
  
  self.world:update(dt)
end

function GameMenu:render()
  self.world:render()
end

return GameMenu
