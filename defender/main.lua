Object = require "lib.mylove.classic"
require "lib.mylove.coord"
require "lib.mylove.entity"
require "lib.mylove.colors"
require "bullet"
require "enemy"

local FRAME_WIDTH, FRAME_HEIGHT = love.graphics.getDimensions()
local PLAYER = {
  radius = 20, 
  x_pos = 100, 
  y_pos = 100,
  color = {255 / 255, 20 / 255, 147 / 255},
  x_vel = 0,
  y_vel = 0, 
  speed = 100
}

local GAME_DATA = {
  score = 0
}

bullet_list = {}

local enemy_list = {}


function love.load()
  
end 


-- UPDATE
function love.update(dt)

  PLAYER.x_vel = 0 
  PLAYER.y_vel = 0 

  -- reading keyboard input and moving the PLAYER
  if love.keyboard.isDown("up") then 
    PLAYER.y_vel = -PLAYER.speed
  end

  if love.keyboard.isDown("down")then
    PLAYER.y_vel = PLAYER.speed 
  end 

  if love.keyboard.isDown("right")then 
    PLAYER.x_vel = PLAYER.speed
  end 

  if love.keyboard.isDown("left") then
    PLAYER.x_vel = -PLAYER.speed
  end

  
  PLAYER.x_pos = PLAYER.x_pos + PLAYER.x_vel * dt 
  PLAYER.y_pos = PLAYER.y_pos + PLAYER.y_vel * dt 
  --print(PLAYER.x_vel, PLAYER.y_vel)

  -- bullet stuff 
  
  for idx, bullet in pairs(bullet_list) do 
    print(idx, bullet)
    bullet:update(dt)
    if bullet:isDestroyed() then
      table.remove(bullet_list, idx)
      print("death")
    end
  end
  
  for idx, enemy in pairs(enemy_list) do
    enemy:update(dt)
  end

end


-- DRAWING 
function love.draw()
  love.graphics.setColor(0,0,0.3)
  love.graphics.rectangle("fill",0,0,FRAME_WIDTH,FRAME_HEIGHT)
  -- drawing the PLAYER
  love.graphics.setColor(PLAYER.color)
  love.graphics.circle("fill", PLAYER.x_pos, PLAYER.y_pos, PLAYER.radius)
  
  for idx, bullet in pairs(bullet_list)do 
    bullet:draw()
  end

  for idx, enemy in pairs(enemy_list) do
    enemy:draw()
  end

end

function love.keypressed(key)
  if key == "space" then 
    table.insert(bullet_list, Bullet(PLAYER.x_pos, PLAYER.y_pos))
  end 

  if key == "e" then 
    local enemy_x = FRAME_WIDTH - 200 
    local enemy_y = love.math.randomNormal(10, 100)
    table.insert(enemy_list, Enemy(enemy_x, enemy_y))
  end 
end