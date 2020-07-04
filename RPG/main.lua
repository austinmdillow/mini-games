
--require("src.levels.menu")

function love.load()
  require("src.startup.gameStart")
	gameStart()
  VERSION = "0.2"
  frame_width, frame_height = love.graphics.getDimensions()
  total_score = 0

  gamedata = {
    progression = {
      xp = 0
    },
    stats = {}
  }

  Gamestate.registerEvents()
  Gamestate.switch(menu)
end


function love.draw()
  love.graphics.print('Memory actually used (in kB): ' .. collectgarbage('count'), 10,200)
end