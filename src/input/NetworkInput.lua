local InputSource = require 'input/InputSource'

NetworkInput = class('NetworkInput', InputSource)

function NetworkInput:initialize(world)
	InputSource:initialize(world)
end

function NetworkInput:updateFromExternalInput(networkClientData)
	InputSource:updateFromExternalInput(networkClientData)

	error("Not implemented")
end

function NetworkInput:shouldJump()
	return false
end

function NetworkInput:getDirection()
	return InputSource.Direction.none
end

function NetworkInput:getArmAngle()
	return 0
end

return NetworkInput
