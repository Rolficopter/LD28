local Updateable = require 'Updateable'

require 'lib/LUBE'

Server = class('Server', Updateable)

local initServer = function(self)
	self.server = lube.udpServer()
	self.server.handshake = Constants.NET.HANDSHAKE
	self.server:setPing(true, Constants.NET.PING.TIMEOUT * 3, Constants.NET.PING.MSG)
	self.server:listen(Constants.NET.PORT)
end
function Server:initialize()
	Updateable:initialize()

	initServer(self)
	self.clientIds = {}
end

function Server:sendData(data, senderClientID)
	if data then
		for key, value in pairs(self.clientIds) do
			if ( key ~= senderClientID ) then
				self.server:send(data, key)
			end
		end
	end
end
function Server:sendMessage(data, receiverClientID)
	self.server:send(data, receiverClientID)
end

function Server:onNewClient( clientID )
	print("New client:", clientID)

	self:sendMessage('Map:Map', clientID)
end

local saveClientID = function(self, clientID)
	if clientID and not self.clientIds[clientID] then
		self.clientIds[clientID] = true
		-- new client
		self:onNewClient(clientID)
	end
end
local processClientMessages = function(self)
	local data, clientID = self.server:receive()
	if ( data and clientID ) then
		saveClientID(self, clientID)

		self:sendData(data, clientID)
	end
end
function Server:update( dt )
	self.server:update(dt)

	processClientMessages(self)

	if math.random(0, 3 * 60) then

	end
end

return Server
