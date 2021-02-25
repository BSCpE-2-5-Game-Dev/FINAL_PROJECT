
VictoryState = Class{__includes = BaseState}

function VictoryState:enter(params)
    self.level = params.level
    self.score = params.score
    self.highScores = params.highScores
    self.ball = params.ball
    self.recoverPoints = params.recoverPoints
end

function VictoryState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('serve', {
            level = self.level + 1,
            bricks = LevelMaker.createMap(self.level + 1),
            score = self.score,
            highScores = self.highScores,
            recoverPoints = self.recoverPoints,
            ball = Ball(math.random(4))
        })
    end
end

function VictoryState:render()
    love.graphics.setColor(1, 1, 1, 0.3)
    love.graphics.rectangle('fill', 0, 48, VIRTUAL_WIDTH, VIRTUAL_HEIGHT - 88)
    love.graphics.setColor(1, 1, 1, 1)

    renderScore(self.score)

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("Level " .. tostring(self.level) .. " Clear",
        0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Enter to Play!', 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')

    local groundWidth = gTextures['ground']:getWidth()
    local groundHeight = gTextures['ground']:getHeight()
    
    love.graphics.draw(gTextures['ground'],
        0, VIRTUAL_HEIGHT - 40,
        0,
        VIRTUAL_WIDTH / (groundWidth - 1), 40 / (groundHeight - 1))
end