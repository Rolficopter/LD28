local Constants = require 'conf'
local Menu = require 'menu/Menu'
local atl = require 'lib/advanced-tiled-loader/Loader'

MainMenu = class('MainMenu', Menu)

function MainMenu:initialize()
  Menu:initialize()

  self.fontHeadingArimo = love.graphics.newFont('assets/fonts/Arimo-Regular.ttf', Constants.MENU.MAIN.HEADING_SIZE)
  self.fontTextArimo = love.graphics.newFont('assets/fonts/Arimo-Regular.ttf', Constants.MENU.MAIN.TEXT_SIZE)

  self.currentSelection = 0

  self.textStartGame = "Start Game"
  self.textStartServer = "Start Server"
  self.textStartClient = "Connect to Server"
  self.textQuit = "Quit"

  self.cursor = {}
  self.cursor.x = 0
  self.cursor.y = 0
  self.cursor.xDes = 0
  self.cursor.yDes = 0
  self.cursor.width = 0
  self.cursor.height = 0
  self.cursor.widthDes = 0
  self.cursor.heightDes = 0
  
  atl.path = Constants.ASSETS.MAPS

  self.map = atl.load('Map.tmx')
  self.map.drawObjects = false

  self.menuMusic = love.audio.newSource('assets/music/menu.mp3')

  self.time = 0
end

function MainMenu:update(dt)
  if self.menuMusic:isStopped() then
    self.menuMusic:play()
  end

  if love.keyboard.isDown("return") then
    self.menuMusic:stop()
    if self.currentSelection == 0 then
      self:switchToMenu(Constants.MENU.GAME.NAME)
    elseif self.currentSelection == 1 then
      self:switchToMenu(Constants.MENU.NET.NAME, nil)
    elseif self.currentSelection == 2 then
      self:switchToMenu(Constants.MENU.NET.NAME, "localhost")
    elseif self.currentSelection == 3 then
      love.event.quit()
    end
  end

  if love.keyboard.wasPressed("w") or love.keyboard.wasPressed("up") then
    self.currentSelection = self.currentSelection - 1
    if self.currentSelection < 0 then self.currentSelection = 0 end
  end

  if love.keyboard.wasPressed("s") or love.keyboard.wasPressed("down") then
    self.currentSelection = self.currentSelection + 1
    if self.currentSelection > 3 then self.currentSelection = 3 end
  end

  local rectangleX = 0
  local rectangleY = 0
  local rectangleWidth = 0
  local rectangleHeight = self.fontTextArimo:getHeight()

  if self.currentSelection == 0 then
    local textWidth = self.fontTextArimo:getWidth(self.textStartGame)
    rectangleX = love.graphics.getWidth() / 2 - textWidth / 2
    rectangleY = love.graphics.getHeight() / 2 - 50
    rectangleWidth = textWidth
  elseif self.currentSelection == 1 then
    local textWidth = self.fontTextArimo:getWidth(self.textStartServer)
    rectangleX = love.graphics.getWidth() / 2 - textWidth / 2
    rectangleY = love.graphics.getHeight() / 2
    rectangleWidth = textWidth
  elseif self.currentSelection == 2 then
    local textWidth = self.fontTextArimo:getWidth(self.textStartClient)
    rectangleX = love.graphics.getWidth() / 2 - textWidth / 2
    rectangleY = love.graphics.getHeight() / 2 + 50
    rectangleWidth = textWidth
  elseif self.currentSelection == 3 then
    local textWidth = self.fontTextArimo:getWidth(self.textQuit)
    rectangleX = love.graphics.getWidth() / 2 - textWidth / 2
    rectangleY = love.graphics.getHeight() / 2 + 100
    rectangleWidth = textWidth
  end

  rectangleWidth = rectangleWidth + 20
  rectangleX = rectangleX - 10
  rectangleHeight = rectangleHeight + 10
  rectangleY = rectangleY - 5

  self.cursor.xDes = rectangleX
  self.cursor.yDes = rectangleY
  self.cursor.widthDes = rectangleWidth
  self.cursor.heightDes = rectangleHeight

  self.cursor.x = self.cursor.x + ((self.cursor.xDes - self.cursor.x) * dt * 10)
  self.cursor.y = self.cursor.y + ((self.cursor.yDes - self.cursor.y) * dt * 10)
  self.cursor.width = self.cursor.width + ((self.cursor.widthDes - self.cursor.width) * dt * 10)
  self.cursor.height = self.cursor.height + ((self.cursor.heightDes - self.cursor.height) * dt * 10)

  self.time = self.time + dt
end

function MainMenu:render()
  love.graphics.setBackgroundColor({255, 255, 255, 255})

  love.graphics.push()

  local translateX = 175 * math.cos(self.time) + 1200
  local translateY = 175 * math.sin(self.time) + 800

  love.graphics.translate(-translateX, -translateY)
  self.map:autoDrawRange(-translateX, -translateY, 1, 0)

  self.map:draw()
  love.graphics.pop()


  love.graphics.setFont(self.fontHeadingArimo)
  
  local text = "Welcome to " .. Constants.TITLE .. " by " .. Constants.AUTHOR

  love.graphics.setColor({255, 255, 255, 255})
  love.graphics.rectangle("fill", love.graphics.getWidth() / 2 - self.fontHeadingArimo:getWidth(text) / 2 - 20, love.graphics.getHeight() / 2 - 210, self.fontHeadingArimo:getWidth(text) + 40, self.fontHeadingArimo:getHeight() + 20)
  
  love.graphics.setColor({0, 0, 0, 255})
  love.graphics.printf(text, 0, love.graphics.getHeight() / 2 -200, love.graphics.getWidth(), "center")

  love.graphics.setColor({255, 255, 255, 255})
  love.graphics.rectangle("fill", love.graphics.getWidth() / 2 - ( self.fontTextArimo:getWidth(self.textStartClient) + 20 ) / 2, love.graphics.getHeight() / 2 - 70,  self.fontTextArimo:getWidth(self.textStartClient) + 20, self.fontTextArimo:getHeight() * 2 + 150)
 
  love.graphics.setFont(self.fontTextArimo)
  love.graphics.setColor({0, 0, 0, 255})
  love.graphics.printf(self.textStartGame, 0, love.graphics.getHeight() / 2 - 50, love.graphics.getWidth(), "center")
  love.graphics.printf(self.textStartServer, 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
  love.graphics.printf(self.textStartClient, 0, love.graphics.getHeight() / 2 + 50, love.graphics.getWidth(), "center")
  love.graphics.printf(self.textQuit, 0, love.graphics.getHeight() / 2 + 100, love.graphics.getWidth(), "center")

  love.graphics.rectangle("line", self.cursor.x, self.cursor.y, self.cursor.width, self.cursor.height)
end

return MainMenu
