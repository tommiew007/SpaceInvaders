-- Sound
-- RJ 20200904

Sound = class()

function Sound:init(x)
    self.sounds = {}
    self.sounds.explosion = asset.explosion
    self.sounds.tone1 = asset.fastinvader1
    self.sounds.tone2 = asset.fastinvader2
    self.sounds.tone3 = asset.fastinvader3
    self.sounds.tone4 = asset.fastinvader4
    self.sounds.killed = asset.invaderkilled
    self.sounds.ufoLo = asset.ufo_lowpitch
    self.sounds.ufoHi = asset.ufo_highpitch
    self.sounds.shoot = asset.shoot
    self.tones = {self.sounds.tone4, self.sounds.tone1, self.sounds.tone2, self.sounds.tone3 }
    self.invaderCounts = {0x32, 0x2B, 0x24, 0x1C, 0x16, 0x11, 0x0D, 0x0A, 0x08, 0x07, 0x06, 0x05, 0x04, 0x03, 0x02, 0x01}
    self.toneCounts = {0x34, 0x2E, 0x27, 0x22, 0x1C, 0x18, 0x15, 0x13, 0x10, 0x0E, 0x0D, 0x0C, 0x0B, 0x09, 0x07, 0x05}
    self.toneInterval = 0x34
    self.toneCount = 1000
    self.toneNumber = 3
end

function Sound:play(aSoundName)
    sound(self.sounds[aSoundName])
end

function Sound:playRaw(aSound)
    sound(aSound)
end

function Sound:update()
    if self.toneCount < self.toneInterval then
        self.toneCount = self.toneCount + 1
    else
        self.toneCount = 0
        self.toneNumber = (self.toneNumber + 1)%4
        self:playRaw(self.tones[self.toneNumber+1])
    end
end
