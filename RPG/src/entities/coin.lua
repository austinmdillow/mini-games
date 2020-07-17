Coin = Item:extend()

function Coin:new(x_start, y_start)
  Coin.super.new(self)
  self.coord = Coord(x_start, y_start)
  self:setImage(sprites.coin_image)
  print("Made a COIIINNN")
end

function Coin:update(dt)
  local player_distance = self.coord:distanceToCoord(player.coord)
  local coin_attraction_speed = 200
  local coin_attraction_distance = 120
  local coin_obtain_distance = 30

  if player_distance < coin_attraction_distance then
    local x_norm, y_norm = self.coord:normalVectorToCoord(player.coord)
    self.coord:add(x_norm * coin_attraction_speed / player_distance, y_norm * coin_attraction_speed / player_distance)
    if player_distance < coin_obtain_distance then
      GAME_DATA.money = GAME_DATA.money + 1
      GAME_DATA.xp = GAME_DATA.xp + 1
      self:cleanMe()
    end
  end
end


