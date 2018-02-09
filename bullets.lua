---
--- Created by ttwings.
--- DateTime: 2017/10/8 23:01
---
local GameScreen = require("GameScreen")
bullets = {}
local cd = 0
bullets.update = function(dt)
    cd = cd + dt
    local vx,vy
    local lx,ly
    local b,r
    for i = #bullets,1,-1 do
        b = bullets[i]
        r =  b.r or 0
        vx = b.speed * math.cos(r)*dt
        vy = b.speed * math.sin(r)*dt
        b.x = b.x + vx
        b.y = b.y + vy
        lx = b.x - b.x0
        ly = b.y - b.y0
        b.w = 2
        b.h = 2
        if (lx^2 + ly^2)>b.range^2 then
            table.remove(bullets,i)
        ----- 屏幕震动测试
            GameScreen.cam:shake(0.1,4)
            --message = {text=b.name..":"..b.dmgt..b.damage,x=b.x,y=b.y,x0=b.x,y0=b.y,w=2,h=2,r=0,speed=50,range=100,color={255,255,0},cd=2}
            animations.add(b.anim,b.x,b.y)
            messages.add(b.name)
        end
        --if rectangleTest(b, actor) then
        --    table.remove(bullets,i)
        --    --- 屏幕震动测试
        --    GameScreen.cam:shake(0.1,4)
        --    --message = {text=b.name..":"..b.dmgt..b.damage,x=b.x,y=b.y,x0=b.x,y0=b.y,w=2,h=2,r=0,speed=50,range=100,color={255,255,0},cd=2}
        --    animations.add(b.anim,b.x,b.y)
        --    messages.add(b.damage)
        --    actor:subHp(20)
        --end

        for k, v in ipairs(npcs) do
            if rectangleTest(b, v) then
                table.remove(bullets,i)
                --- 屏幕震动测试
                GameScreen.cam:shake(0.1,4)
                --message = {text=b.name..":"..b.dmgt..b.damage,x=b.x,y=b.y,x0=b.x,y0=b.y,w=2,h=2,r=0,speed=50,range=100,color={255,255,0},cd=2}
                animations.add(b.anim,b.x,b.y)
                messages.add(b.damage)
                v:subHp(20)
            end
        end
    end
end

bullets.draw = function()
    for i = #bullets,1,-1 do
        local b = bullets[i]
        love.graphics.setColor(255,255,0,255)
        love.graphics.rectangle("fill",b.x+16,b.y+16,b.w,b.h)
        love.graphics.circle("line",b.x0+16,b.y0+16,b.range)
        love.graphics.setColor({255,255,255,255})
    end
end

bullets.add = function(bullet)
    if cd < bullet.cd then return end
    if cd > bullet.cd then
        cd = 0
--        for i = 1, bullet.combo do
            table.insert(bullets,bullet)
--        end
    end
end

--- 碰撞
function bodyTest(Al,At,Ar,Ab,Bl,Bt,Br,Bb)
    if Ab < Bt or Bb < At then return end
    if Ar > Bl or Br < Al then return end
    return true
end

-- 俩个矩形的碰撞
function rectangleTest(rec1,rec2)
    local Al,At,Ar,Ab,Bl,Bt,Br,Bb
    Al = rec1.x
    At = rec1.y
    Ar = rec1.x + rec1.w
    Ab = rec1.y + rec1.h
    Bl = rec2.x
    Bt = rec2.y
    Br = rec2.x + 32
    Bb = rec2.y + 48
    return bodyTest(Al,At,Ar,Ab,Bl,Bt,Br,Bb)
end

return bullets