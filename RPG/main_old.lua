-- This example uses the included Box2D (love.physics) plugin!!

local sti = require "sti"
local Camera = require "lib.hump.camera"
camera = Camera(100, 100)
--windfield = require 'windfield'
--world = windfield.newWorld(0,0,true)
world = love.physics.newWorld(0,0)
obj_interaction_text = nils

require("src.entities.player")
require("intersections")

function love.load()
	-- Grab window size
	windowWidth  = love.graphics.getWidth()
	windowHeight = love.graphics.getHeight()

	score = 0

	require("src.startup.gameStart")
	gameStart()

	-- Set world meter size (in pixels)
	--love.physics.setMeter(32)

	-- Load a map exported to Lua from Tiled
	map = sti("mini.lua", {"box2d"})
	love.physics.setMeter(16)
	map:box2d_init(world)
	world:setCallbacks(beginContact)

	-- Prepare physics world with horizontal and vertical gravity
	
	static = {}
	--static.b = love.physics.newBody(world, 500,400, "static") -- "static" makes it not move
	--static.s = love.physics.newRectangleShape(500,500)         -- set size to 200,50 (x,y)
	--static.f = love.physics.newFixture(static.b, static.s)
	--static.f:setUserData("Block")
	

	-- Create a Custom Layer
	map:addCustomLayer("Sprite Layer", 3)


	-- Add data to Custom Layer
	local spriteLayer = map.layers["Sprite Layer"]
	spriteLayer.sprites = {
		player = Player(100,100)
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
	local player = map.layers["Sprite Layer"].sprites.player
	local x_tile, y_tile = map:convertPixelToTile(player.coord.x, player.coord.y)
	--print(math.floor(x_tile), math.floor(y_tile))
	local t_prop = map:getTileProperties("Midground", math.floor(x_tile) + 1, math.floor(y_tile) + 1)
	local properties = map:getLayerProperties("Background")
	--print(print_r(t_prop, 1))
	local door = getObjectAtCoord("Doors", player.coord)

	if door ~= nil then
		obj_interaction_text = "Press enter"
		print(door.properties["Destination"])
	else
		obj_interaction_text = nil
	end

	getObjectAtCoord("PlayerSpawn", player.coord)
	
end

function love.draw()
	
	-- Draw the map and all objects within
	love.graphics.setColor(1, 1, 1)
	local tx = camera.x - love.graphics.getWidth() / 2
	local ty = camera.y - love.graphics.getHeight() / 2

	--[[ 
	if tx < 0 then 
		tx = 0 
	end
	if tx > map.width  * map.tilewidth  - love.graphics.getWidth()  then
		tx = map.width  * map.tilewidth  - love.graphics.getWidth()  
	end
	if ty > map.height * map.tileheight - love.graphics.getHeight() then
		ty = map.height * map.tileheight - love.graphics.getHeight()
	end
 ]]
	map:draw(-tx, -ty, camera.scale, camera.scale)
	--print("camera", -camera.x + love.graphics.getWidth() / 2, camera.y - love.graphics.getHeight() / 2)
	
	-- Draw Collision Map (useful for debugging)
	love.graphics.setColor(1, 0, 0)
	map:box2d_draw(-tx, -ty, camera.scale, camera.scale)

	if obj_interaction_text ~= nil then
		love.graphics.print(obj_interaction_text, 0,400)
	end
	
	
	camera:attach()
	--drawBodies()
	

	-- Please note that map:draw, map:box2d_draw, and map:bump_draw take
	-- translate and scale arguments (tx, ty, sx, sy) for when you want to
	-- grow, shrink, or reposition your map on screen.
	camera:detach()
end

function love.keypressed(key)
	if key == 'b' then
		 text = "The B key was pressed."
	elseif key == 'a' then
		 a_down = true
	elseif key == 'return' and obj_interaction_text ~= nil then
		gameState.load()
	end
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

function getObjectAtCoord(layer, coord)
	local x_tile, y_tile = map:convertPixelToTile(coord.x, coord.y)

	for i, obj in pairs(map.layers[layer].objects) do 
		if obj.shape == "point" then
			if coord:distanceToPoint(obj.x, obj.y) < 30 then
				return obj
			end
		elseif obj.shape == "rectangle" then
			local box = {
				{x = obj.x, y = obj.y}, 
				{x = obj.x + obj.width, y = obj.y + obj.height}
			}
			if BoundingBox(box, coord.x, coord.y) then
				return obj
			end
		end
	end
end


function print_r(arr, indentLevel)
	local str = ""
	local indentStr = "#"

	if(indentLevel == nil) then
			print(print_r(arr, 0))
			return
	end

	for i = 0, indentLevel do
			indentStr = indentStr.."\t"
	end

	for index,value in pairs(arr) do
			if type(value) == "table" then
					str = str..indentStr..index..": \n"..print_r(value, (indentLevel + 1))
			elseif type(value == "bool") then
					str = str..indentStr..index..": "..tostring(value).."\n"
			else 
					str = str..indentStr..index..": "..value.."\n"
			end
			print(str)
	end
	return str
end
