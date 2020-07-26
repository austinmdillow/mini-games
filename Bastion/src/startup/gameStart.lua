function gameStart()
  print("Start of game")

  -- require libraries
  Gamestate = require "lib.hump.gamestate"
  sti = require "lib.sti"
  Camera = require "lib.hump.camera"
  Object = require "lib.classic"
  anim8 = require 'lib.anim8.anim8'
  require("src.coord")

  -- import assets
  require("assets.resources")
  
  require("src.environment.interactions")
  require("src.environment.setup")

  -- require all of the levels
  require("src.levels.menu")
  require("src.levels.inn_level")
  require("src.levels.test_world")
  require("src.intersections")

  -- require items
  require("src.entities.item")
  require("src.entities.coin")
  require("src.entities.inventory")
  require("src.entities.walls")

  -- require entities
  require("src.entities.player")
  require("src.entities.enemy")

  -- require common
  require("src.common.debug")
  require("src.common.draw_common")
  require("src.common.update_common")




  PLAYER_SPAWN_LAYER = "PlayerSpawn"
  ENEMY_SPAWN_LAYER = "EnemySpawn"
  ITEM_LAYER = "ItemSpawn"
  SPRITE_LAYER = "SpriteLayer"

end