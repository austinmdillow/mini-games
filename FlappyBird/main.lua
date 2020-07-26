Gamestate = require "gamestate"
require("main_gameplay")
require("round_over")
small_spencer = love.graphics.newImage("small_spence.png")
background_sky = love.graphics.newImage("sky.png")
background_image = love.graphics.newImage("mountain01.png")

-- making Flappy bird
function love.load()
	Gamestate.registerEvents()
	
	--world = love.physics.newWorld(0,0, true)
	background_r = 1
	background_g = 1
	background_b = 1

	bird_width = 40
	bird_height = 20

	spencer_width, spencer_height = small_spencer:getDimensions()
	spencer_found = false
	spencer_draw = false

	pipe_speed = 200
	max_speed = 400




	--guy_sprite = love.graphics.newImage("1x.png")

	--animation = newAnimation(guy_sprite,100,100,10)

	high_score = 0

	frame_width, frame_height = love.graphics.getDimensions()

	love.window.setTitle("Austin's Flappy Brb")

	Gamestate.switch(main_gameplay)

end
