local Constants = require 'conf'
local class = require 'lib/middleclass'
local Menu = require 'menu/Menu'

MainMenu = class('MainMenu', Menu)

function MainMenu:initialize()
  Menu:initialize()

  self.fontHeadingArimo = love.graphics.newFont('assets/fonts/Arimo-Regular.ttf', Constants.MENU.MAIN.HEADING_SIZE)
  self.fontTextArimo = love.graphics.newFont('assets/fonts/Arimo-Regular.ttf', Constants.MENU.MAIN.TEXT_SIZE)

  self.currentSelection = 0

  self.textStartGame = "Start Game"
  self.textQuit = "Quit"
end

function MainMenu:update(dt)
  if love.keyboard.isDown("return") then
    if self.currentSelection == 0 then
      self:switchToMenu(Constants.MENU.GAME.NAME)
    elseif self.currentSelection == 1 then
      love.event.quit()
    end
  end

  if love.keyboard.wasPressed("w") or love.keyboard.wasPressed("up") then
    self.currentSelection = self.currentSelection - 1
    if self.currentSelection < 0 then self.currentSelection = 0 end
  end

  if love.keyboard.wasPressed("s") or love.keyboard.wasPressed("down") then
    self.currentSelection = self.currentSelection + 1
    if self.currentSelection > 1 then self.currentSelection = 0 end
  end
end

function MainMenu:render()
  love.graphics.setFont(self.fontHeadingArimo)

  local text = "Welcome to " .. Constants.TITLE .. " by " .. Constants.AUTHOR
  love.graphics.printf(text, 0, love.graphics.getHeight() / 2 -200, love.graphics.getWidth(), "center")
  
  love.graphics.setFont(self.fontTextArimo)
  love.graphics.printf(self.textStartGame, 0, love.graphics.getHeight() / 2 - 50, love.graphics.getWidth(), "center")
  love.graphics.printf(self.textQuit, 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")

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
    local textWidth = self.fontTextArimo:getWidth(self.textQuit)
    rectangleX = love.graphics.getWidth() / 2 - textWidth / 2
    rectangleY = love.graphics.getHeight() / 2
    rectangleWidth = textWidth
  end

  love.graphics.rectangle("line", rectangleX, rectangleY, rectangleWidth, rectangleHeight)
end

return MainMenu
