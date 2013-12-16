local KeyboardAndMouseInput = require 'input/KeyboardAndMouseInput'

NetworkInput = class('NetworkInput', KeyboardAndMouseInput)

function NetworkInput:initialize(world, networkClient, isRemote)
	InputSource:initialize(world)
	self.isRemote = isRemote -- is the client 
	self.networkClient = networkClient

	self.lastDirection = InputSource.Direction.none
	self.lastArmAngle = 0
	self.lastShouldJump = false
end

function NetworkInput:sendMessage(message, data)
	local msg = message
	if data then
		msg = msg .. ':' .. data
	end

	print("Sending " .. message .. ", data:", data)
	self.networkClient:send(msg)
end

function NetworkInput:updateFromExternalInput(networkClientData)
	KeyboardAndMouseInput:updateFromExternalInput(networkClientData)

	error("Not implemented")
end

function NetworkInput:shouldJump()
	self.lastShouldJump = false

	if not self.isRemote then
		local shouldJump = KeyboardAndMouseInput:shouldJump()

		if shouldJump then
			self.lastShouldJump = shouldJump
			self:sendMessage('jump')
		end
	end

	return self.lastShouldJump
end

function NetworkInput:getDirection()
	if not self.isRemote then
		local direction = KeyboardAndMouseInput:getDirection()

		if ( direction ~= self.lastDirection ) then
			self.lastDirection = direction
			self:sendMessage('direction', direction)
		end
	end

	return self.lastDirection
end

function NetworkInput:getArmAngle()
	if not self.isRemote then
		local armAngle = KeyboardAndMouseInput:getArmAngle(0, 0)

		if ( armAngle ~= self.lastArmAngle ) then
			self.lastArmAngle = armAngle
			self:sendMessage('armAngle', armAngle)
		end
	end

	return self.lastArmAngle
end

return NetworkInput
