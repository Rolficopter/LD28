local Menu = require 'menu/Menu'

local World = require 'World'

GameMenu = class('GameMenu', Menu)

function GameMenu:initialize(networkClient)
  Menu:initialize()
  
  self.world = World:new(networkClient)
  
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
  love.graphics.push()
  self.world:render()
  love.graphics.pop()

  if love.keyboard.isDown("tab") then
    self:renderScoreTable()
  end
end

function GameMenu:renderScoreTable()
  love.graphics.setColor({0, 0, 0, 150})
  love.graphics.rectangle("fill", 100, 100, love.graphics.getWidth() - 100 * 2, love.graphics.getHeight() - 100 * 2)

  local players = table.shallow_copy(self.world.players)

  love.graphics.setColor({255, 255, 255, 150})

  table.insert(players, self.world.player)
  local c = 0
  love.graphics.print("Player", 110, 120)
  love.graphics.print("Points", 110+ love.graphics.getWidth() - 150 * 2 - 10, 120)
  for i, p in pairs(players) do
    local x = 0
    local y = c * 30
    love.graphics.print(p.inputSource.clientID, 110 + x, 150 + y)
    love.graphics.print(p.points, 110 + x + love.graphics.getWidth() - 100 * 2 - 50, 150 + y)
    c = c + 1
  end
end

function table.shallow_copy(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end

return GameMenu
