function love.load()
    x = 0
    speed = 200
end
 
 
function love.update(dt)
    x = x + speed * dt
    if x > 800 then
        x = 800
        speed = -speed
    end
 
    if x < 0 then
        x = 0
        speed = -speed
    end
end
 
 
function love.draw()
    love.graphics.circle("fill", x, 200, 50, 50)
end