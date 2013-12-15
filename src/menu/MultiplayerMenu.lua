local Constants = require 'conf'
local GameMenu = require 'menu/GameMenu'

require 'lib/LUBE'

MultiplayerMenu = class('MultiplayerMenu', GameMenu)

local instance = nil
local clientConnected = function(ip, port)
	-- TODO
end
local clientDisconnected = function(ip, port)
	-- TODO
end
local receiveCallback = function(data, ip, port)
end

function MultiplayerMenu:initialize(isServer, ip)
	instance = self
	GameMenu:initialize()
	self.isServer = isServer

	if isServer then
		self:initServer()
		self:initClient("localhost")
	else
		self:initClient(ip)
	end
end
function MultiplayerMenu:initServer()
	lube.server.Init(Constants.NET.PORT)
	lube.server.setCallback(receiveCallback, clientConnected, clientDisconnected)
	lube.server.setHandshake(Constants.NET.HANDSHAKE)
end
function MultiplayerMenu:initClient(ip)
	lube.client.Init()
	lube.client.setCallback(receiveCallback)
	lube.client.setHandshake(Constants.NET.HANDSHAKE)
	lube.client.connect(ip, Constants.NET.PORT)
end

function MultiplayerMenu:update(dt)
	if self.isServer then
		lube.server.update()
	end

	lube.client.update()
end

return MultiplayerMenu
