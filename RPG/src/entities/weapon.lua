Weapon = Item:extend()

function Weapon:new()
  Weapon.super.new(self)
  self.damage = 33
  self.rate = 1 -- swings per second
  self.durability = math.random(150-10, 150 + 10)
  self.condition = self.durability
  self.range = 44
  self.last_use = 0
  self.sound = love.audio.newSource("assets/sounds/RPG_Sound_Pack/battle/sword-unsheathe5.wav", "static")
end

function Weapon:use()
  print("Weapon last use time " .. self.last_use)
  if (love.timer.getTime() - self.last_use) > 1 / self.rate then
    self.last_use = love.timer.getTime()
    self.condition = self.condition - 1
    self.sound:play()
    return self.damage, self.range
  end
end

function Weapon:getRange()
  return self.range
end

function Weapon:getRecharge()
  return math.min((love.timer.getTime() - self.last_use) * self.rate, 1) -- between 0 and 1
end

function Weapon:attack(attacker, map) -- this should only be called by the player
  --[[ self.weapon.hitbox.body = love.physics.newBody(self.world, self.coord.x + 10, self.coord.y, 'dynamic')
  self.weapon.hitbox.shape = love.physics.newCircleShape(15)
  self.weapon.hitbox.fixture = love.physics.newFixture(self.weapon.hitbox.body, self.weapon.hitbox.shape)
  self.weapon.hitbox.fixture:setFilterData(1,65535,-2)
  self.weapon.hitbox.body:setMass(100) -- set mass to 1 kg
  self.weapon.hitbox.time_left = .5 ]]
  local dmg, rng = self:use()
  print("Dmg rang ", dmg, rng)
  if dmg ~= nil then
    for key, entity in pairs(map.layers[SPRITE_LAYER].sprites) do
      --print(key, entity)
      if entity ~= attacker and attacker.coord:distanceToCoord(entity.coord) < rng then
        entity:knockback(5 * attacker.stats.strength, 0)
        print("hit")
        local killed = entity:harm(dmg)
        if killed == true then
          GAME_DATA.xp = GAME_DATA.xp + entity.stats.xp
          GAME_DATA.kills = GAME_DATA.kills + 1
        end
      end
    end
  end
end

function Weapon:attackPlayer(attacker)
  --[[ self.weapon.hitbox.body = love.physics.newBody(self.world, self.coord.x + 10, self.coord.y, 'dynamic')
  self.weapon.hitbox.shape = love.physics.newCircleShape(15)
  self.weapon.hitbox.fixture = love.physics.newFixture(self.weapon.hitbox.body, self.weapon.hitbox.shape)
  self.weapon.hitbox.fixture:setFilterData(1,65535,-2)
  self.weapon.hitbox.body:setMass(100) -- set mass to 1 kg
  self.weapon.hitbox.time_left = .5 ]]
  local dmg, rng = self:use()
  --print(dmg, rng)
  --print("attacking")
  if dmg ~= nil then
      if attacker.coord:distanceToCoord(player.coord) < rng then
        player:knockback(5 * attacker.stats.strength, 0)
        print("hit the player")
        local killed = player:harm(dmg)
        if killed then
          print("killed")
          --player.body:destroy()
        end
      end
  end
end

