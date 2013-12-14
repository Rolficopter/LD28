local Constants = require 'conf'
local class = require 'lib/middleclass'
local Drawable = require 'Drawable'
local Entity = require 'Entity'
local Player = require 'Player'

local atl = require 'lib/advanced-tiled-loader/loader'

World = class('World', Drawable)

-- Init logic
local createTempWorld = function(self)
  self.ground = {}
  self.ground = Entity:new(self.world)
  self.ground.color = { 50, 230, 50, 230 }
  self.ground.body = love.physics.newBody(self.world, Constants.SCREEN.WIDTH / 2, Constants.SCREEN.HEIGHT - 50, 'static')
  self.ground.shape = love.physics.newRectangleShape(Constants.SCREEN.WIDTH * 2, 100)
  self.ground.fixture = love.physics.newFixture(self.ground.body, self.ground.shape)
  
  self.player = Player:new(self.world, 10 + Constants.SIZES.PLAYER.X / 2, 10 + Constants.SIZES.PLAYER.Y / 2)
end
function World:initialize()
  love.physics.setMeter(Constants.SIZES.METER)
  self.world = love.physics.newWorld(Constants.GRAVITY.X * Constants.SIZES.METER, Constants.GRAVITY.Y * Constants.SIZES.METER, true)
  -- TODO replace with Tiled map
  -- createTempWorld(self)
  -- TODO extend Tiled map loading
  self.map = nil
  atl.path = 'assets/maps/'

  self:loadMap('Map.tmx')
end

-- Load map
function World:loadMap(name)
  self.map = atl.load(name)
end

-- Update logic
function World:update(dt)
  self.world:update(dt)
end

-- Render logic
function World:render()
  if self.map then
    self.map:draw()
  end
  
  --self.ground:render()
  --self.player:render()
end

return World
