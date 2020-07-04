-- main world
mainWorld = {}

function mainWorld:enter()
  map = sti("assets/tiles/tilemaps/main_world_map.lua", {"box2d"})
  world = love.physics.newWorld(0,0)

  love.physics.setMeter(16)
	map:box2d_init(world)
  world:setCallbacks(beginContact)
  
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


function mainWorld:exit()
  print("leaving main world")
end

function mainWorld:update(dt)
  print("moo")
end


function mainWorld:draw()
  map:draw()
end
