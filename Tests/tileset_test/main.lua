-- This example uses the included Box2D (love.physics) plugin!!

local sti = require "sti"
local Camera = require "lib.hump.camera"
camera = Camera(100, 100)
--windfield = require 'windfield'
--world = windfield.newWorld(0,0,true)
world = love.physics.newWorld(0,0)

require("player")

function love.load()
	-- Grab window size
	windowWidth  = love.graphics.getWidth()
	windowHeight = love.graphics.getHeight()

	-- Set world meter size (in pixels)
	--love.physics.setMeter(32)

	-- Load a map exported to Lua from Tiled
	map = sti("map.lua", { "box2d" })
	love.physics.setMeter(1)
	map:box2d_init(world)
	world:setCallbacks(beginContact)

	-- Prepare physics world with horizontal and vertical gravity
	
	static = {}
	static.b = love.physics.newBody(world, 500,400, "static") -- "static" makes it not move
	static.s = love.physics.newRectangleShape(500,500)         -- set size to 200,50 (x,y)
	static.f = love.physics.newFixture(static.b, static.s)
	static.f:setUserData("Block")
	

	-- Create a Custom Layer
	map:addCustomLayer("Sprite Layer", 3)

	-- Add data to Custom Layer
	local spriteLayer = map.layers["Sprite Layer"]
	spriteLayer.sprites = {
		player = Player(100,00)
	}

	-- Update callback for Custom Layer
	function spriteLayer:update(dt)
		for _, sprite in pairs(self.sprites) do
			sprite:update(dt)
			camera.x = sprite.coord.x
			camera.y = sprite.coord.y
		end
	end

	-- Draw callback for Custom Layer
	function spriteLayer:draw()
		for _, sprite in pairs(self.sprites) do
			sprite:draw()
		end
	end
end

function love.update(dt)
	
	world:update(dt)
	map:update(dt)
	
end

function love.draw()
	
	-- Draw the map and all objects within
	love.graphics.setColor(1, 1, 1)
	local tx = camera.x - love.graphics.getWidth() / 2
	local ty = camera.y - love.graphics.getHeight() / 2

	if tx < 0 then 
		tx = 0 
	end
	if tx > map.width  * map.tilewidth  - love.graphics.getWidth()  then
		tx = map.width  * map.tilewidth  - love.graphics.getWidth()  
	end
	if ty > map.height * map.tileheight - love.graphics.getHeight() then
		ty = map.height * map.tileheight - love.graphics.getHeight()
	end

	map:draw(-tx, -ty, camera.scale, camera.scale)
	print("camera", -camera.x + love.graphics.getWidth() / 2, camera.y - love.graphics.getHeight() / 2)

	-- Draw Collision Map (useful for debugging)
	love.graphics.setColor(1, 1, 0)
	
	camera:attach()
	drawBodies()
	

	-- Please note that map:draw, map:box2d_draw, and map:bump_draw take
	-- translate and scale arguments (tx, ty, sx, sy) for when you want to
	-- grow, shrink, or reposition your map on screen.
	camera:detach()
end

function drawBodies()
	for _, body in pairs(world:getBodies()) do
		for _, fixture in pairs(body:getFixtures()) do
				local shape = fixture:getShape()
 
				if shape:typeOf("CircleShape") then
						local cx, cy = body:getWorldPoints(shape:getPoint())
						love.graphics.circle("line", cx, cy, shape:getRadius())
				elseif shape:typeOf("PolygonShape") then
						love.graphics.polygon("line", body:getWorldPoints(shape:getPoints()))
				else
						love.graphics.line(body:getWorldPoints(shape:getPoints()))
				end
		end
	end
end
