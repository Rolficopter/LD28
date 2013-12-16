local Constants = require 'conf'
local GameMenu = require 'menu/GameMenu'
local Server = require 'Server'

require 'lib/LUBE'

MultiplayerMenu = class('MultiplayerMenu', GameMenu)

function MultiplayerMenu:initialize(isServer, ip)
	if isServer then
		self:initServer()
		self:initClient("localhost")
	else
		self:initClient(ip)
	end
	GameMenu:initialize(self.client)
end
function MultiplayerMenu:initServer()
	self.server = Server:new()
end
function MultiplayerMenu:initClient(ip)
	self.client = lube.udpClient()
	self.client.handshake = Constants.NET.HANDSHAKE
	self.client:setPing(true, Constants.NET.PING.TIMEOUT, Constants.NET.PING.MSG)
	local success, err = self.client:connect(ip, Constants.NET.PORT)

	if ( not success ) then
		error(err)
	else
		print("Connected to server " .. ip .. ":" .. Constants.NET.PORT .. ".")
		self.client:send(Constants.NET.PING.MSG)
	end
end

function MultiplayerMenu:update(dt)
	if self.server then
		self.server:update(dt)
	end

	self.client:update(dt)

	GameMenu:update(dt)
end

return MultiplayerMenu
