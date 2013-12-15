local Constants = require 'conf'
local class = require 'lib/middleclass'
local Drawable = require 'Drawable'
local Entity = require 'Entity'
local Player = require 'Player'
local Bullet = require 'Bullet'
local KeyboardInput = require 'input/KeyboardAndMouseInput'

local atl = require 'lib/advanced-tiled-loader/Loader'

World = class('World', Drawable)

function World:initialize()
  self.entities = {}

  -- load world
  love.physics.setMeter(Constants.SIZES.METER)
  self.world = love.physics.newWorld(Constants.GRAVITY.X * Constants.SIZES.METER, Constants.GRAVITY.Y * Constants.SIZES.METER, true)

  -- load map
  atl.path = Constants.ASSETS.MAPS
  self.map = nil
  self:loadMap('Map.tmx')
end

-- Load map
function World:loadMap(name)
  self.map = atl.load(name)
  self.map.drawObjects = false

  -- load collision fields
  for i, object in pairs( self.map("Collision").objects ) do
    local entity = Entity:new(self)
    entity.color = {0, 0, 0, 0}
    entity.body = love.physics.newBody(entity:getWorld(), object.x + object.width / 2, object.y + object.height / 2, 'static')
    entity.shape = love.physics.newRectangleShape(object.width, object.height)
    entity:createFixture()

    table.insert(self.entities, entity)
  end

  -- place player at random spawnpoint
  local spawns = self.map("SpawnPoints").objects
  local randomSpawnNumber = math.random(1, table.getn(spawns))
  playerLocationObject = spawns[randomSpawnNumber]

  self.player = Player:new(self.world, playerLocationObject.x, playerLocationObject.y, KeyboardAndMouseInput:new(), self)
  table.insert(self.entities, self.player)
end

-- Insert Bullet
function World:insertBullet(angle)
	table.insert(self.entities, Bullet:new(self, self.player.body:getX(), self.player.body:getY(), angle))
  return self
end

-- Update logic
function World:update(dt)
  for i, ent in pairs( self.entities ) do
    ent:update(dt)
  end

  self.world:update(dt)
end

-- Render logic
function World:render()
  local translateX = Constants.SCREEN.WIDTH / 2 - self.player.body:getX()
  local translateY = Constants.SCREEN.HEIGHT / 2 - self.player.body:getY()

  love.graphics.translate(translateX, translateY)
  if self.map then
    self.map:autoDrawRange(translateX, translateY, 1, 0)
    self.map:draw()
  end

  for i, ent in pairs( self.entities ) do
    ent:render()
  end
end

return World
