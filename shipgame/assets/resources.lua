-- All sprites (images)



sprites = {}
--sprites.background = love.graphics.newImage()
--sprites.player_img = love.graphics.newImage("assets/sp.png")
sprites.coin_image = love.graphics.newImage("assets/coin_item-1.png")
sprites.player_image = love.graphics.newImage("assets/Spaceship_01_ORANGE.png")
sprites.enemy_image = love.graphics.newImage("assets/Spaceship_02_RED.png")
sprites.enemy_fighter_image = love.graphics.newImage("assets/Spaceship_02_RED.png")
sprites.particle_image = love.graphics.newImage("assets/particle.png")

background = love.graphics.newImage("assets/space.jpg")


-- Font time
arcade_font = love.graphics.newFont("assets/fonts/ARCADECLASSIC.TTF", 40)

-- Sounds
sounds = {}
sounds.hit_1 = love.audio.newSource("assets/sounds/hit_1.wav", "static")
sounds.hit_2 = love.audio.newSource("assets/sounds/hit_2.wav", "static")

ITEM_PIX_WIDTH = 32


ui_elements = {}
ui_elements.metalPanel_blue = love.graphics.newImage("assets/ui_pack_space/PNG/metalPanel_blue.png")
ui_elements.barVertical_green_bottom = love.graphics.newImage("assets/ui_pack_space/PNG/barVertical_green_bottom.png")
ui_elements.barVertical_yellow_bottom = love.graphics.newImage("assets/ui_pack_space/PNG/barVertical_yellow_bottom.png")
ui_elements.barVertical_red_bottom = love.graphics.newImage("assets/ui_pack_space/PNG/barVertical_red_bottom.png")

fonts = {}
fonts.upgrades = love.graphics.newFont("assets/ui_pack_space/Fonts/kenvector_future_thin.ttf", 12)