
local highlighted = 1
StartState = Class{__includes = BaseState}

function StartState:enter(params)
    self.highScores = params.highScores
end

function StartState:update(dt)
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        highlighted = highlighted == 1 and 2 or 1
        gSounds['paddle-hit']:play()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['confirm']:play()

        if highlighted == 1 then
            gStateMachine:change('serve', {
                bricks = LevelMaker.createMap(1),
                score = 0,
                highScores = self.highScores,
                level = 1,
                recoverPoints = 5000, 
                ball = Ball(math.random(4))
            })
        else
            gStateMachine:change('high-scores', {
                highScores = self.highScores
            })
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function StartState:render()
    love.graphics.setColor(200/255, 200/255, 200/255, 1)
    love.graphics.setFont(gFonts['xlarge'])
    love.graphics.printf("PORTAL", 0, VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH, 'center')
    love.graphics.printf("BRICK", 0, VIRTUAL_HEIGHT / 3 - 45,
        VIRTUAL_WIDTH, 'center')
    
    love.graphics.setColor(255, 255, 255, 255)

    love.graphics.setFont(gFonts['large'])

    if highlighted == 1 then
        love.graphics.setColor(50/255, 50/255, 50/255, 1)
    end
    love.graphics.printf("START", 0, VIRTUAL_HEIGHT / 2 + 70,
        VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(255, 255, 255, 255)

    if highlighted == 2 then
        love.graphics.setColor(50/255, 50/255, 50/255, 1)
    end
    love.graphics.printf("HIGH SCORES", 0, VIRTUAL_HEIGHT / 2 + 110,
        VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(255, 255, 255, 255)
end