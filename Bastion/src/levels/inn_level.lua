-- main world
inn_level = {}
local world = nil
local map = nil
local active_selection = {}
local last_location = nil

function inn_level:enter()
  print("we are in the inn level")
  map = sti("assets/tiles/tilemaps/inn_map.lua", {"box2d"})
  world = love.physics.newWorld(0,0)
  player:setPosition(300,300)
  player:initPhysics(world)
	player:initMap(map)
  

  love.physics.setMeter(16)
	map:box2d_init(world)
  world:setCallbacks(beginContact)


  setupMap(map, world, 5)
	-- Add data to Custom Layer
end


function inn_level:exit()
	print("leaving inn level")
	last_location = player.coord
end

function inn_level:update(dt)
  world:update(dt)
	map:update(dt)
	updateCommon(dt, map, world)
end


function inn_level:draw()
  	-- Draw the map and all objects within
	love.graphics.setColor(1, 1, 1)
	local tx = camera.x - love.graphics.getWidth() / 2
	local ty = camera.y - love.graphics.getHeight() / 2

	map:draw(-tx, -ty, camera.scale, camera.scale)
	--print("camera", -camera.x + love.graphics.getWidth() / 2, camera.y - love.graphics.getHeight() / 2)
	
	-- Draw Collision Map (useful for debugging)
	love.graphics.setColor(1, 0, 0)
	--map:box2d_draw(-tx, -ty, camera.scale, camera.scale)
	camera:attach()
	drawBodies(world)
	camera:detach()
  displayActions(map, player)
	drawDebugInfo()
	drawCommon()
end

function inn_level:keypressed(key)
  player:keypressed(key)
  if key == 'p' then
    print_table(map)
  elseif key == "escape" then
		Gamestate.switch(menu)
	elseif key == "return" then
		handleActions(map, player)
  end
end