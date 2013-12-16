local KeyboardAndMouseInput = require 'input/KeyboardAndMouseInput'

NetworkInput = class('NetworkInput', KeyboardAndMouseInput)

function NetworkInput:initialize(world, networkClient, isRemote, remoteClientID)
	InputSource:initialize(world)
	self.isRemoteClient = isRemote
	self.clientID = remoteClientID
	self.networkClient = networkClient

	self.lastDirection = InputSource.Direction.none
	self.lastArmAngle = 0
	self.lastShouldJump = false
end
function NetworkInput:isRemote()
	return self.isRemoteClient
end

function NetworkInput:sendMessage(message, data)
	local msg = self.clientID .. ':' .. message
	if data then
		msg = msg .. ':' .. data
	end

	-- print("Sending " .. message .. ", data:", data)
	self.networkClient:send(msg)
end

function NetworkInput:updateFromExternalInput(networkClientData)
	KeyboardAndMouseInput:updateFromExternalInput(networkClientData)

	if self:isRemote() then
		local inputs = networkClientData:split(':')

		-- if this is a remote client with the id we handle here
		if inputs[1] == self.clientID then
			local message = inputs[2]
			local data = inputs[3]

			if message == 'jump' then
				self.lastShouldJump = true
			end
			if message == 'shoot' then
				self.lastShouldShoot = true
			end
			if message == 'direction' then
				self.lastDirection = data
			end
			if message == 'armAngle' then
				self.lastArmAngle = tonumber(data)
			end
		end		
	end
end

function NetworkInput:shouldJump()
	self.lastShouldJump = false

	if not self:isRemote() then
		local shouldJump = KeyboardAndMouseInput:shouldJump()

		if shouldJump then
			self.lastShouldJump = shouldJump
			self:sendMessage('jump')
		end
	end

	return self.lastShouldJump
end

function NetworkInput:shouldShoot()
  self.lastShouldShoot = false

  if not self:isRemote() then
  	local shouldShoot = KeyboardAndMouseInput:shouldShoot()

  	if shouldShoot then
  		self.lastShouldShoot = shouldShoot
  		self:sendMessage('shoot')
  	end
  end

  return self.lastShouldShoot
end

function NetworkInput:getDirection()
	if not self:isRemote() then
		local direction = KeyboardAndMouseInput:getDirection()

		if ( direction ~= self.lastDirection ) then
			self.lastDirection = direction
			self:sendMessage('direction', direction)
		end
	end

	return self.lastDirection
end

function NetworkInput:getArmAngle()
	if not self:isRemote() then
		local armAngle = KeyboardAndMouseInput:getArmAngle(0, 0)

		if ( armAngle ~= self.lastArmAngle ) then
			self.lastArmAngle = armAngle
			self:sendMessage('armAngle', armAngle)
		end
	end

	return self.lastArmAngle
end

return NetworkInput
