-- 2D ATC Game
Gamestate = require "lib.hump.gamestate"
Camera = require "lib.hump.camera"
require("gameplay")
require("menu")
require("gameover")

VERSION = "0.2"
frame_width, frame_height = love.graphics.getDimensions()

total_score = 0

game_options = {
   plane_speed = 30,
   seconds_per_plane = 5
}


function love.load()
   Gamestate.registerEvents()
   Gamestate.switch(menu)
end
