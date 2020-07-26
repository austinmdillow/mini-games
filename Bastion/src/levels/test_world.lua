test_world = {}
local world = nil
local map = nil

local projectiles = {}
local cannon_angle = -1.5707

local objects = {}

local power = 0
local charging = false
local money = 100


function test_world:enter()
  print("entering into the testing zone")
  world = love.physics.newWorld(0, 9.81 * 16 , true)

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
end

function test_world:draw()
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
  for key, proj in pairs(objects) do
    print(key, proj)
    --love.graphics.circle('fill', proj.body:getX(), proj.body:getY(), 8)
  end



  drawBodies(world)

  love.graphics.rectangle('line', 0,0, 10, power)
  drawDebugInfo()

  drawCommon()

end

function test_world:keypressed(key)
  print(cannon_angle)

  if key == 'w' then
    cannon_angle = cannon_angle + math.rad(10)
  end

  if key == 's' then
    cannon_angle = cannon_angle - math.rad(10)
  end

  if key == 'space' then
    charging = true
  end

end

function test_world:keyreleased(key)
  if key == 'space' then
    new_projectile(cannon_angle, power)
    power = 0
    charging = false
  end
end

function test_world:mousepressed( x, y, button, istouch, presses)
  if button == 1 then -- left click
    local wall = Wall(world, x, y)
    table.insert(objects, wall)
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
