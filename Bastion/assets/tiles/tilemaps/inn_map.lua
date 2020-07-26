return {
  version = "1.4",
  luaversion = "5.1",
  tiledversion = "1.4.1",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 20,
  height = 20,
  tilewidth = 32,
  tileheight = 32,
  nextlayerid = 8,
  nextobjectid = 9,
  properties = {},
  tilesets = {
    {
      name = "RPG_tileset",
      firstgid = 1,
      filename = "../tilesets/RPG_tileset.tsx",
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      columns = 40,
      image = "../tilesets/RPGpack_sheet.png",
      imagewidth = 1280,
      imageheight = 832,
      objectalignment = "unspecified",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 32,
        height = 32
      },
      properties = {},
      terrains = {},
      tilecount = 1040,
      tiles = {
        {
          id = 432,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 435,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 472,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 475,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 736,
          objectGroup = {
            type = "objectgroup",
            draworder = "index",
            id = 2,
            name = "",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            objects = {
              {
                id = 1,
                name = "",
                type = "",
                shape = "rectangle",
                x = 8,
                y = 16,
                width = 24,
                height = 16,
                rotation = 0,
                visible = true,
                properties = {
                  ["collidable"] = true
                }
              }
            }
          }
        },
        {
          id = 737,
          objectGroup = {
            type = "objectgroup",
            draworder = "index",
            id = 2,
            name = "",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            objects = {
              {
                id = 1,
                name = "",
                type = "",
                shape = "rectangle",
                x = 0,
                y = 16,
                width = 24,
                height = 16,
                rotation = 0,
                visible = true,
                properties = {
                  ["collidable"] = true
                }
              }
            }
          }
        },
        {
          id = 776,
          objectGroup = {
            type = "objectgroup",
            draworder = "index",
            id = 2,
            name = "",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            objects = {
              {
                id = 1,
                name = "",
                type = "",
                shape = "rectangle",
                x = 8,
                y = 0,
                width = 24,
                height = 32,
                rotation = 0,
                visible = true,
                properties = {
                  ["collidable"] = true
                }
              }
            }
          }
        },
        {
          id = 777,
          objectGroup = {
            type = "objectgroup",
            draworder = "index",
            id = 2,
            name = "",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            objects = {
              {
                id = 1,
                name = "",
                type = "",
                shape = "rectangle",
                x = 0,
                y = 0,
                width = 24,
                height = 32,
                rotation = 0,
                visible = true,
                properties = {
                  ["collidable"] = true
                }
              }
            }
          }
        },
        {
          id = 852,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 853,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 854,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 855,
          properties = {
            ["collidable"] = true
          }
        }
      }
    }
  },
  layers = {
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 4,
      name = "PlayerSpawn",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {
        {
          id = 3,
          name = "default_spawn",
          type = "",
          shape = "point",
          x = 128,
          y = 224,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["default"] = true
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 7,
      name = "ItemSpawn",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {}
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 3,
      name = "DoorLayer",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {
        {
          id = 5,
          name = "",
          type = "",
          shape = "rectangle",
          x = 112,
          y = 120,
          width = 32,
          height = 48,
          rotation = 0,
          visible = true,
          properties = {
            ["destination"] = "mainWorld"
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 5,
      name = "EnemySpawn",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {
        {
          id = 6,
          name = "",
          type = "",
          shape = "point",
          x = 480,
          y = 496,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["on_start"] = true
          }
        },
        {
          id = 7,
          name = "",
          type = "",
          shape = "point",
          x = 504,
          y = 312,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 8,
          name = "",
          type = "",
          shape = "point",
          x = 352,
          y = 488,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["on_start"] = true
          }
        }
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 20,
      height = 20,
      id = 1,
      name = "Background",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "base64",
      data = "TAIAAEwCAABMAgAATAIAAEwCAABMAgAATAIAAEwCAABMAgAATAIAAEwCAABMAgAATAIAAE0CAABOAgAATwIAAEwCAABNAgAATgIAAE8CAAB0AgAAdAIAAHQCAAB0AgAAdAIAAHQCAAB0AgAAdAIAAHQCAAB0AgAAdAIAAHQCAAB0AgAATAIAAEwCAABMAgAATQIAAE4CAAB2AgAAdwIAAJwCAACcAgAAnAIAAJwCAACcAgAAnAIAAJwCAACcAgAAnAIAAJwCAACcAgAAnAIAAJwCAAB0AgAAdAIAAEwCAABNAgAATgIAAE4CAACfAgAATAIAAEwCAABMAgAATAIAAEwCAABMAgAATAIAAEwCAABMAgAATAIAAEwCAABMAgAATAIAAEwCAABNAgAATgIAAE4CAABOAgAATAIAAEwCAAB0AgAAdAIAAHQCAAB0AgAAdAIAAHQCAAB0AgAAdAIAAHQCAAB0AgAAdAIAAHQCAAB0AgAATAIAAEwCAABMAgAATAIAAEwCAAB0AgAATAIAAJwCAACcAgAAnAIAAJwCAACcAgAAnAIAAJwCAACcAgAAnAIAAJwCAACcAgAAnAIAAJwCAAB0AgAAdAIAAHQCAAB0AgAAdAIAAJwCAABMAgAATAIAAE0CAABOAgAATgIAAJ4CAACeAgAAngIAAJ4CAAB2AgAAdgIAAHYCAAB2AgAAdgIAAJwCAACcAgAAnAIAAJwCAACcAgAATAIAAE0CAABMAgAATQIAAE4CAAB2AgAATgIAAE4CAACcAgAAnQIAAJ4CAACeAgAAngIAAJ4CAACeAgAAngIAAJ4CAABMAgAATQIAAE4CAABOAgAATgIAAE0CAABOAgAATgIAAJ4CAAB2AgAAdgIAAJ4CAABMAgAATQIAAE4CAACeAgAATwIAAEwCAABNAgAATgIAAEwCAABNAgAATgIAAHYCAAB2AgAATQIAAE4CAAB2AgAAngIAAJ4CAACeAgAAdgIAAHQCAAB1AgAAdgIAAE4CAAB3AgAAdAIAAHUCAAB2AgAATAIAAE0CAABOAgAAngIAAJ4CAABNAgAATgIAAJ4CAACcAgAAnQIAAJ4CAACeAgAAnAIAAJ0CAACeAgAAdgIAAE4CAABOAgAAnQIAAEwCAAB0AgAAdQIAAHYCAACdAgAAngIAAE0CAABOAgAAnQIAAEwCAABNAgAATgIAAE4CAABOAgAAnAIAAJ0CAACeAgAAdgIAAHYCAABOAgAATQIAAJwCAACdAgAAngIAAJwCAACdAgAATQIAAE4CAABMAgAATQIAAE4CAABOAgAAdgIAAHYCAAB2AgAAnAIAAJ0CAACeAgAAngIAAHYCAABOAgAAdgIAAHYCAACeAgAAnAIAAJ0CAABNAgAATgIAAEwCAABNAgAATgIAAHYCAACeAgAAngIAAJ4CAACeAgAAngIAAJwCAACdAgAAngIAAHYCAABOAgAATgIAAE4CAACcAgAAnQIAAE0CAABOAgAATAIAAEwCAABMAgAATAIAAEwCAABMAgAATAIAAEwCAABMAgAATAIAAJwCAACdAgAAngIAAHYCAAB2AgAAdgIAAJwCAACdAgAATAIAAE0CAAB0AgAAdAIAAHQCAAB0AgAAdAIAAHQCAAB0AgAAdAIAAHQCAAB0AgAAdAIAAJwCAACdAgAAngIAAJ4CAACeAgAAnAIAAJ0CAABMAgAATAIAAJwCAACcAgAAnAIAAJwCAACcAgAAnAIAAJwCAACcAgAAnAIAAJwCAACcAgAAnAIAAJ0CAACeAgAATAIAAE0CAACcAgAAnQIAAHQCAAB0AgAAdAIAAHQCAACcAgAATAIAAE0CAABMAgAATQIAAE4CAABOAgAATgIAAE4CAABOAgAATgIAAE4CAABOAgAATgIAAE4CAABOAgAATAIAAEwCAABMAgAATAIAAEwCAABMAgAATAIAAHQCAAB1AgAAdgIAAHYCAAB2AgAAdgIAAHYCAAB2AgAAdgIAAHYCAAB2AgAAdgIAAHYCAAB0AgAAdAIAAHQCAAB0AgAAdAIAAHQCAAB0AgAAnAIAAJ0CAACeAgAAngIAAJ4CAACeAgAAngIAAJ4CAACeAgAAngIAAJ4CAACeAgAAngIAAA=="
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 6,
      name = "SpriteLayer",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {}
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 20,
      height = 20,
      id = 2,
      name = "Midground1",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "base64",
      data = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAtAwAALgMAAC0DAAAuAwAALQMAAC4DAAAtAwAALgMAAC0DAAAuAwAALQMAAC4DAAAtAwAALgMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAtAEAAFUDAABWAwAAVQMAAFYDAABVAwAAVgMAAFUDAABWAwAAVQMAAFYDAABVAwAAVgMAAFUDAABWAwAAsQEAAAAAAAAAAAAAAAAAAAAAAAC0AQAA3QMAAN4DAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADhAgAA4gIAAAAAAACxAQAAAAAAAAAAAAAAAAAAAAAAALQBAAAFBAAABgQAAOECAADiAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAkDAAAKAwAAAAAAALEBAAAAAAAAAAAAAAAAAAAAAAAAtAEAAAAAAAAAAAAACQMAAAoDAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAsQEAAAAAAAAAAAAAAAAAAAAAAAC0AQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACxAQAAAAAAAAAAAAAAAAAAAAAAALQBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADhAgAA4gIAAAAAAAAAAAAAAAAAALEBAAAAAAAAAAAAAAAAAAAAAAAAtAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAkDAAAKAwAAAAAAAAAAAAAAAAAAsQEAAAAAAAAAAAAAAAAAAAAAAAC0AQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACxAQAAAAAAAAAAAAAAAAAAAAAAALQBAAAAAAAAAAAAAAAAAAAAAAAA4QIAAOICAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALEBAAAAAAAAAAAAAAAAAAAAAAAAtAEAAAAAAAAAAAAAAAAAAAAAAAAJAwAACgMAAAAAAAAAAAAAAAAAAAAAAAAAAAAA4QIAAOICAAAAAAAAsQEAAAAAAAAAAAAAAAAAAAAAAAC0AQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJAwAACgMAAAAAAACxAQAAAAAAAAAAAAAAAAAAAAAAALQBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALEBAAAAAAAAAAAAAAAAAAAAAAAAtAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAsQEAAAAAAAAAAAAAAAAAAAAAAAC0AQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACxAQAAAAAAAAAAAAAAAAAAAAAAALQBAAAtAwAALgMAAC0DAAAuAwAALQMAAC4DAAAtAwAALgMAAC0DAAAuAwAALQMAAC4DAAAtAwAALgMAALEBAAAAAAAAAAAAAAAAAAAAAAAA3AEAAFUDAABWAwAAVQMAAFYDAABVAwAAVgMAAFUDAABWAwAAVQMAAFYDAABVAwAAVgMAAFUDAABWAwAA2QEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=="
    }
  }
}
