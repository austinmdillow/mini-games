gameplay = {}

function gameplay:enter()
    game_data.level_score = 0 --reset the score for this level
    game_data.level_kills = 0 -- not used
    game_data.local_player:reset() -- give the player back their health
    game_data.bullet_list = {} -- empty out the agents in the field
    game_data.enemy_list = {}
    game_data.item_list = {}
    game_data.local_player:setXYT(500, 500, 0)
    

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
    checkEndLevel(1)

    if game_data.mode == "online" then
        sendclient_listData()
    end

end

-- Drawing time
function gameplay:draw()
  camera:attach()

    game_data.local_player:draw()

    -- Draw the Enemies
    for index, enemy in pairs(game_data.enemy_list) do
        enemy:draw()
    end

    -- Draw the bullets
    for index, bullet in pairs(game_data.bullet_list) do
        bullet:draw()
    end

    -- Draw the items
    for index, item in pairs(game_data.item_list) do
        item:draw()
    end
    drawBoundaries()
    camera:detach()

    drawHUD()

    if game_data.mode == "server" then
        drawServerDebug()
    elseif game_data.mode == "single" then
        --drawDebugInfo()
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
    end

    if key == "s" then
        print("saving")
        local tmp_save_data = {}
        tmp_save_data.score = game_data.score
        print(SaveData.save(tmp_save_data, "savefile"))
    end

    if key == "i" then
        table.insert(game_data.item_list, Item(100, 100))
    end
end

function checkEndLevel(level_number)

    if game_data.local_player:dead() then
        print("Player has died")
        Gamestate.switch(death_screen)
    end

    if level_number == 1 then
        if game_data.level_score > 10 then -- reached enough kills
            game_data.score = game_data.score + game_data.level_score
            Gamestate.switch(main_menu)
        end
    end
    

end

return gameplay