-- All sprites (images)



sprites = {}
--sprites.background = love.graphics.newImage()
--sprites.player_img = love.graphics.newImage("assets/sp.png")
sprites.coin_image = love.graphics.newImage("assets/coin_item-1.png")
sprites.player_image = love.graphics.newImage("assets/Spaceship_01_ORANGE.png")
sprites.enemy_image = love.graphics.newImage("assets/Spaceship_02_RED.png")
sprites.enemy_fighter_image = love.graphics.newImage("assets/Spaceship_02_RED.png")
sprites.particle_image = love.graphics.newImage("assets/particle.png")
sprites.explosion_5 = love.graphics.newImage("assets/explosions/explosion-5.png")
sprites.explosion_6 = love.graphics.newImage("assets/explosions/explosion-6.png")

background = love.graphics.newImage("assets/space.jpg")


-- Font time
arcade_font = love.graphics.newFont("assets/fonts/ARCADECLASSIC.TTF", 40)

-- Sounds
sounds = {}
sounds.hit_1 = love.audio.newSource("assets/sounds/hit_1.wav", "static")
sounds.hit_2 = love.audio.newSource("assets/sounds/hit_2.wav", "static")

audio_tags = {
    music_tag = ripple.newTag(),
    effects_tag = ripple.newTag(),
}

audio = {
    
    music = {
        {   
            title = "Dragon Fly",
            artist = "UNknocn",
            song = ripple.newSound(love.audio.newSource("assets/music/dragon_fly.mp3", "stream"), {
                tags = {audio_tags.music_tag},
            }),
        },
    },
    sounds = {
        shot_1 = love.audio.newSource("assets/sounds/shot.wav", "static"),
    },
}

dj = MusicManager(audio.music, audio_tags.music_tag)
dj:play()


--- Animated Effects
local explosion_5_grid = anim8.newGrid(sprites.explosion_5:getHeight(), sprites.explosion_5:getHeight(), sprites.explosion_5:getWidth(), sprites.explosion_5:getHeight())
local explosion_6_grid = anim8.newGrid(sprites.explosion_6:getHeight(), sprites.explosion_6:getHeight(), sprites.explosion_6:getWidth(), sprites.explosion_6:getHeight())

effects = {}
effects.explosion_5 = {
    image = sprites.explosion_5,
    ttl = 22 / 30,
    anim = anim8.newAnimation(explosion_5_grid('1-22',1), 1 / 30),
    height = sprites.explosion_5:getHeight()
}
effects.explosion_6 = {
    image = sprites.explosion_6,
    ttl = 8 / 30,
    anim = anim8.newAnimation(explosion_6_grid('1-8',1), 1 / 30),
    height = sprites.explosion_6:getHeight()
}


ITEM_PIX_WIDTH = 32


ui_elements = {}
ui_elements.metalPanel_blue = love.graphics.newImage("assets/ui_pack_space/PNG/metalPanel_blue.png")
ui_elements.barVertical_green_bottom = love.graphics.newImage("assets/ui_pack_space/PNG/barVertical_green_bottom.png")
ui_elements.barVertical_yellow_bottom = love.graphics.newImage("assets/ui_pack_space/PNG/barVertical_yellow_bottom.png")
ui_elements.barVertical_red_bottom = love.graphics.newImage("assets/ui_pack_space/PNG/barVertical_red_bottom.png")

fonts = {}
fonts.upgrades = love.graphics.newFont("assets/ui_pack_space/Fonts/kenvector_future_thin.ttf", 12)