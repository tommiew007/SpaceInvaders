-- Bomb
-- RJ 20200819

Bomb = class()

function Bomb:init(pos)
    self.pos = pos
    self.shapes = BombTypes[math.random(3)]
    self.shape = 0
    self.cycle = 2
    self.explodeCount = 0
end

function Bomb:draw()
    if self.explodeCount > 0 then
        sprite(BombExplosion, self.pos.x, self.pos.y)
        self.explodeCount = self.explodeCount - 1
        if self.explodeCount == 0 then self.army:deleteBomb(self) end
    else
        sprite(self.shapes[self.shape + 1],self.pos.x,self.pos.y)
    end
end

function Bomb:update(army, increment)
    if self.explodeCount > 0 then return end
    self.cycle = (self.cycle +1)%3
    if self.cycle ~= 0 then return end
    self.pos.y = self.pos.y - (increment or 4)
    self.shape = (self.shape + 1)%4
    self:checkCollisions(army)
end

function Bomb:checkCollisions(army)
    if Shield:checkForShieldDamage(self) or self:killsGunner() or self:killsLine() then
        self:explode(army)
    end
end

function Bomb:explode(army)
    self.pos = self.pos - vec2(2,3)
    self.army = army
    self.explodeCount = 15
end

function Bomb:damageLine(bomb)
    local tx = bomb.pos.x - 7
    for x = 1,6 do
        if math.random() < 0.5 then
            Line:set(tx+x,1, 0,0,0,0)
        end
    end            
end

function Bomb:killedBy(missile)
    return rectanglesIntersect(self.pos,3,4, missile.pos,3,4)
end

function Bomb:killsGunner()
    if not Gunner.alive then return false end
    local hit = rectanglesIntersectAt(self.pos,3,4, Gunner.pos,16,8)
    if hit == nil then return false end
    Gunner:explode()
    return true
end

function Bomb:killsLine()
    if self.pos.y > 16 then return false end
    self:damageLine(self)
    return true
end

function Bomb:explosionBits()
    return BombExplosion
end

function Bomb:shieldHitAdjustment()
    return vec2(2,1)
end

function Bomb:bitSize()
    return 3, 4
end
