local Updateable = require 'Updateable'

require 'lib/LUBE'

Server = class('Server', Updateable)

local instance = nil
local server_connect = function(clientID)
	instance:_connect(clientID)
end
local server_disconnect = function(clientID)
	instance:onClientLost(clientID)
end
local server_recv = function(data, clientID)
	instance:onData(data, clientID)
end

local initServer = function(self)
	self.server = lube.udpServer()
	self.server.handshake = Constants.NET.HANDSHAKE
	self.server:setPing(true, Constants.NET.PING.TIMEOUT * 3, Constants.NET.PING.MSG)

	self.server.callbacks.recv = server_recv
	self.server.callbacks.connect = server_connect
	self.server.callbacks.disconnect = server_disconnect

	self.server:listen(Constants.NET.PORT)
	print("Server listening on port " .. Constants.NET.PORT .. ".")
end
function Server:initialize()
	Updateable:initialize()
	instance = self

	initServer(self)
	self.clientIds = {}
	self.UUIDs = {}
end

function Server:getUUID(clientID)
	if not self.UUIDs[clientID] then
		self.UUIDs[clientID] = table.getn(self.UUIDs) + 1 -- 0 is server
	end

	return self.UUIDs[clientID]
end

function Server:update( dt )
	self.server:update(dt)
end

function Server:sendTransport(data, senderClientID)
	if data then
		for key, value in pairs(self.clientIds) do
			if key ~= senderClientID then
				print("Transport.", "Data: ", data)
				self.server:send(data, key)
			end
		end
	end
end
function Server:sendBroadcast(data, senderClientID)
	-- send message to all except for one
	if data then
		data = Constants.NET.ID_SERVER .. data
		self:sendTransport(data, senderClientID)
	end
end
function Server:sendMessage(data, receiverClientID)
	-- send message to one client
	print("Message to client.", "ID:", receiverClientID .. '(' .. self:getUUID(receiverClientID) .. ')', "Data:", data)
	data = Constants.NET.ID_SERVER .. data
	self.server:send(data, receiverClientID)
end

-- callbacks
-- connect
local saveClientID = function(self, clientID)
	if clientID and not self.clientIds[clientID] then
		self.clientIds[clientID] = true

		return true
	end
	return false
end
function Server:_connect(clientID)
	if saveClientID(self, clientID) then
		self:onNewClient(clientID)
	end
end
function Server:onNewClient(clientID)
	print("New client:", clientID)

	-- setup new client
	self:sendMessage('ID:' .. self:getUUID(clientID), clientID)
	self:sendMessage('Map:Map', clientID) -- let him load the maps
	-- notify other clients when we know the new one's x and y
	-- other clients are unknown at this time...
end
-- disconnect
function Server:onClientLost(clientID)
	print("Client disconnected:", clientID)

	self:sendMessage()
end
-- recv
function Server:onData(data, clientID)
	if data == Constants.NET.PING.MSG then
		-- don't transfer ping messages
		return
	end

	self:sendTransport(data, clientID)
end

return Server
