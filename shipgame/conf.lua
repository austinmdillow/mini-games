function love.conf(t)
    t.window.width = 1024
    t.window.height = 768
    t.window.title = "Ship Game"
    t.identity = "shipgame_save"
    t.window.icon = "assets/ship.jpeg"
    t.window.display = 1
    t.version = "11.3"
    t.releases = {
        title = "Ship Game",              -- The project title (string)
        package = "this",            -- The project command and package name (string)
        --loveVersion = "10.0",        -- The project LÖVE version
        version = "0.2.1",            -- The project version
        author = "Rmadillow",             -- Your name (string)
        email = "games@junemobility.com",              -- Your email (string)
        description = "Top down shooter",        -- The project description (string)
        homepage = nil,           -- The project homepage (string)
        identifier = nil,         -- The project Uniform Type Identifier (string)
        excludeFileList = {},     -- File patterns to exclude. (string list)
        releaseDirectory = "releases",   -- Where to store the project releases (string)
      }
end