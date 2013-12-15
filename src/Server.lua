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

local saveClientID = function(self, clientID)
	if not self.clientIds[clientID] then
		self.clientIds[clientID] = true
	end
end
local processClientMessages = function(self)
	local data, clientID = self.server:receive()
	saveClientID(self, clientID)

	for key, value in pairs(self.clientIds) do
		if ( key ~= clientID ) then
			self.server:send(data, key)
		end
	end
end
function Server:update( dt )
	self.server:update(dt)

	processClientMessages(self)
end

return Server
