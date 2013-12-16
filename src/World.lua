function string.starts(String, Start)
   return string.sub(String, 1, string.len(Start)) == Start
end
function string.ends(String, End)
   return End == '' or string.sub(String, -string.len(End)) == End
end
function string:split( inSplitPattern, outResults )

   if not outResults then
      outResults = { }
   end
   local theStart = 1
   local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
   while theSplitStart do
      table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
      theStart = theSplitEnd + 1
      theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
   end
   table.insert( outResults, string.sub( self, theStart ) )
   return outResults
end

local Constants = require 'conf'
local Drawable = require 'Drawable'
local Entity = require 'Entity'
local Player = require 'Player'
local Bullet = require 'Bullet'
local KeyboardInput = require 'input/KeyboardAndMouseInput'
local NetworkInput = require 'input/NetworkInput'

local atl = require 'lib/advanced-tiled-loader/Loader'

World = class('World', Drawable)

function World:initialize(networkClient)
  self.entities = {}
  self.networkClient = networkClient

  -- load world
  love.physics.setMeter(Constants.SIZES.METER)
  self.world = love.physics.newWorld(Constants.GRAVITY.X * Constants.SIZES.METER, Constants.GRAVITY.Y * Constants.SIZES.METER, true)

  -- load map
  atl.path = Constants.ASSETS.MAPS
  self.map = nil

  if not self:isNetworkedWorld() then
    self:loadMap('Map.tmx')
  end
end
function World:isNetworkedWorld()
  return self.networkClient ~= nil
end

-- Load map
function World:loadMap(name)
  print("Loading map", name)
  self.map = atl.load(name)
  self.map.drawObjects = false

  -- load collision fields
  for i, object in pairs( self.map("Collision").objects ) do
    local entity = Entity:new(self)
    entity.color = {0, 0, 0, 0}
    entity.body = love.physics.newBody(entity:getWorld(), object.x + object.width / 2, object.y + object.height / 2, 'static')
    entity.shape = love.physics.newRectangleShape(object.width, object.height)
    entity:createFixture()
    entity.fixture:setUserData("map")

    table.insert(self.entities, entity)
  end

  -- place player at random spawnpoint
  local spawns = self.map("SpawnPoints").objects
  local randomSpawnNumber = math.random(1, table.getn(spawns))
  playerLocationObject = spawns[randomSpawnNumber]

  if not self:isNetworkedWorld() then
    self.player = Player:new(self, playerLocationObject.x, playerLocationObject.y, KeyboardAndMouseInput:new())
    table.insert(self.entities, self.player)
    -- clone for now
    local ai = Player:new(self, playerLocationObject.x + 50, playerLocationObject.y, KeyboardAndMouseInput:new())
    table.insert(self.entities, ai)
  else
    self.player = Player:new(self, playerLocationObject.x, playerLocationObject.y, NetworkInput:new(self, self.networkClient, false))
    table.insert(self.entities, self.player)
    -- other players created on message
  end

  print("Map loaded.")
end

-- Insert Bullet
function World:insertBullet(angle, posX, posY)
  table.insert(self.entities, Bullet:new(self, posX, posY, angle))
  if self:isNetworkedWorld() then
    self.networkClient:send('Bullet:' .. angle .. ',' .. posX .. ',' .. posY)
  end
  return self
end

-- Update logic
local updateWithNetworkInput = function(self, input)
  if string.starts(input, "Map") then
    local mapName = string.sub(input, 5, string.len(input))
    self:loadMap(mapName .. '.tmx')
  end
end
function World:update(dt)
  local networkData = nil
  if self:isNetworkedWorld() then
    networkData = self.networkClient:receive()
    if networkData then
      -- print(networkData)
      updateWithNetworkInput(self, networkData)
    end
  end

  for i, ent in pairs( self.entities ) do
    if networkData and ent.inputSource then
      print("Update input source")
      ent.inputSource:updateFromExternalInput(networkData)
    end

    ent:update(dt)
  end

  self.world:update(dt)
end

-- Render logic
function World:render()
  local translateX = 0
  local translateY = 0
  if self.player then
    translateX = Constants.SCREEN.WIDTH / 2 - self.player.body:getX()
    translateY = Constants.SCREEN.HEIGHT / 2 - self.player.body:getY()

    love.graphics.translate(translateX, translateY)
  end

  if self.map then
    self.map:autoDrawRange(translateX, translateY, 1, 0)
    self.map:draw()

    for i, ent in pairs( self.entities ) do
      ent:render()
    end
  else
    -- Loading screen
    local font = love.graphics.getFont()
    local text = "Waiting for server..."
    love.graphics.printf(text, ( love.graphics.getWidth() - font:getWidth(text) ) / 2, love.graphics.getHeight() / 2, love.graphics.getWidth() / 2, "left")
  end
end

return World
