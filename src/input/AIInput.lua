local InputSource = require 'input/InputSource'
local Player = require 'Player'

AIInput = class('AIInput', InputSource)

local keyboard = love.keyboard

function AIInput:initialize(world)
  InputSource:initialize(world)
  self.world = world
  self.timeStart = os.clock()
  self.jumpWasPressed = false
  math.randomseed(os.clock())
   Ray = {
        hitList = {}
    }
end

function AIInput:shouldJump()
  local random = math.random(4)
  if ( random == 3) then
    if not self.jumpWasPressed and self.direction ~= InputSource.Direction.none then
      self.jumpWasPressed = true
      return true
    end
  else
    self.jumpWasPressed = false
  end

  return false
end

local armRotation = 0;

function AIInput:shouldShoot()
	self:rayTracing()
	local angle2Rad = math.pi/180
	for i, ent in pairs( Ray.hitList ) do
		for j, player in pairs( self.world.players) do
			if ent.x >= player.body:getX() and ent.x <= player.body:getX() + Constants.SIZES.PLAYER.X and ent.y >= player.body:getY() and ent.y <= player.body:getY() + Constants.SIZES.PLAYER.Y  then
				armRotation = (360-(i-1)*5)/angle2Rad
				-- print("-----------")
				return true
			end
	end
  end
  return false
end

function AIInput:getDirection()

  if(os.clock() - self.timeStart > 5) then
    self.direction = InputSource.Direction.none
    -- print(os.clock())
	self.timeStart = os.clock()
	local random = math.random(4)
    --if random == 0 then
    --  if self.direction == InputSource.Direction.none then
    --    self.direction = InputSource.Direction.down
     -- else
     --   self.direction = InputSource.Direction.none
     -- end
    --end

    if random == 2 then
      self.direction = InputSource.Direction.left
    end
    if random == 3 then
	  self.direction = InputSource.Direction.right
	end
  end

  return self.direction
end

function AIInput:getArmAngle(posX, posY)
  return armRotation
end

function AIInput:rayTracing()
   Ray.hitList = {}
   local angle2Rad = math.pi/180
   for i = 0, 360, 5 do
	  local x = math.cos(angle2Rad*i) * 200
	  local y = math.sin(angle2Rad*i) * 200
	  self.world.world:rayCast(
	  self.world.player.body:getX()+x/1.5,
	  self.world.player.body:getY()+x/1.5,
	  self.world.player.body:getX()+x,
	  self.world.player.body:getY()+y,
	  worldRayCastCallback)
   end
end

function worldRayCastCallback(fixture, x, y, xn, yn, fraction)
    local hit = {}
    hit.x, hit.y = x, y
    table.insert(Ray.hitList, hit)
    return 1 -- Continues with ray cast through all shapes.
end

return AIInput
