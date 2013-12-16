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
		data = tostring(data)
		msg = msg .. ':' .. data
	end

	print("Sending ", message, "data:", data)
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
				if data == '1' then
					self.lastShouldJump = true
				else
					self.lastShouldJump = false
				end
			end
			if message == 'shoot' then
				if data == '1' then
					self.lastShouldShoot = true
				else
					self.lastShouldShoot = false
				end
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
	if not self:isRemote() then
		local shouldJump = KeyboardAndMouseInput:shouldJump()

		if self.lastShouldJump ~= shouldJump then
			self.lastShouldJump = shouldJump
			if shouldJump then
				self:sendMessage('jump', "1")
			else
				self:sendMessage('jump', '0')
			end
		end
	end

	return self.lastShouldJump
end

function NetworkInput:shouldShoot()
  if not self:isRemote() then
  	local shouldShoot = KeyboardAndMouseInput:shouldShoot()

  	if self.lastShouldShoot ~= shouldShoot then
  		self.lastShouldShoot = shouldShoot
  		if shouldShoot then
			self:sendMessage('shoot', "1")
		else
			self:sendMessage('shoot', '0')
		end
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
