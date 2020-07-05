-- main world
mainWorld = {}
local world = nil
local map = nil
local active_selection = {}
local last_location = nil
local map_sprites = nil

function mainWorld:enter()
  map = sti("assets/tiles/tilemaps/main_world_map.lua", {"box2d"})
  world = love.physics.newWorld(0,0)
  
	player:initPhysics(world)
	player:initMap(map)

  
	map:box2d_init(world)
  world:setCallbacks(beginContact)

	map_sprites = setupMap(map, world, 6)
	local wall = {}
	wall.body = love.physics.newBody(world, 300, 500, 'dynamic')
  wall.shape = love.physics.newCircleShape(100)
	wall.fixture = love.physics.newFixture(wall.body, wall.shape)
	wall.body:setMass(2)
	print(wall.fixture:getMask())

end


function mainWorld:exit()
	print("leaving main world")
	last_location = player.coord
end

function mainWorld:update(dt)
  world:update(dt)
	map:update(dt)
end


function mainWorld:draw()
  	-- Draw the map and all objects within
	love.graphics.setColor(1, 1, 1)
	local tx = camera.x - love.graphics.getWidth() / 2
	local ty = camera.y - love.graphics.getHeight() / 2

	map:draw(-tx, -ty, camera.scale, camera.scale)
	
	-- Draw Collision Map (useful for debugging)
	love.graphics.setColor(1, 0, 0)
	--map:box2d_draw(-tx, -ty, camera.scale, camera.scale)
	camera:attach()
	drawBodies(world)
	camera:detach()
	displayActions(map, player)
	drawDebugInfo()
end

function mainWorld:keypressed(key)
	player:keypressed(key)
  if key == 'p' then
    print_table(map)
  elseif key == "escape" then
		Gamestate.switch(menu)
	elseif key == "return" then
		handleActions(map, player)
  end
end
