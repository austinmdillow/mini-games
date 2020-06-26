

-- making Flappy bird
function love.load()
	world = love.physics.newWorld(0,0, true)
	background_r = 1
	background_g = 1
	background_b = 1


	background_sky = love.graphics.newImage("assets/day/sky.png")
	background_image = love.graphics.newImage("assets/day/mountain01.png")
	background_x = 0

	guy_sprite = love.graphics.newImage("1x.png")

	animation = newAnimation(guy_sprite,100,100,10)

	score = 0

	frame_width, frame_height = love.graphics.getDimensions()

	love.window.setTitle("Austin's Flappy Brb")

	bird_width = 40
	bird_height = 20

	bird_speed_y = 0
	bird_pos_y = 100

	pipe_width = 40
	pipe_spacing = 150
	pipe_1_x = 400
	pipe_1_y = 150
	pipe_speed = 200
end

function love.update(dt)
	bird_speed_y = bird_speed_y + (600 * dt)
	bird_pos_y = bird_pos_y + bird_speed_y * dt

	if pipe_1_x + pipe_width < 0 then
		resetPipe()
	end

	pipe_1_x = pipe_1_x - (pipe_speed + score * 5) * dt

	background_x = background_x - 10 * dt

	animation.currentTime = animation.currentTime + dt
    if animation.currentTime >= animation.duration then
        animation.currentTime = animation.currentTime - animation.duration
    end


	-- Check Failures
	if bird_pos_y > frame_height or bird_pos_y < 0 then
		love.load()
	end

	if CheckCollision(62 - bird_width/2, bird_pos_y - bird_height/2, bird_width, bird_height, pipe_1_x, 0, pipe_width, pipe_1_y) then
		love.load()
	end

	if CheckCollision(62 - bird_width/2, bird_pos_y - bird_height/2, bird_width, bird_height, pipe_1_x, pipe_1_y + pipe_spacing, pipe_width, 500) then
		love.load()
	end
end


function love.keypressed(key)
	if bird_pos_y > 0 then
		bird_speed_y = -300
	end
end

function love.draw()
	
	-- Draw the background
	love.graphics.setColor(background_r, background_g, background_b)
	love.graphics.rectangle('fill', 0,0,frame_width, frame_height)
	--love.graphics.draw(background_sky,0,500)
	love.graphics.draw(background_sky,0,-100,0,1,1,0,0,0,0)
	love.graphics.draw(background_image, background_x,100,0,1,1,0,0,0,0)

	-- Draw the bird
	love.graphics.push()
	love.graphics.push()
	love.graphics.setColor(1,0,0)
	love.graphics.translate(62, bird_pos_y)
	love.graphics.rotate(bird_speed_y * 1/500)
	love.graphics.rectangle('fill', -bird_width/2,-bird_height/2, bird_width, bird_height)
	love.graphics.setColor(0,0,0)
	love.graphics.circle('fill', 0,0,10)
	love.graphics.pop()
	love.graphics.pop()

	-- Draw Pipe
	love.graphics.setColor(0,1,0)
	love.graphics.rectangle('fill', pipe_1_x, 0, pipe_width, pipe_1_y)
	love.graphics.rectangle('fill', pipe_1_x, pipe_1_y + pipe_spacing, pipe_width, frame_height - pipe_spacing - pipe_1_y)

	-- Draw score
	love.graphics.setColor(0,0,0)
	love.graphics.print(score, 10, 50, 0, 1.5, 1.5)

end

function drawPipe(x_coord, y_offset)

end

function resetPipe()
	score = score + 1
	pipe_1_x = frame_width
	pipe_1_y = love.math.random(10, frame_height - pipe_spacing)
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