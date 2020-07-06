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
  self.inventory = Inventory()
  self.inventory:addItem(Axe(), 1)
  self.map = nil
  self.tool = Axe()
  self.collider_height = 32
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
  --print(self.inventory.item_list[1])
  --self.inventory.item_list[3]:print()
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

  self.body:applyForce(vectorX * self.speed * 300, vectorY * self.speed * 300)
  if vectorX == 0 and vectorY == 0 then
    self.body:applyForce(-x_vel * self.stats.size * 10, -y_vel * self.stats.size * 10)
  end
  local x_tmp, y_tmp = self.body:getPosition()
  self.coord.x = x_tmp
  self.coord.y = y_tmp + self.collider_height / 2

  self:handleWeapons(dt)
end

function Player:draw()
  love.graphics.draw(self.image, self.coord.x - self.image:getWidth()/2, self.coord.y - self.image:getHeight(), self.r)
  --love.graphics.draw(self.inventory.item_list[1].image, self.coord.x + 5, self.coord.y - 40, 0)
end

function Player:keypressed(key)
  if key == "space" then
    self:attack()
    local clip = love.audio.newSource("assets/sounds/RPG_Sound_Pack/battle/swing.wav", "static")
    clip:play()

  elseif key == "e" then
    self.inventory:setActive(not self.inventory:getActive())
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
        print("hit")
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