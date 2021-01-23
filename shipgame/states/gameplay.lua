gameplay = {}

function gameplay:enter()
    game_data.level_score = 0 --reset the score for this level
    game_data.level_kills = 0 -- not used
    game_data.local_player:reset() -- give the player back their health
    game_data.bullet_list = {} -- empty out the agents in the field
    game_data.enemy_list = {}
    game_data.item_list = {}
    game_data.local_player:setXYT(500, 500, 0)
    gameplay.spawner = Spawner(game_data.current_level)
end

function gameplay:update(dt)

    --lovebird.update()
    screen:update(dt)

    if (not game_data.gameplay_paused) then
        game_data.local_player:update(dt)
        local dx,dy = game_data.local_player.coord.x - camera.x, game_data.local_player:getY() - camera.y
        --camera:move(dx/2, dy/2)
        camera:lockPosition(game_data.local_player.coord.x, game_data.local_player.coord.y, camera.smoother)
        
        for idx, bullet in pairs(game_data.bullet_list) do
            bullet:update(dt)
            if outOfBounds(bullet.coord) or bullet:dead() then
                table.remove(game_data.bullet_list, idx)
            end
        end
        local enemy_count = 0
        for key, enemy in pairs(game_data.enemy_list) do
            local result = enemy:update(dt)
            if result == "fire" then
                local tmp_bullet = Bullet(enemy.coord)
                tmp_bullet:setTeamAndSource(enemy.team, key)
                table.insert(game_data.bullet_list, tmp_bullet)
            end
            enemy_count = enemy_count + 1 -- count the number of enemies
        end
        game_data.enemies_alive = enemy_count -- update the number of enemies alive

        -- updatee other odds and ends
        checkCollisions()
        gameplay.spawner:update(dt)
        updateHud(dt)
        checkEndLevel(1)
    end

end

-- Drawing time
function gameplay:draw()
    camera:attach()
    love.graphics.setColor(1,1,1, .7)
    love.graphics.draw(background)

    screen:apply(dt)

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
    print("key press", key)
    if key == "e" then
        game_data.current_enemy_number = game_data.current_enemy_number + 1
        --table.insert(game_data.enemy_list, game_data.current_enemy_number, Enemy(500,500))
        local tmp_enemy = Enemy(love.math.random(500), love.math.random(500))
        tmp_enemy.id = game_data.current_enemy_number
        game_data.enemy_list[game_data.current_enemy_number] = tmp_enemy
    end

    if key == "q" then
        game_data.current_enemy_number = game_data.current_enemy_number + 1
        --table.insert(game_data.enemy_list, game_data.current_enemy_number, Enemy(500,500))
        local tmp_enemy = EnemyFighter(love.math.random(500), love.math.random(500))
        tmp_enemy.id = game_data.current_enemy_number
        game_data.enemy_list[game_data.current_enemy_number] = tmp_enemy
        print(tmp_enemy.sprite_image)
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

    if key == "p" then
        game_data.gameplay_paused = not game_data.gameplay_paused
    end

    if key == "escape" then
        Gamestate.switch(main_menu)
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

        if gameplay.spawner:completed() then
            save_data.level_stats[game_data.current_level].completed = true
            save_data.level_stats[game_data.current_level].kills = game_data.level_kills
            save_data.level_stats[game_data.current_level].score = game_data.level_score
            Gamestate.switch(main_menu)
        end

    end
end

function checkCollisions()
    local start_time_col = love.timer.getTime()
    for idx_bullet, bullet in pairs(game_data.bullet_list) do
        local bullet_x, bullet_y = bullet:getXY()

        if bullet.source ~= game_data.local_player then
            if game_data.local_player.coord:distanceToPoint(bullet_x, bullet_y) < game_data.local_player.hitbox + bullet.size then
                game_data.local_player:damage(bullet.damage)
                screen:shake(20)
                game_data.bullet_list[idx_bullet] = nil
            end 
        end

        for idx, enemy in pairs(game_data.enemy_list) do
            
            -- there was a hit
            if enemy.team ~= bullet.team and enemy.coord:distanceToPoint(bullet_x, bullet_y) < enemy.hitbox + bullet.size then
                game_data.bullet_list[idx_bullet] = nil
                if enemy:damage(bullet.damage) then -- the bullet killed the enemy
                    game_data.enemy_list[idx] = nil
                    screen:shake(50)
                    print("KILLLLEEDDD")
                    game_data.level_score = game_data.level_score + enemy.difficulty
                end
            end
        end

    end

    for idx_item, item in pairs(game_data.item_list) do
        if item.coord:distanceToCoord(game_data.local_player.coord) < item.size + game_data.local_player.size then
            game_data.item_list[idx_item] = nil
            game_data.level_score = game_data.level_score + 1
        end
    end
    local end_time_col = love.timer.getTime()
end

function drawBoundaries()
    love.graphics.setColor(1,1,1)
    love.graphics.polygon('line', 0,0, game_data.map_properties.width,0, game_data.map_properties.width,game_data.map_properties.height, 0,game_data.map_properties.height)
end

return gameplay