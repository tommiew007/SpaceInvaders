Invader = class()

local ScreenRight = 207 -- 223-16 width
local ScreenLeft = 0

function Invader:init(pos, sprites, score, army)
    self.pos = pos
    self.sprites = sprites
    self.score = score
    self.army = army
    self.alive = true
    self.exploding = 0
    self.picture = 0
end

function Invader:draw()
    if self.alive then
        sprite(self.sprites[self.picture+1], self.pos.x, self.pos.y)
    elseif self.exploding > 0 then
        sprite(asset.alien_exploding,self.pos.x,self.pos.y)
        self.exploding = self.exploding - 1
    end
end

function Invader:update(motion, army)
    if not self.alive then return true end
    self.picture = (self.picture+1)%2
    self:possiblyDropBomb(army)
    self.pos = self.pos + motion
    Shield:checkForShieldDamage(self)
    if self:overEdge() then
        army:invaderOverEdge(self)
    end
    return false
end

function Invader:possiblyDropBomb(army)
    if not self:isBottom(army) then return end
    if math.random() < 0.98 then return end
    self:dropBomb(army)
end

function Invader:isBottom()
    return true
end

function Invader:dropBomb(army)
    army:dropBomb(Bomb(self.pos - vec2(0,16 + math.random(0,3))))
end

function Invader:overEdge()
    return self.pos.x >= ScreenRight or self.pos.x <= ScreenLeft
end

function Invader:killedBy(missile)
    if not self.alive then return false end
    if self:isHit(missile) then
        self.alive = false
        Score = Score + self.score
        self.exploding =15
        SoundPlayer:play("killed")
        return true
    else
        return false
    end
end

function Invader:isHit(missile)
    if not self.alive then return false end
    return rectanglesIntersect(missile.pos,2,4, self.pos+vec2(2,0),12,8)
end

function Invader:shieldHitAdjustment()
    return vec2(0,0)
end

function Invader:explosionBits()
    return self.sprites[self.picture+1]
end

function Invader:bitSize()
    return 16, 8
end
