-- Shields
-- RJ 20200819

Shield = class()

function Shield:init(img, pos)
    self.img = img
    self.pos = pos
end

function Shield:draw()
    tint(0,255,0)
    sprite(self.img, self.pos.x, self.pos.y)
end

function Shield:applyDamage(hitPos, bomb)
    local relativePos = hitPos - self.pos - bomb:shieldHitAdjustment()
    self:clearBombRectangle(relativePos.x, relativePos.y)
    self:clearFromBitmap(relativePos.x, relativePos.y, bomb:explosionBits())
end

function Shield:hitBits(pos,w,h)
    if pos.x ~= pos.x//1 then
        assert(false)
    end
    for x = pos.x,pos.x+w-1 do
        for y = pos.y,pos.y+h-1 do
            local has = self:hasBit(x,y)
            if has then return true end
        end
    end
    return false
end

function Shield:hasBit(x,y)
    local xxx = x - self.pos.x + 1
    local yyy = y - self.pos.y + 1
    local xx = xxx//1
    local yy = yyy//1
    if xx < 1 or xx > 22 or yy < 1 or yy > 16 then return false end
    local r,g,b = self.img:get(xx,yy)
    return r + b + g > 0
end

function Shield:clearFromBitmap(tx,ty, source)
    for x = 1,source.width do
        for y = 1,source.height do
            r,g,b = source:get(x,y)
            if r+g+b > 0 then
                self.img:set(tx+x-1, ty+y-1, 0,0,0,0) 
            end
        end
    end
end

function Shield:clearBombRectangle(tx,ty)
    for x = 1,3 do
        for y = 1,3 do
            self.img:set(tx+x-1, ty+y-1, 0,0,0,0)
        end
    end
end

function Shield:checkForShieldDamage(anObject)
    for i,shield in ipairs(Shields) do
        local hit = shield:damage(anObject)
        if hit then return true end
    end
    return false 
end

function Shield:damage(anObject)
    local w,h = anObject:bitSize()
    local hitPos = rectanglesIntersectAt(anObject.pos,w,h, self.pos,22,16)
    if hitPos == nil then return false end
    if not self:hitBits(anObject.pos,w,h) then return false end
    self:applyDamage(hitPos, anObject)
    return true
end

