-- 2D ATC Game
Gamestate = require "lib.hump.gamestate"
require("plane")
require("gameplay")
require("menu")

VERSION = "0.2"
frame_width, frame_height = love.graphics.getDimensions()

total_score = 0


function love.load()

   Gamestate.registerEvents()
   Gamestate.switch(menu)
end
