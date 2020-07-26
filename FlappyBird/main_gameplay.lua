main_gameplay = {}

function main_gameplay:enter(previous)

  score = 0

  background_x = 0
	spencer_x = 700

	bird_speed_y = 0
	bird_pos_y = 100

	pipe_width = 40
	pipe_spacing = 150
	pipe_1_x = 400
  pipe_1_y = 150
  pipe_2_x = frame_width
	pipe_2_y = 150
end

function main_gameplay:leave()

  if score > high_score then
    high_score = score
  end
  
end

function main_gameplay:update(dt)

  bird_speed_y = bird_speed_y + (800 * dt)
	bird_pos_y = bird_pos_y + bird_speed_y * dt

	if pipe_1_x + pipe_width < 0 then
		resetPipe()
	end

  local frame_speed = math.min(pipe_speed + score * 5, max_speed)
  print(frame_speed, love.timer.getFPS())
  pipe_1_x = pipe_1_x - frame_speed * dt
  pipe_2_x = pipe_2_x - frame_speed * dt
  background_x = background_x - frame_speed / 10 * dt
  spencer_x = spencer_x - frame_speed / 20 * dt

  if spencer_x < 62 then
    spencer_found = true
  end

	-- Check Failures
	if bird_pos_y > frame_height or bird_pos_y < 0 then
		Gamestate.switch(round_over)
	end

	if CheckCollision(62 - bird_width/2, bird_pos_y - bird_height/2, bird_width, bird_height, pipe_1_x, 0, pipe_width, pipe_1_y) then
		Gamestate.switch(round_over)
	end

	if CheckCollision(62 - bird_width/2, bird_pos_y - bird_height/2, bird_width, bird_height, pipe_1_x, pipe_1_y + pipe_spacing, pipe_width, 500) then
		Gamestate.switch(round_over)
	end
end


function main_gameplay:keypressed(key)
	if bird_pos_y > 0 then
		bird_speed_y = -300
	end
end

function main_gameplay:mousepressed()
	if bird_pos_y > 0 then
		bird_speed_y = -300
	end
end

function main_gameplay:draw()
	
	-- Draw the background
	love.graphics.setColor(background_r, background_g, background_b)
	love.graphics.rectangle('fill', 0,0,frame_width, frame_height)
	--love.graphics.draw(background_sky,0,500)
  love.graphics.draw(background_sky,0,-100,0,1,1,0,0,0,0)
  love.graphics.draw(small_spencer, spencer_x,300,0,1,1,0,0,0,0)
	love.graphics.draw(background_image, background_x,100,0,1,1,0,0,0,0)

  local bird_rotation = bird_speed_y * 1/500
	-- Draw the bird
	love.graphics.push()
	love.graphics.push()
	love.graphics.setColor(1,0,0)
	love.graphics.translate(62, bird_pos_y)
  love.graphics.rotate(bird_rotation)
  if spencer_draw == true then
    love.graphics.setColor(1,1,1)
    love.graphics.draw(small_spencer, spencer_width/2, -spencer_height/2, math.pi/2)
  else
    love.graphics.rectangle('fill', -bird_width/2,-bird_height/2, bird_width, bird_height)
  end
	love.graphics.pop()
  love.graphics.pop()

	-- Draw Pipe
	drawPipe(pipe_1_x, pipe_1_y)
  
  -- Draw Pipe
	drawPipe(pipe_2_x, pipe_2_y)

	-- Draw score
	love.graphics.setColor(0,0,0)
	love.graphics.print(score, 10, 50, 0, 1.5, 1.5)

end

function drawPipe(x_coord, y_offset)
  love.graphics.setColor(0,1,0)
	love.graphics.rectangle('fill', x_coord, 0, pipe_width, y_offset)
  love.graphics.rectangle('fill', x_coord, y_offset + pipe_spacing, pipe_width, frame_height - pipe_spacing - y_offset)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle('line', x_coord, 0, pipe_width, y_offset)
  love.graphics.rectangle('line', x_coord, y_offset + pipe_spacing, pipe_width, frame_height - pipe_spacing - y_offset)
end

function resetPipe()
  local padding = 25
  score = score + 1
  pipe_1_x = pipe_2_x
  pipe_1_y = pipe_2_y

	pipe_2_x = frame_width
	pipe_2_y = love.math.random(padding, frame_height - pipe_spacing - padding)
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end


function newAnimation(image, width, height, duration)
    local animation = {}
    animation.spriteSheet = image;
    animation.quads = {};
 
    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end
 
    animation.duration = duration or 1
    animation.currentTime = 0
 
    return animation
end