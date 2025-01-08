-- RJ 20200803
    
function testCodeaUnitFunctionality()
    CodeaUnit.detailed = true

    _:describe("Invaders Test Suite", function()

        _:before(function()
            --Missile = {v=0, p=vec2(0,0)}
            createBombTypes()
            SoundPlayer = Sound()
            Line = image(1,1)
        end)

        _:after(function()
            -- Some teardown
        end)

        _:test("Hookup test", function()
            _:expect("Foo").is("Foo")
        end)
        
        _:test("Screen is 1366 wide", function()
            _:expect(WIDTH).is(1366)
        end)
        
        _:test("Screen facts", function()
            local gameConsumes = 244*4
            _:expect(gameConsumes).is(976)
            local leftMargin = 1366/2 - 244*2
            _:expect(leftMargin).is(195)
            local fireTouch = 1366-195
            _:expect(fireTouch).is(1171)
            local moveLeft = 195//2
            _:expect(moveLeft).is(97)
        end)
        
        _:test("invaderNumber starts at 1", function()
            local army = Army()
            _:expect(army.invaderNumber).is(1)
        end)
        
        _:test("invaderNumber increments", function()
            local army = Army()
            _:expect(army.invaderNumber).is(1)
            army:nextInvader()
            _:expect(army.invaderNumber).is(2)
        end)
        
        _:test("nextInvader returns an instance", function()
            local army = Army()
            local i1 = army:nextInvader()
            _:expect(i1).isnt(nil)
        end)
        
        _:test("nextInvader returns unique instances", function()
            local army = Army()
            local i1 = army:nextInvader()
            local i2 = army:nextInvader()
            _:expect(i1).isnt(i2)
        end)
        
        _:test("there are invaders", function()
            local army = Army()
            local n = #army.invaders
            _:expect(n).is(55)
            local inv = #army.invaders[1]
            _:expect(inv).isnt(nil)
        end)
        
        _:test("Bomb hits gunner", function()
            setupGunner()
            Gunner.pos=vec2(50,50)
            -- gunner's rectangle is 16x8 on CORNER
            -- covers x = 50-65 y = 50,57
            local bomb = Bomb(vec2(50,50))
            -- bomb is 3x4, covers x = 50-52 y = 50-53
            _:expect(bomb:killsGunner()).is(true)
            bomb.pos.y = 58
            Gunner.alive = true
            _:expect(bomb:killsGunner()).is(false)
            bomb.pos.y = 57
            Gunner.alive = true
            _:expect(bomb:killsGunner()).is(true)
            bomb.pos.x = 48 --  covers x = 48,49,50
            Gunner.alive = true
            _:expect(bomb:killsGunner()).is(true)
            bomb.pos.x = 47 -- 47,48,49
            Gunner.alive = true
            _:expect(bomb:killsGunner()).is(false)
            bomb.pos.x = 65 -- 65,66,67
            Gunner.alive = true
            _:expect(bomb:killsGunner()).is(true)
            bomb.pos.x = 66 -- 66,67,68
            Gunner.alive = true
            _:expect(bomb:killsGunner()).is(false)
        end)
        
        _:test("rectangle high right hits no visible bits", function()
            local shield = createTestShield()
            local hitNo = shield:hitBits(vec2(112,108),3,4)
            _:expect(hitNo).is(false)
        end)
        
        _:test("rectangle at origin hits visible bits", function()
            local shield = createTestShield()
            local hitYes = shield:hitBits(vec2(100,100),3,4)
            _:expect(hitYes).is(true)
        end)
        
        _:test("rectangle off to left misses visible bits", function()
            local shield = createTestShield()
            local hit = shield:hitBits(vec2(97,100),3,4)
            _:expect(hit).is(false)
        end)
        
        _:test("rectangle just above hits visible bits", function()
            local shield = createTestShield()
            local hit = shield:hitBits(vec2(105,107),3,4)
            _:expect(hit).is(true)
        end)
        
        _:test("invader eats shield", function()
            local simg = readImage(asset.shield) -- 22x16
            local i1img = readImage(asset.inv11) -- 16x8
            local i2img = readImage(asset.inv12)
            local shield = Shield(simg, vec2(100,100)) -- thru 121,115
            Shields = {shield}
            local iPos = vec2(110,110)
            local invader = Invader(iPos, {i1img,i2img}, nil, nil)
            local answer = Shield:checkForShieldDamage(invader)
            _:expect(answer).is(true)
        end)
    
    end)
end

function createTestShield()
    local white = color(255)
    local img = image(22,16) -- lower left quadrant white
    for x=1,11 do
        for y = 1,8 do
            img:set(x,y,white)
        end
    end
    return Shield(img,vec2(100,100))
end

function countTable(t)
    local c = 0
    for k,v in pairs(t) do
        c = c + 1
    end
    return c
end
