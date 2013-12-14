local class = require 'lib/middleclass'
local InputSource = require 'input/InputSource'

KeyboardInput = class('KeyboardInput', InputSource)

local keyboard = love.keyboard

function KeyboardInput:initialize()
  self.jumpWasPressed = false
end

function KeyboardInput:shouldJump()
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
function KeyboardInput:getDirection()
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

return KeyboardInput
