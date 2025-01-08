-- Gunner
-- RJ 20200819

function touched(touch)
    local fireTouch = 1171
    local moveLeft = 97
    local moveRight = 195
    local moveStep = 1.0
    local x = touch.pos.x
    if touch.state == ENDED then
        GunMove = vec2(0,0)
        if x > fireTouch then
            fireMissile()
        end
    end
    if touch.state == BEGAN or touch.state == CHANGED then
        if x < moveLeft then
            GunMove = vec2(-moveStep,0)
        elseif x > moveLeft and x < moveRight then
            GunMove = vec2(moveStep,0)
        end
    end
end

function explode()
    Gunner.alive = false
    Gunner.count = 240
    SoundPlayer:play("explosion")
end

function setupGunner()
    local missile = Missile()
    Gunner = {pos=vec2(104,32),alive=true,count=0,explode=explode,missile=missile}
    GunMove = vec2(0,0)
    GunnerEx1 = readImage(asset.playx1)
    GunnerEx2 = readImage(asset.playx2)
end

function drawGunner()
    pushMatrix()
    pushStyle()
    Gunner.missile:draw()
    tint(0,255,0)
    if Gunner.alive then
        sprite(asset.play,Gunner.pos.x,Gunner.pos.y)
    else
        if Gunner.count > 210 then
            local c = Gunner.count//8
            if c%2 == 0 then
                sprite(GunnerEx1, Gunner.pos.x, Gunner.pos.y)
            else
                sprite(GunnerEx2, Gunner.pos.x, Gunner.pos.y)
            end
        end
        Gunner.count = Gunner.count - 1
        if Gunner.count <= 0 then
            if Lives > 0 then
                Lives = Lives -1
                if Lives > 0 then
                    Gunner.alive = true
                end
            end
        end
    end
    popStyle()
    popMatrix()
end

function updateGunner()
    Gunner.missile:update()
    if Gunner.alive then
        Gunner.pos = Gunner.pos + GunMove + vec2(effectOfGravity(),0)
        Gunner.pos.x = math.max(math.min(Gunner.pos.x,208),0)
    end
end

function effectOfGravity()
    local effect = 0.1
    local gx = Gravity.x
    return gx > effect and 1 or gx < -effect and -1 or 0
end

function fireMissile()
    if not Gunner.alive then return end
    local missile = Gunner.missile
    if missile.v == 0 then
        missile.pos = Gunner.pos + vec2(7,5)
        missile.v = 1
        SoundPlayer:play("shoot")
    end
end
