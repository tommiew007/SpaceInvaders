-- Invaders
-- RJ 20200803

function setup()
    Runner = GameRunner()
    runTests()
    SoundPlayer = Sound()
    createShields()
    createBombTypes()
    setupGunner()
    invaderNumber = 1
    Lives = 3
    Score = 0
    Line = image(208,1)
    for x = 1,208 do
        Line:set(x,1,255, 255, 255)
    end
end

function draw()
    pushMatrix()
    pushStyle()
    background(40, 40, 50)
    showTests()
    Runner:draw()
    popStyle()
    popMatrix()
    Runner:update()
end

function drawStatus()
    pushStyle()
    tint(0,255,0)
    sprite(Line,8,16)
    textMode(CORNER)
    fontSize(10)
    text(tostring(Lives), 24, 4)
    text("SCORE " .. tostring(Score), 144, 4)
    if Runner.updateCount == 1 then
        text("YES", 144,14)
    else
        text("NO", 170,14)
    end
    text(tostring(DeltaTime), 170,24)
    tint(0,255,0)
    local addr = 40
    for i = 0,Lives-2 do
        sprite(asset.play,40+16*i,4)
    end
    if Lives == 0 then
        textMode(CENTER)
        text("GAME OVER", 112, 32)
    end
    popStyle()
end

function runTests()
    local det = CodeaUnit.detailed
    CodeaUnit.detailed = false
    Console = _.execute()
    CodeaUnit.detailed = det
end

function showTests()
    pushMatrix()
    pushStyle()
    fontSize(50)
    textAlign(CENTER)
    if not Console:find("0 Failed") then
        stroke(255,0,0)
        fill(255,0,0)
    elseif not Console:find("0 Ignored") then
        stroke(255,255,0)
        fill(255,255,0)
    else
        fill(0,128,0)
    end
    text(Console, WIDTH/2, HEIGHT-200)
    popStyle()
    popMatrix()
end

function rectanglesIntersectAt(bl1,w1,h1, bl2,w2,h2)
    if rectanglesIntersect(bl1,w1,h1, bl2,w2,h2) then
        return bl1
    else
        return nil
    end
end

function rectanglesIntersect(bl1,w1,h1, bl2,w2,h2)
   local tr1 = bl1 + vec2(w1,h1) - vec2(1,1)
   local tr2 = bl2 + vec2(w2,h2) - vec2(1,1)
   if bl1.y > tr2.y or bl2.y > tr1.y then return false end
   if bl1.x > tr2.x or bl2.x > tr1.x then return false end
   return true
end

function createBombTypes()
    BombTypes = {
{readImage(asset.plunger1), readImage(asset.plunger2), readImage(asset.plunger3), readImage(asset.plunger4)},
{readImage(asset.rolling1), readImage(asset.rolling2), readImage(asset.rolling3), readImage(asset.rolling4)},
{readImage(asset.squig1), readImage(asset.squig2), readImage(asset.squig3), readImage(asset.squig4)}
    }
    BombExplosion = readImage(asset.alien_shot_exploding)
end

function createShields()
    local img = readImage(asset.shield)
    local posX = 34
    local posY = 48
    Shields = {}
    for s = 1,4 do
        local entry = Shield(img:copy(), vec2(posX,posY))
        table.insert(Shields,entry)
        posX = posX + 22 + 23
    end
end

function drawShields()
    pushStyle()
    for i,shield in ipairs(Shields) do
        shield:draw()
    end
    popStyle()
end
