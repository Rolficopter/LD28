local class = require 'lib/middleclass'
local InputSource = require 'input/InputSource'

KeyboardAndMouseInput = class('KeyboardAndMouseInput', InputSource)

local keyboard = love.keyboard

function KeyboardAndMouseInput:initialize(world)
  InputSource:initialize(world)
  self.jumpWasPressed = false
end

function KeyboardAndMouseInput:shouldJump()
  if ( keyboard.isDown("w") or keyboard.isDown("up") ) then
    if not self.jumpWasPressed then
      self.jumpWasPressed = true
      return true
    end
  else
    self.jumpWasPressed = false
  end

  return false
end

function KeyboardAndMouseInput:getDirection()
  local direction = InputSource.Direction.none

  if keyboard.isDown("s") or keyboard.isDown("down") then
    if direction == InputSource.Direction.none then
      direction = InputSource.Direction.down
    else
      direction = InputSource.Direction.none
    end
  end

  if keyboard.isDown("a") or keyboard.isDown("left") then
    direction = InputSource.Direction.left
  end
  if keyboard.isDown("d") or keyboard.isDown("right") then
    if direction == InputSource.Direction.none then
      direction = InputSource.Direction.right
    else
      direction = InputSource.Direction.none
    end
  end

  return direction
end

function KeyboardAndMouseInput:getArmAngle(posX, posY)
  return -math.atan2( posX - love.mouse.getX() ,  posY - love.mouse.getY()) - (90/(math.pi*2))
end

return KeyboardAndMouseInput
