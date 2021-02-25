
ServeState = Class{__includes = BaseState}

function ServeState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.score = params.score
    self.highScores = params.highScores
    self.level = params.level
    self.recoverPoints = params.recoverPoints
    self.ball = {params.ball}

    self.ball[1].x = VIRTUAL_WIDTH / 2 - 2
    self.ball[1].y = VIRTUAL_HEIGHT - 48
   
    for i = 1, self.level do
        multiBall = Ball()                                     
        multiBall.skin = math.random(4)
        multiBall.x = self.ball[i].x 
        multiBall.y = self.ball[i].y + 8
        multiBall.dy = self.ball[1].dy
        multiBall.dx = self.ball[1].dx
        table.insert(self.ball, multiBall)
    end
    for k, brick in pairs(self.bricks) do
        brick.y = brick.y + 16
    end
end

function ServeState:update(dt)
    local xcoor = 0.2
    for k, ball in pairs(self.ball) do
        if love.keyboard.isDown('left') then
            ball.x = ball.x - xcoor - ((k-(k-0.8))- 0.2*k)
        elseif love.keyboard.isDown('right') then
            ball.x = ball.x + xcoor + ((k-(k-0.8))- 0.2*k)
        end
    end
    
    for k, ball in pairs(self.ball) do
        ball:update(dt)
    end
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play', {
            bricks = self.bricks,
            score = self.score,
            highScores = self.highScores,
            ball = self.ball,
            level = self.level,
            recoverPoints = self.recoverPoints,
            ballcount = 0
        })
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function ServeState:render()
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    love.graphics.setColor(1, 1, 1, 0.3)
    love.graphics.rectangle('fill', 0, 48, VIRTUAL_WIDTH, VIRTUAL_HEIGHT - 88)
    love.graphics.setColor(1, 1, 1, 1)

    for k, ball in pairs(self.ball) do
        ball:render()
    end
    local groundWidth = gTextures['ground']:getWidth()
    local groundHeight = gTextures['ground']:getHeight()
    
    love.graphics.draw(gTextures['ground'],
        0, VIRTUAL_HEIGHT - 40, 
        0,
        VIRTUAL_WIDTH / (groundWidth - 1), 40 / (groundHeight - 1))

    if #self.ball <= 10 then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf(tostring(#self.ball), 0, VIRTUAL_HEIGHT - 36,
            VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(1, 1, 1, 1)
    else
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf('10', 0, VIRTUAL_HEIGHT - 36,
            VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(1, 1, 1, 1)
    end
    
    renderScore(self.score)

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Level ' .. tostring(self.level), 0, VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Enter to Play!', 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
end