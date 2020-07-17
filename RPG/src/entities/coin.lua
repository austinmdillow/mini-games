Coin = Item:extend()

function Coin:new(x_start, y_start)
  Coin.super.new(self)
  self.coord = Coord(x_start, y_start)
  self:setImage(sprites.coin_image)
  print("Made a COIIINNN")
end

function Coin:update(dt)
  if self.coord:distanceToCoord(player.coord) < 30 then
    GAME_DATA.money = GAME_DATA.money + 1
    GAME_DATA.xp = GAME_DATA.xp + 1
    self:cleanMe()
  end
end


