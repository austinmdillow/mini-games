function gameStart()
  print("Start of game")

  -- require libraries
  Gamestate = require "lib.hump.gamestate"
  sti = require "lib.sti"
  Camera = require "lib.hump.camera"
  Object = require "lib.classic"
  require("src.coord")
  require("src.debug")
  require("src.environment.interactions")
  require("src.environment.setup")

  -- require all of the levels
  require("src.levels.menu")
  require("src.levels.mainWorld")
  require("src.levels.inn_level")
  require("src.intersections")
  require("src.entities.player")
  require("src.entities.enemy")

  -- import assets
  require("assets.resources")

  PLAYER_SPAWN_LAYER = "PlayerSpawn"
  ENEMY_SPAWN_LAYER = "EnemySpawn"

end