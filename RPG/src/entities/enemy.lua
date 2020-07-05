--require("src.entities.entity")
Enemy = Entity:extend()

function Enemy:new(x_start, y_start, world)
  Enemy.super.new(self, x_start, y_start)
  self.image = sprites.player_img
  self.speed = 100
  self:initPhysics(world)
end

function Enemy:initPhysics(world)
  self.world = world
  self.body = love.physics.newBody(world, self.coord.x, self.coord.y + self.image:getWidth()/2, 'dynamic')
  self.shape = love.physics.newCircleShape(15)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.body:setMass(1.5) -- manually set mass overriding shape
end

function Enemy:update(dt)
local vectorX, vectorY
  if self.coord:distanceToCoord(player:getCoord()) < 200 then
    vectorX, vectorY = self.coord:normalVectorToCoord(player:getCoord())
  else
    self.coord.dir = self.coord.dir + love.math.random(-5,5)
    vectorX, vectorY = self.coord:polarToCartesian(1, self.coord.dir)
  end
  
  local x_vel, y_vel = self.body:getLinearVelocity()
  local vel = math.sqrt(x_vel^2 + y_vel ^ 2)
  if vel > self.speed then
    vectorX = 0
    vectorY = 0
  end

  self.body:applyForce(vectorX * self.speed * 2, vectorY * self.speed * 2)
  self.body:applyForce(-x_vel, -y_vel)

  local x_tmp, y_tmp = self.body:getPosition()
  self.coord.x = x_tmp
  self.coord.y = y_tmp
end

function Enemy:draw()
  if self.image ~= nil then
    love.graphics.draw(self.image, self.coord.x - self.image:getWidth()/2, self.coord.y - self.image:getWidth()/2, self.r)
  else
    love.graphics.circle('line', self.coord.x, self.coord.y, 10)
  end
end