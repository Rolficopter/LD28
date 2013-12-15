Constants = {}
Constants.TITLE = "LD48"
Constants.AUTHOR = "Ludum Rolfing"
Constants.WEBSITE = "https://github.com/LudumRolfing/LD28"
Constants.VERSION = "0.0.2"
Constants.LOVE_VERSION = "0.8.0"

Constants.ASSETS = {}
Constants.ASSETS.ROOT = 'assets/'
Constants.ASSETS.MAPS = Constants.ASSETS.ROOT .. 'maps/'

Constants.SCREEN = {}
Constants.SCREEN.WIDTH = 800
Constants.SCREEN.HEIGHT = 600
Constants.SCREEN.FULLSCREEN = false
Constants.SCREEN.VSYNC = true

Constants.MENU = {}
Constants.MENU.MAIN = {}
Constants.MENU.MAIN.NAME = 'main'
Constants.MENU.MAIN.HEADING_SIZE = 40
Constants.MENU.MAIN.TEXT_SIZE = 30

Constants.MENU.GAME = {}
Constants.MENU.GAME.NAME = 'game'

Constants.GRAVITY = {}
Constants.GRAVITY.X = 0
Constants.GRAVITY.Y = 9.81 * 3

Constants.SIZES = {}
Constants.SIZES.METER = 16

Constants.SIZES.PLAYER = {}
Constants.SIZES.PLAYER.SCALE = 10
Constants.SIZES.PLAYER.X = 60
Constants.SIZES.PLAYER.Y = 110
Constants.SIZES.PLAYER.ARM_X_OFFSET = 17.5
Constants.SIZES.PLAYER.ARM_Y_OFFSET = 35
Constants.SIZES.PLAYER.LEG_X_OFFSET = 17.5
Constants.SIZES.PLAYER.LEG_Y_OFFSET = 85
Constants.SIZES.PLAYER.LEG_MOVEMENT_SPEED = 3.5

Constants.SIZES.PLAYER.LEFT = -10000
Constants.SIZES.PLAYER.RIGHT = -Constants.SIZES.PLAYER.LEFT
Constants.SIZES.PLAYER.JUMP = -12500
Constants.SIZES.PLAYER.MAXVELOCITY = 50000

Constants.SIZES.BULLET = {}
Constants.SIZES.BULLET.X = 5
Constants.SIZES.BULLET.Y = 5
Constants.SIZES.BULLET.SPEED = 10000000

function love.conf(t)
  t.version = Constants.LOVE_VERSION
  t.title = Constants.TITLE .. " v" .. Constants.VERSION
  t.author = Constants.AUTHOR
  t.url = Constants.WEBSITE

  t.screen.width = Constants.SCREEN.WIDTH
  t.screen.height = Constants.SCREEN.HEIGHT
  t.screen.fullscreen = Constants.SCREEN.FULLSCREEN
  t.screen.vsync = Constants.SCREEN.VSYNC

  -- Active modules
  t.modules.graphics = true
  t.modules.physics = true
  t.modules.image = true
  t.modules.keyboard = true
  t.modules.mouse = true
  t.modules.audio = true
  t.modules.sound = true

  -- Unused modules
  t.modules.joystick = false -- speed up start time
end

return Constants
