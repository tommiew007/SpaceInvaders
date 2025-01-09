Army = class()

function Army:init()
    local vader11 = readImage(asset.inv11)
    local vader12 = readImage(asset.inv12)
    local vader21 = readImage(asset.inv21)
    local vader22 = readImage(asset.inv22)
    local vader31 = readImage(asset.inv31)
    local vader32 = readImage(asset.inv32)
    local vaders = {
        {vader31,vader32},
        {vader21,vader22}, {vader21,vader22},
        {vader11,vader12}, {vader11,vader12}
    }
    local scores = {30,20,20,10,10}
    self.invaders = {}
    for row = 1,5 do
        for col = 1,11 do
            local p = vec2(col*16, 185-row*16)
            table.insert(self.invaders, 1, Invader(p,vaders[row], scores[row], army))
        end
    end
    self.invaderNumber = 1
    self.overTheEdge = false
    self.motion = vec2(2,0)
    self.bombs = {}
end

function Army:dropBomb(bomb)
    self.bombs[bomb] = bomb
end

function Army:deleteBomb(bomb)
    self.bombs[bomb] = nil
end

function Army:update()
    updateGunner()
    local continue = true
    while(continue) do
        continue = self:nextInvader():update(self.motion, self)
    end
    for b,bomb in pairs(self.bombs) do
        b:update(self)
    end
end

function Army:invaderOverEdge(invader)
    self.overTheEdge = true
end

function Army:nextInvader()
    self:handleCycleEnd()
    local inv = self.invaders[self.invaderNumber]
    self.invaderNumber = self.invaderNumber + 1
    return inv
end

function Army:handleCycleEnd()
    if self.invaderNumber > #self.invaders then
        self.invaderNumber = 1
        self:adjustMotion()
    end
end

local reverse = -1
local stepDown = vec2(0,-8)

function Army:adjustMotion()
    if self.overTheEdge then
        self.overTheEdge = false
        self.motion = self.motion*reverse + stepDown
    else
        self.motion.y = 0 -- stop the down-stepping
    end
end

function Army:draw()
    pushMatrix()
    pushStyle()
    for i,invader in ipairs(self.invaders) do
        invader:draw()
    end
    for b,bomb in pairs(self.bombs) do
        b:draw()
    end
    popStyle()
    popMatrix()
end

function Army:processMissile(aMissile)
    if aMissile.v > 0 and aMissile.pos.y <= self:saucerTop() then
        self:checkForKill(aMissile)
    end
end

function Army:checkForKill(missile)
    for i, invader in ipairs(self.invaders) do
        if invader:killedBy(missile) then
            missile.v = 0
            return
        end
    end
    for b,bomb in pairs(self.bombs) do
        if bomb:killedBy(missile) then
            missile.v = 0
            bomb:explode(self)
            return
        end
    end
end

function Army:saucerTop()
    return self.invaders[#self.invaders].pos.y + 24
end

