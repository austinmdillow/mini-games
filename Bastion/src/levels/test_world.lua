test_world = {}
local world = nil
local map = nil

local projectiles = {}
local cannon_angle = -1.5707

local objects = {}

local power = 0
local charging = false
local money = 100
local camera = Camera()
local last_shot_time = love.timer.getTime()
local tracking_ball = false
local cam_x = 0
local cam_y = 0


function test_world:enter()
  print("entering into the testing zone")
  world = love.physics.newWorld(0, 9.81 * 16 , true)

  toolbar = Toolbar()
  map = sti("assets/tiles/tilemaps/level_1_seige.lua", {"box2d"})
  map:box2d_init(world)

  objects.ground = {}
  objects.ground.body = love.physics.newBody(world, frame_width/2, frame_height - 10, 'static')
  objects.ground.shape = love.physics.newRectangleShape(frame_width, 10)
  objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape)
end


function test_world:update(dt)
  if not love.keyboard.isDown('q') then
    world:update(dt)
  end
  if charging == true then
    power = power + dt * 300
  end
  moveCamera(dt)
  cleanupObjects()
  print(#projectiles, 99)
  map:update(dt)
end

function test_world:draw()
  --camera:attach()
  local ground_height = 10
  love.graphics.setColor(COLORS.green)
  love.graphics.rectangle('fill', 0, frame_height - ground_height, frame_width, ground_height)

  -- draw cannon
  love.graphics.setColor(COLORS.red)
  love.graphics.push()
	love.graphics.push()
	love.graphics.translate(25, frame_height - 25)
  love.graphics.rotate(cannon_angle)
  love.graphics.rectangle('line', 0, 5, 10, 50)
  love.graphics.pop()
  love.graphics.pop()

  for key, proj in pairs(projectiles) do
    --love.graphics.circle('fill', proj.body:getX(), proj.body:getY(), 8)
  end
  --print()
  for key, obj in pairs(objects) do
    --print(key, obj)
    if obj ~= objects.ground then
      obj:draw()
    end
  end

  drawBodies(world)

  love.graphics.setColor(1, 1, 1)
	local tx = cam_x
	local ty = cam_y --- love.graphics.getHeight() / 2

	map:draw(-tx, -ty, camera.scale, camera.scale)

  love.graphics.rectangle('line', 0,0, 10, power)
  drawDebugInfo()

  --camera:detach()

  drawCommon()
  toolbar:draw()

end

function moveCamera(dt)
  if love.keyboard.isDown("a") then
    camera:move(-dt*100,0)
    print("moving")
  elseif love.keyboard.isDown('d') then
    camera:move(dt*100,0)
  end

  if love.timer.getTime() - last_shot_time < 5 then
    if projectiles[1] ~= nil then
      --print(projectiles[1].body:getPosition())
      local proj_x, proj_y = projectiles[#projectiles].body:getPosition()
      proj_x = math.max(proj_x, frame_width/2)
      camera:lockX(proj_x)
      tracking_ball = true
    end
  elseif tracking_ball == true then
    tracking_ball = false
    camera:lookAt(frame_width/2,frame_height/2)
  end

end

function test_world:keypressed(key)

  if key == 'w' then
    cannon_angle = cannon_angle + math.rad(10)
  end

  if key == 's' then
    cannon_angle = cannon_angle - math.rad(10)
  end

  if key == 'space' then
    charging = true
  end

  if key == 'esc' then
    Gamestate.switch(menu)
  end

end

function test_world:keyreleased(key)
  if key == 'space' then
    new_projectile(cannon_angle, power)
    power = 0
    charging = false
    last_shot_time = love.timer.getTime()
  end
end

function test_world:mousepressed(x, y, button, istouch, presses)
  if toolbar:mousepressed(x, y, button, istouch, presses) then
    return -- if we were interracting with the toolbar, then don't do anything
  end

  x,y = camera:worldCoords(x,y)

  if button == 1 then -- left click
    local type = toolbar:getSelection()
    if type == material_options.wood_3x1 then
      local wall = Wall(world, x, y)
      table.insert(objects, wall)
    elseif type == material_options.steel_3x1 then
      local wall = WoodWall(world, x, y)
      table.insert(objects, wall)
    end

  elseif button == 2 then -- right click
    print("point")
    local key, obj = getSelectedWall(x, y)
    if obj ~= nil then
      obj.body:destroy()
      objects[key] = nil
    end
    

  end
end

function new_projectile(angle, speed)
  local projectile = {}
  projectile.body = love.physics.newBody(world, 30, frame_height - 50, 'dynamic')
  projectile.shape = love.physics.newCircleShape(10)
  projectile.fixture = love.physics.newFixture(projectile.body, projectile.shape)
  local x_vel = -speed * math.sin(angle)
  local y_vel = speed * math.cos(angle)
  projectile.body:setLinearVelocity(x_vel, y_vel)
  projectile.fixture:setRestitution(0.3)
  projectile.fixture:setDensity(100)
  projectile.body:resetMassData()
  table.insert(projectiles, projectile)
end

function getSelectedWall(x ,y)
  for key, obj in pairs(objects) do
    print(key, obj)
    if obj.fixture:testPoint(x, y) then
      return key, obj
    end
  end
end


function cleanupObjects()
  for idx, proj in ipairs(projectiles) do
    local x, y = proj.body:getPosition()
    if y > frame_height then
      table.remove(projectiles, idx)
    end
  end
end
