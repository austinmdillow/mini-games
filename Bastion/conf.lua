-- conf file for tile_test game
function love.conf(t)
  t.window.title = "Bastion"         -- The window title (string)
  t.identity = nil                    -- The name of the save directory (string)
  t.appendidentity = false            -- Search files in source directory before save directory (boolean)
  t.version = "11.3"                  -- The LÖVE version this game was made for (string)
  t.console = false                   -- Attach a console (boolean, Windows only)
  t.window.width = 800                -- The window width (number)
  t.window.height = 600               -- The window height (number)
  t.window.display = 2                -- Index of the monitor to show the window in (number)
end