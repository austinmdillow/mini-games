function gameStart()
  print("Start of game")

  -- require libraries
  Gamestate = require "lib.hump.gamestate"
  sti = require "lib.sti"
  Camera = require "lib.hump.camera"
  Object = require "lib.classic"
  require("src.coord")

  -- require all of the levels
  require("src.levels.menu")
  require("src.levels.mainWorld")
  require("src.intersections")
  require("src.entities.player")

  -- import assets
  require("assets.resources")

end