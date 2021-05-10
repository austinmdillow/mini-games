-- The spawner handles what and when to spawn enemies based on the current level.
-- It must be updated in the game loop
-- spawn_sequences hold all info needed to spawn enemis
Spawner = Object:extend()

spawn_sequences = {
  { 
    level = 1,
    {
      wave_num = 1,
      spawn_count = 5,
      type = "fighter",
      spawn_location = {
        x = 400,
        y = 10,
        t = 0
      },
      time_spacing = 0.3,
      max_alive = 2
    },
    {
      wave_num = 2,
      spawn_count = 1,
      type = "fighter",
      spawn_location = {
        x = 400,
        y = 10,
        t = 4
      },
      time_spacing = 3,
      max_alive = 3
    },
    {
      wave_num = 3,
      spawn_count = 10,
      type = "fighter",
      spawn_location = {
        x = 1000,
        y = 10,
        t = 4
      },
      time_spacing = .1,
      max_alive = 10
    }
  },

  { 
    level = 2,
    {
      wave_num = 1,
      spawn_count = 2,
      type = "default",
      spawn_location = {
        x = 400,
        y = 10,
        t = 0
      },
      time_spacing = .6,
      max_alive = 3
    },
    {
      wave_num = 2,
      spawn_count = 3,
      type = "fighter",
      spawn_location = {
        x = 400,
        y = 10,
        t = 0
      },
      time_spacing = 3,
      max_alive = 3
    }
  },

  { level = 3,
    {
      wave_num = 1,
      spawn_count = 2,
      type = "default",
      spawn_location = {
        x = 400,
        y = 10,
        t = 0
      },
      time_spacing = .6,
      max_alive = 3
    },
    {
      wave_num = 2,
      spawn_count = 3,
      type = "fighter",
      spawn_location = {
        x = 400,
        y = 10,
        t = 0
      },
      time_spacing = 3,
      max_alive = 3
    }
  }
}

function Spawner:new(level, map)
  self.map = map
  self.current_level = level
  self.current_wave = 1
  assert(spawn_sequences[self.current_level].level == level)
  self.sequence = spawn_sequences[self.current_level][self.current_wave]
  self.last_spawn_time = 0
  self.wave_spawns = 0
  self.level_spawns = 0

  if self.map ~= nil then
    self:spawnFromMap()
  end

  self:verifyConfig()
end

function Spawner:spawn(enemy_obj, type, x, y)
  x = x or love.math.random(500)
  y = y or love.math.random(500)
  print(x, y)
  game_data.current_enemy_number = game_data.current_enemy_number + 1
  local tmp_enemy = nil
  if self.sequence.type == "fighter" then
    tmp_enemy = EnemyFighter(x, y)
  else
    tmp_enemy = Enemy(x, y)
  end
  tmp_enemy.id = game_data.current_enemy_number
  table.insert(game_data.enemy_list, tmp_enemy)
  self.wave_spawns = self.wave_spawns + 1
  self.level_spawns = self.level_spawns + 1
  self.last_spawn_time = 0
end

function Spawner:update(dt)
    self.last_spawn_time = self.last_spawn_time + dt

    if self.sequence ~= nil then
      assert(self.sequence.wave_num == self.current_wave)
      if self.last_spawn_time > self.sequence.time_spacing and game_data.enemies_alive < self.sequence.max_alive and self.wave_spawns < self.sequence.spawn_count then
        self:spawn()
      end

      if self.wave_spawns >= self.sequence.spawn_count and game_data.enemies_alive == 0 then -- check if we need to switch to another wave
        self.wave_spawns = 0
        self.current_wave = self.current_wave + 1
        self.sequence = spawn_sequences[self.current_level][self.current_wave]
      end
    end
end

function Spawner:spawnFromMap()
  for _, spawn_point in pairs(map.layers.enemy_spawn.objects) do
    self:spawn(nil, nil, spawn_point.x, spawn_point.y)
  end
end

function Spawner:getWave()
  return self.current_wave
end

function Spawner:completed()
  return self.sequence == nil
end

function Spawner:getLevel()
  return self.current_level
end

function Spawner:verifyConfig()
  for index, level_table in pairs(spawn_sequences) do
    print(index, level_table.level, level_table)
    --print(level_table[1].wave_num)
    assert(level_table.level == index, "Level did not match. Expected " .. index)
  end
end