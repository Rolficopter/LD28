Constants = {}
Constants.TITLE = "LD48"
Constants.AUTHOR = "Ludum Rolfing"
Constants.WEBSITE = "https://github.com/LudumRolfing/LD28"
Constants.VERSION = "0.0.1"
Constants.LOVE_VERSION = "0.8.0"
Constants.SCREEN = {}
Constants.SCREEN.WIDTH = 800
Constants.SCREEN.HEIGHT = 600
Constants.SCREEN.FULLSCREEN = false
Constants.SCREEN.VSYNC = true

Constants.GRAVITY = {}
Constants.GRAVITY.X = 0
Constants.GRAVITY.Y = 9.81

Constants.SIZES = {}
Constants.SIZES.METER = 16
Constants.SIZES.PLAYER = {}
Constants.SIZES.PLAYER.X = 28
Constants.SIZES.PLAYER.Y = 90

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

  -- Unused modules
  t.modules.joystick = false -- speed up start time
  t.modules.audio = false
  t.modules.mouse = false
  t.modules.sound = false
end

return Constants
