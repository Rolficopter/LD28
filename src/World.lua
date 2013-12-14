local Constants = require 'conf'
local class = require 'lib/middleclass'
local Drawable = require 'Drawable'
local Entity = require 'Entity'
local Player = require 'Player'
local KeyboardInput = require 'input/KeyboardInput'

local atl = require 'lib/advanced-tiled-loader/loader'

World = class('World', Drawable)

function World:initialize()
  -- load world
  love.physics.setMeter(Constants.SIZES.METER)
  self.world = love.physics.newWorld(Constants.GRAVITY.X * Constants.SIZES.METER, Constants.GRAVITY.Y * Constants.SIZES.METER, true)
  -- load map
  atl.path = 'assets/maps/'
  self.map = nil
  self.collisionFields = {}
  self:loadMap('Map.tmx')
end

-- Load map
function World:loadMap(name)
  self.map = atl.load(name)
  self.map.drawObjects = false

  -- load collision fields
  for i, object in pairs( self.map("Collision").objects ) do
    local entity = Entity:new(self.world)
    entity.color = {0, 0, 0, 0}
    entity.body = love.physics.newBody(self.world, object.x + object.width / 2, object.y + object.height / 2, 'static')
    entity.shape = love.physics.newRectangleShape(object.width, object.height)
    entity:createFixture()

    table.insert(self.collisionFields, entity)
  end

  -- place player at random spawnpoint
  playerLocationObject = self.map("SpawnPoints").objects[3]

  self.player = Player:new(self.world, playerLocationObject.x, playerLocationObject.y, KeyboardInput:new())
end

-- Update logic
function World:update(dt)
  self.world:update(dt)

  self.player:update(dt)
end

-- Render logic
function World:render()
  local translateX = Constants.SCREEN.WIDTH / 2 - self.player.body:getX()
  local translateY = Constants.SCREEN.HEIGHT / 2 - self.player.body:getY()

  love.graphics.translate(translateX, translateY)
  if self.map then
    self.map:autoDrawRange (translateX, translateY, 1, 0)
    self.map:draw()
  end
  
  --self.ground:render()
  self.player:render()
end

return World
