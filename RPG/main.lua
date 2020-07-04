

function love.load()
  require("src.startup.gameStart")
	gameStart()
  VERSION = "0.2"
  frame_width, frame_height = love.graphics.getDimensions()
  total_score = 0

  gamedata = {
    location = 1,
    progression = {
      xp = 0
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