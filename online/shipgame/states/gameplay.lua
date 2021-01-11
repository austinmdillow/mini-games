gameplay = {}

function gameplay:enter()

end

function gameplay:update(dt)

    --lovebird.update()
    if game_data.mode == "online" then
        server:update()
    end

    if game_data.mode == "single" then
        game_data.local_player:update(dt)
        local dx,dy = game_data.local_player.coord.x - camera.x, game_data.local_player:getY() - camera.y
        camera:move(dx/2, dy/2)
    end
    

    for idx, bullet in pairs(game_data.bullet_list) do
        bullet:update(dt)
        if outOfBounds(bullet.coord) or bullet:dead() then
            table.remove(game_data.bullet_list, idx)
        end
    end

    for key, enemy in pairs(game_data.enemy_list) do
        local result = enemy:update(dt)
        if result == "fire" then
            local tmp_bullet = Bullet(enemy.coord)
            tmp_bullet:setTeamAndSource(-1, key)
            table.insert(game_data.bullet_list, tmp_bullet)
        end
    end

    checkCollisions()
    generateEnemies(dt)
    updateHud(dt)

    if game_data.mode == "online" then
        sendclient_listData()
    end

end


function gameplay:draw()
  camera:attach()

  if game_data.mode == "online" then
      for index, ship in ipairs(game_data.client_list) do
          ship:draw()
      end
  elseif game_data.mode == "single" then
      game_data.local_player:draw()
  end

    for index, enemy in pairs(game_data.enemy_list) do
        enemy:draw()
    end

    for index, bullet in pairs(game_data.bullet_list) do
      --print("bullet rpint" , index, bullet)
        if bullet ~= nil then
             bullet:draw()
        end
    end
    drawBoundaries()
    camera:detach()

    drawHUD()

    if game_data.mode == "server" then
        drawServerDebug()
    elseif game_data.mode == "single" then
        drawDebugInfo()
    end


end

function gameplay:keypressed(key)
    print("key press")
    if key == "e" then
        game_data.current_enemy_number = game_data.current_enemy_number + 1
        --table.insert(game_data.enemy_list, game_data.current_enemy_number, Enemy(500,500))
        local tmp_enemy = Enemy(love.math.random(500), love.math.random(500))
        tmp_enemy.id = game_data.current_enemy_number
        game_data.enemy_list[game_data.current_enemy_number] = tmp_enemy
    end

    if game_data.mode == "single" then
        local result = game_data.local_player:keypressed(key)
        if result == "fire" then
            local tmp_bullet = Bullet(game_data.local_player.coord)
            tmp_bullet:setTeamAndSource(game_data.local_player.team, game_data.local_player)
            table.insert(game_data.bullet_list, tmp_bullet)
        end

    end
end

return gameplay