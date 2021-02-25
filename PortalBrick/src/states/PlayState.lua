
PlayState = Class{__includes = BaseState}

portalBrick = false

function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.score = params.score
    self.highScores = params.highScores
    self.ball = params.ball
    self.level = params.level

    self.ballcount = params.ballcount

    self.recoverPoints = 5000
    
    if self.ball[1].x < VIRTUAL_WIDTH / 4 then
        self.ball[1].dx = math.random(-300, -450)
        self.ball[1].dy = math.random(-16, -200)
    elseif self.ball[1].x >= VIRTUAL_WIDTH / 4 and self.ball[1].x < VIRTUAL_WIDTH / 2 then
        self.ball[1].dx = math.random(-150, -300)
        self.ball[1].dy = math.random(-150, -300)
    elseif self.ball[1].x >= VIRTUAL_WIDTH / 2 and self.ball[1].x < VIRTUAL_WIDTH * 0.75 then
        self.ball[1].dx = math.random(150, 300)
        self.ball[1].dy = math.random(-150, -300)
    elseif self.ball[1].x >= VIRTUAL_WIDTH * 0.75 and self.ball[1].x <= VIRTUAL_WIDTH then
        self.ball[1].dx = math.random(300, 450)
        self.ball[1].dy = math.random(-16, -200)
    end

    for k, ball in pairs(self.ball) do
        ball.dy = self.ball[1].dy 
        ball.dx = self.ball[1].dx
    end
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    for k, ball in pairs(self.ball) do
        ball:update(dt)
        if ball.y >= VIRTUAL_HEIGHT + 24 then
            table.remove(self.ball, k)
        end
    end

    for j, ball in pairs(self.ball) do
        for k, brick in pairs(self.bricks) do

            if brick.inPlay and ball:collides(brick) then

                if brick.portal == true then
                    ball.y = VIRTUAL_HEIGHT - 50
                    ball.x = math.random(0, VIRTUAL_WIDTH-8)
                    if ball.dy > 0 then
                        ball.dy = -ball.dy
                    end
                    gSounds['brick-hit-1']:play()
                    brick.inPlay = false
                end
                
                if brick.hollow == true then
                    self.ballcount = self.ballcount - 1
                    table.remove(self.ball, j)
                    gSounds['hurt']:play()
                    brick.inPlay = false
                end
            
                if brick.portal == false and brick.hollow == false then
                   
                    self.score = self.score + (brick.color * 25)
                   
                    brick:hit()

                    if self:checkVictory() then
                        gSounds['victory']:play()

                        gStateMachine:change('victory', {
                            level = self.level,
                            score = self.score,
                            highScores = self.highScores,
                            ball = self.ball,
                            recoverPoints = self.recoverPoints
                        })
                    end

                    if ball.x + 2 < brick.x and ball.dx > 0 then
                        ball.dx = -ball.dx
                        ball.x = brick.x - 8
                    elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then
                        ball.dx = -ball.dx
                        ball.x = brick.x + 32
                    elseif ball.y < brick.y then
                        ball.dy = -ball.dy
                        ball.y = brick.y - 8
                    else
                        ball.dy = -ball.dy
                        ball.y = brick.y + 32
                    end

                    if math.abs(ball.dy) < 150 then
                        ball.dy = ball.dy * 1.02
                    end
                    
                    break
                end
            end
        end
    end

    if #self.ball == 0 then
        if self:reachBottom() then
            gSounds['hurt']:play()

            gStateMachine:change('game-over', {
                score = self.score,
                highScores = self.highScores
            })
        else
            gStateMachine:change('ready', {
                bricks = self.bricks,
                score = self.score,
                highScores = self.highScores,
                level = self.level,
                recoverPoints = self.recoverPoints, 
                ball = Ball(math.random(4)),
                ballcount = self.ballcount
            })
        end
    end

    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

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

    love.graphics.setColor(0, 80/255, 1, 1)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Level ' .. tostring(self.level), 0, 32,
        VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1, 1, 1, 1)
    
    if self.paused then
        love.graphics.setColor(1, 0, 0, 0.3)
        love.graphics.rectangle('fill', 0, 48, VIRTUAL_WIDTH, VIRTUAL_HEIGHT - 88)
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end 
    end

    return true
end

function PlayState:reachBottom()
    for k, brick in pairs(self.bricks) do
        if brick.y >= VIRTUAL_HEIGHT - 72 then
            return true
        end 
    end

    return false
end