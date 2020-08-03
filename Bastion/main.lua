

function love.load()
  require("src.startup.gameStart")
	gameStart()
  VERSION = "0.2"
  frame_width, frame_height = love.graphics.getDimensions()
  field_width = frame_width - 100
  field_heght = frame_height - 40
  total_score = 0

  GAME_DATA = {
    location = 1,
    money = 0,
    kills = 0,
    xp = 0,
    progression = {
      xp = 0,
    },
    stats = {}
  }

  player = Player(100, 100)
  camera = Camera(100, 100)

  Gamestate.registerEvents()
  Gamestate.switch(menu)
end


function love.draw()

end