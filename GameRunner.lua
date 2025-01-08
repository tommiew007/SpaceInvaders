-- GameRunner
-- RJ 20200831

GameRunner = class()

function GameRunner:init()
    TheArmy = Army()
    self:resetTimeToUpdate()
end

function GameRunner:draw()
    pushMatrix()
    pushStyle()
    noSmooth()
    rectMode(CORNER)
    spriteMode(CORNER)
    stroke(255)
    fill(255)
    scale(4) -- makes the screen 1366/4 x 1024/4
    translate(WIDTH/8-112,0)
    TheArmy:draw()
    drawGunner()
    drawShields()
    drawStatus()
    popStyle()
    popMatrix()
end

function GameRunner:update()
     if self:itIsTimeToUpdate() then
        self:resetTimeToUpdate()
        self:doUpdate()
    end
end

function GameRunner:doUpdate()
    TheArmy:update()
    SoundPlayer:update()
end

function GameRunner:itIsTimeToUpdate()
    if DeltaTime < 1/60 then
        self.updateCount = self.updateCount + 1
    else
        self.updateCount = 2
    end
    return self.updateCount == 2
end

function GameRunner:resetTimeToUpdate()
    self.updateCount = 0
end

function GameRunner:touched(touch)
end