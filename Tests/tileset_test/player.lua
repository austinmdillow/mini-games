require("entity")

Player = Entity:extend()

function Player:new(x_start, y_start)
  Player.super.new(self, x_start, y_start)
  self.image = love.graphics.newImage("sp.png")

  -- init physics
  self.body = love.physics.newBody(world, self.coord.x, self.coord.y + self.image:getWidth()/2, 'dynamic')
  self.shape = love.physics.newCircleShape(10)
  self.fixture = love.physics.newFixture(self.body, self.shape)
end

function Player:update()

  local vectorX = 0
  local vectorY = 0
  -- Keyboard direction checks for movement
  if love.keyboard.isDown("left") then
    vectorX = -1
    --Player.anim = Player.animations.walkLeft
    self.dir = "left"
  end
  if love.keyboard.isDown("right") then
      vectorX = 1
      --Player.anim = Player.animations.walkRight
      self.dir = "right"
  end
  if love.keyboard.isDown("up") then
      vectorY = -1
      --Player.anim = Player.animations.walkUp
      self.dir = "up"
  end
  if love.keyboard.isDown("down") then
      vectorY = 1
      --Player.anim = Player.animations.walkDown
      self.dir = "down"
  end

  self.body:setLinearVelocity(vectorX * self.speed, vectorY * self.speed)
  local x_tmp, y_tmp = self.body:getPosition()
  self.coord.x = x_tmp
  self.coord.y = y_tmp
end

function Player:draw()
  love.graphics.draw(self.image, self.coord.x - self.image:getWidth()/2, self.coord.y - self.image:getWidth()/2, self.r)
end
