--[[ A library for storing and playing back animations using anim8
{
    message,
    timestamp,
    level
}

Example input
effects.explosion_6 = {
    image = sprites.explosion_6,
    ttl = 16/30,
    anim = anim8.newAnimation(explosion_6_grid('1-8',1), 2 / 30)
}
 ]]

 AnimationManager = Object:extend()


 function AnimationManager:new()
    self.animation_table = {}
 end

 function AnimationManager:update(dt)
    local current_time = love.timer.getTime()
    for _, animation in pairs(self.animation_table) do
        animation.anim:update(dt)
        if current_time - animation.spawn_time > animation.ttl then
            self.animation_table[_] = nil
        end
    end
 end

 function AnimationManager:draw()
    for _, animation in pairs(self.animation_table) do
        animation.anim:draw(animation.image, animation.x - animation.height / 2, animation.y - animation.height / 2, animation.t)
    end
 end

 function AnimationManager:addAnimation(animator, x, y, t, repeat_anim)
    repeat_animation = repeat_anim or false
    local tmp_animation = {
        x = x,
        y = y,
        t = t or 0,
        height = animator.height,
        image = animator.image,
        spawn_time = love.timer.getTime(),
        ttl = animator.ttl,
        anim = animator.anim:clone()
    }
    table.insert(self.animation_table, tmp_animation)
 end