--[[
  Ludum Rolfing: LD48
  main.lua
]]--

local Game = require 'Game'

local game = nil

function love.load()
  game = Game:new()
end

function love.draw()
  game:render()
end

function love.update(dt)
  game:update(dt)

  love.keyboard.updateKeys()
end

love.keyboard.keysPressed = { }
love.keyboard.keysReleased = { }

function love.keyboard.wasPressed(key)
  if (love.keyboard.keysPressed[key]) then
    return true
  else
    return false
  end
end

function love.keyboard.wasReleased(key)
  if (love.keyboard.keysReleased[key]) then
    return true
  else
    return false
  end
end

function love.keypressed(key, unicode)
  love.keyboard.keysPressed[key] = true
end

function love.keyreleased(key)
  love.keyboard.keysReleased[key] = true
end

function love.keyboard.updateKeys()
  love.keyboard.keysPressed = { }
  love.keyboard.keysReleased = { }
end