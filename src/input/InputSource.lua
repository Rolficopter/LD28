InputSource = class('InputSource')

InputSource.Direction = {
  none = 'none',
  left = 'left',
  right = 'right',
  down = 'down',
  up = 'up'
}

function InputSource:initialize(world)
  self.world = world
end

function InputSource:updateFromExternalInput(networkClientData)
  -- stub
  -- update input here according to network input
end

function InputSource:shouldJump()
  return false
end

function InputSource:shouldShoot()
  return false
end

function InputSource:getDirection()
  return InputSource.Direction.none
end

function InputSource:getArmAngle()
  return 0
end

return InputSource
