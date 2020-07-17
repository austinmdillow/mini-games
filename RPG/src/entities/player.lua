require("src.entities.entity")
require("src.entities.weapon")

Player = Entity:extend()

function Player:new(x_start, y_start)
  Player.super.new(self, x_start, y_start)
  self.image = sprites.player_img
  self.sheet = sprites.player_sheet
  self.speed = 200
  self.weapon = {
    hitbox = {}
  }
  self.inventory = Inventory()
  self.inventory:addItem(Axe(), 1)
  self.map = nil
  self.tool = Axe()
  self.collider_height = 32
  self.animations = {}
  self:initAnimations()
end

function Player:initAnimations()
  local grid = anim8.newGrid(32, 32, self.sheet:getWidth(), self.sheet:getHeight())
  self.animations.walk_down = anim8.newAnimation(grid('1-4',1), 0.1)
  self.animations.walk_up = anim8.newAnimation(grid('1-4',2), 0.1)
  self.animations.walk_left = anim8.newAnimation(grid('1-4',3), 0.1)
  self.animations.walk_right = anim8.newAnimation(grid('1-4',4), 0.1)
  self.animations.current = self.animations.walk_down
end

function Player:initPhysics(world)
  self.world = world
  self.body = love.physics.newBody(world, self.coord.x, self.coord.y, 'dynamic')
  self.shape = love.physics.newCircleShape(self.collider_height / 2)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setFilterData(1,65535,-2)
  self.body:setMass(self.stats.size) -- set mass to 1 kg
  self.body:setLinearDamping(1)
end

function Player:initMap(map)
  self.map = map
  self.inventory:addItem(Item(), 4)
  self.inventory:addItem(Item(), 2)
end

function Player:setPosition(x_set, y_set)
  self.coord.x = x_set
  self.coord.y = y_set

  if self.world ~= nil then
    self.body:setPosition(x_set, y_set)
  end
end


function Player:update(dt)
  Player.super.update(self, dt)

  local vectorX = 0
  local vectorY = 0
  -- Keyboard direction checks for movement
  if love.keyboard.isDown("left") or love.keyboard.isDown("a")then
    vectorX = -1
    self.animations.current = self.animations.walk_left
    self.dir = "left"
  end
  if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
      vectorX = 1
      self.animations.current = self.animations.walk_right
      self.dir = "right"
  end
  if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
      vectorY = -1
      self.animations.current = self.animations.walk_up
      self.dir = "up"
  end
  if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
      vectorY = 1
      self.animations.current = self.animations.walk_down
      self.dir = "down"
  end

  local x_vel, y_vel = self.body:getLinearVelocity()
  local vel = math.sqrt(x_vel^2 + y_vel ^ 2)
  if vel > self.speed then
    vectorX = 0
    vectorY = 0
  end

  self.body:applyForce(vectorX * self.speed * 300, vectorY * self.speed * 300)
  if vectorX == 0 and vectorY == 0 then
    self.body:applyForce(-x_vel * self.stats.size * 10, -y_vel * self.stats.size * 10)
  end
  local x_tmp, y_tmp = self.body:getPosition()
  self.coord.x = x_tmp
  self.coord.y = y_tmp + self.collider_height / 2
  --self:handleWeapons(dt)
  self.animations.current:update(dt)
end

function Player:draw()
  love.graphics.setColor(COLORS.white)
  love.graphics.draw(self.image, self.coord.x - self.image:getWidth()/2, self.coord.y - self.image:getHeight(), self.r)
  self:drawHealth(0, 50)
  self:drawWeapon()
  self.animations.current:draw(self.sheet, self.coord.x, self.coord.y)
end

function Player:keypressed(key)
  if key == "space" then
    self.tool:attack(self, self.map)

  elseif key == "e" then
    self.inventory:setActive(not self.inventory:getActive())
  end

end

function Player:die()
  Gamestate.switch(menu)
end


function Player:handleWeapons(dt)
  local time_left = self.weapon.hitbox.time_left
  if time_left ~= nil then
    time_left = time_left - dt
    if time_left < 0 then
      self.weapon.hitbox.body:destroy()
      self.weapon.hitbox.time_left = nil -- let us know that it's done
    end
  end
end

function Player:drawWeapon()
  local bar_width = 50
  local x = math.floor(self.coord.x)
  local y = math.floor(self.coord.y)
  love.graphics.setColor(1,1,3)
  love.graphics.rectangle('line', x - bar_width / 2, y+40, bar_width, 10)
  love.graphics.rectangle('fill', x - bar_width / 2, y+40, self.tool:getRecharge() * bar_width, 10)
end