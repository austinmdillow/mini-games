require("src.entities.entity")
require("src.entities.weapon")

Player = Entity:extend()

function Player:new(x_start, y_start)
  Player.super.new(self, x_start, y_start)
  self.image = sprites.player_img
  self.speed = 200
  self.weapon = {
    hitbox = {}
  }
  self.inventory = {}
  self.inventory[1] = Weapon()
  self.map = nil
  self.tool = Weapon()
end

function Player:initPhysics(world)
  self.world = world
  self.body = love.physics.newBody(world, self.coord.x, self.coord.y + self.image:getWidth()/2, 'dynamic')
  self.shape = love.physics.newCircleShape(15)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setFilterData(1,65535,-2)
  self.body:setMass(self.stats.size) -- set mass to 1 kg
  self.body:setLinearDamping(1)
end

function Player:initMap(map)
  self.map = map
end

function Player:setPosition(x_set, y_set)
  self.coord.x = x_set
  self.coord.y = y_set

  if self.world ~= nil then
    self.body:setPosition(x_set, y_set)
  end
end


function Player:update(dt)
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

  local x_vel, y_vel = self.body:getLinearVelocity()
  local vel = math.sqrt(x_vel^2 + y_vel ^ 2)
  if vel > self.speed then
    vectorX = 0
    vectorY = 0
  end

  self.body:applyForce(vectorX * self.speed * 200, vectorY * self.speed * 200)
  self.body:applyForce(-x_vel * self.stats.size, -y_vel)
  local x_tmp, y_tmp = self.body:getPosition()
  self.coord.x = x_tmp
  self.coord.y = y_tmp

  self:handleWeapons(dt)
end

function Player:draw()
  love.graphics.draw(self.image, self.coord.x - self.image:getWidth()/2, self.coord.y - self.image:getWidth()/2, self.r)
end

function Player:keypressed(key)
  if key == "space" then
    self:attack()
  end
end


function Player:attack()
  --[[ self.weapon.hitbox.body = love.physics.newBody(self.world, self.coord.x + 10, self.coord.y, 'dynamic')
  self.weapon.hitbox.shape = love.physics.newCircleShape(15)
  self.weapon.hitbox.fixture = love.physics.newFixture(self.weapon.hitbox.body, self.weapon.hitbox.shape)
  self.weapon.hitbox.fixture:setFilterData(1,65535,-2)
  self.weapon.hitbox.body:setMass(100) -- set mass to 1 kg
  self.weapon.hitbox.time_left = .5 ]]
  local dmg, rng = self.tool:use()
  print("attacking")
  if dmg ~= nil then
    for key, entity in pairs(self.map.layers["Sprite Layer"].sprites) do
      print(key, entity)
      if entity ~= self and self.coord:distanceToCoord(entity.coord) < rng then
        entity:knockback(5 * self.stats.strength, 0)
        local killed = entity:harm(dmg)
        if killed then
          print("killed")
          entity.body:destroy()
          self.map.layers["Sprite Layer"].sprites[key] = nil
        end
      end
    end
  end
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