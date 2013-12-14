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
end
