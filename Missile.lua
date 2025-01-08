-- Missile
-- RJ 20200901

Missile = class()
    function Missile:init(x)
    self.v = 0
    self.p = vec2(0,0)
    self.explosion = readImage(asset.player_shot_exploding)
    self.explodeCount = 0
end

function Missile:draw()
    if self.v == 0 then return end
    pushStyle()
    if self.explodeCount > 0 then
        tint(self:explosionColor())
        sprite(self.explosion, self.pos.x - 4, self.pos.y)
        self.explodeCount = self.explodeCount - 1
        if self.explodeCount == 0 then
            self.v =  0
        end
    else
        rect(self.pos.x, self.pos.y, 2,4)
    end
    popStyle()
    if self.v > 0 then TheArmy:processMissile(self) end
end

function Missile:update()
    if self.explodeCount ~= 0 or self.v == 0 then return end
    self.pos = self.pos + vec2(0,4)
    if Shield:checkForShieldDamage(self) then
        self.explodeCount = 15
    end
    self:handleOffScreen()
end

function Missile:handleOffScreen()
    if self.pos.y > TheArmy:saucerTop() then
        self.explodeCount = 15
    end
end

function Missile:explosionBits()
    return self.explosion
end

function Missile:shieldHitAdjustment()
    return vec2(2,-1)
end

function Missile:explosionColor()
    return self.pos.y > TheArmy:saucerTop() and color(255,0,0) or color(255)
end

function Missile:bitSize()
    return 1, 4
end

