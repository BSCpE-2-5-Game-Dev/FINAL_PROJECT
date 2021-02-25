
Brick = Class{}

paletteColors = {
    -- red
    [1] = {
        ['r'] = 1,
        ['g'] = 0,
        ['b'] = 0
    },
    -- orange
    [2] = {
        ['r'] = 1,
        ['g'] = 120/255,
        ['b'] = 0
    },
    -- yellow
    [3] = {
        ['r'] = 1,
        ['g'] = 1,
        ['b'] = 0
    },
    -- green
    [4] = {
        ['r'] = 0,
        ['g'] = 1,
        ['b'] = 0
    },
    -- blue
    [5] = {
        ['r'] = 0,
        ['g'] = 80/255,
        ['b'] = 1
    },
    -- violet
    [6] = {
        ['r'] = 200/255,
        ['g'] = 50/255,
        ['b'] = 200/255
    },
    -- sky blue
    [7] = {
        ['r'] = 0,
        ['g'] = 150/255,
        ['b'] = 1
    },
    -- gray
    [8] = {
        ['r'] = 200/255,
        ['g'] = 200/255,
        ['b'] = 200/255
    },
    -- dark gray
    [9] = {
        ['r'] = 50/255,
        ['g'] = 50/255,
        ['b'] = 50/255
    },
    -- purple
    [10] = {
        ['r'] = 160/255,
        ['g'] = 50/255,
        ['b'] = 160/255
    },
    -- black
    [11] = {
        ['r'] = 0,
        ['g'] = 0,
        ['b'] = 0
    }
}

function Brick:init(x, y, level)
    self.counter = level
    self.color = math.random(1,10)
    
    self.x = x
    self.y = y
    self.width = 32
    self.height = 32
  
    self.inPlay = true

    self.portal = false
    self.hollow = false

    self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 64)

    self.psystem:setParticleLifetime(0.5, 3)

    self.psystem:setLinearAcceleration(-15, 50, 15, 180)

    self.psystem:setAreaSpread('normal', 10, 10)
end

function Brick:hit()
    self.psystem:setColors(
        paletteColors[self.color].r,
        paletteColors[self.color].g,
        paletteColors[self.color].b,
        55,
        paletteColors[self.color].r,
        paletteColors[self.color].g,
        paletteColors[self.color].b,
        0
    )
    self.psystem:emit(64)

    gSounds['brick-hit-2']:stop()
    gSounds['brick-hit-2']:play()

    if self.counter > 1 then
        self.counter = self.counter - 1
    elseif self.counter == 1 then
        self.inPlay = false
    end
   
    if not self.inPlay then
        gSounds['brick-hit-1']:stop()
        gSounds['brick-hit-1']:play()
    end
end

function Brick:update(dt)
    self.psystem:update(dt)
end

function Brick:render()
    if self.inPlay then
        if self.portal == false and self.hollow == false then
            love.graphics.draw(gTextures['main'],
                gFrames['bricks'][self.color],
                self.x, self.y)
            love.graphics.setFont(gFonts['medium']) 
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.print(tostring(self.counter), self.x + 12, self.y + 8)
            love.graphics.setColor(1, 1, 1, 1)
        elseif self.portal then
            love.graphics.draw(gTextures['main'], gFrames['bricks'][11], self.x, self.y)
        elseif self.hollow then
            love.graphics.draw(gTextures['main'], gFrames['bricks'][12], self.x, self.y)
        end
    end
end

function Brick:renderParticles()
    love.graphics.draw(self.psystem, self.x + 16, self.y + 8)
end