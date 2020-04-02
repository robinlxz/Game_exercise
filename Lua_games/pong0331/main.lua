--[[
    GD50 2018
    Pong Remake
]]

push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

Class = require 'class'

require 'Ball'

require 'Paddle'
--[[
    Runs when the game first starts up, only once; used to initialize the game.
]]
function love.load()
    love.window.setTitle('Pong from xz')
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    smallFont = love.graphics.newFont('font.ttf', 8)
    scoreFont = love.graphics.newFont('font.ttf', 32)

    push:setupScreen(432,243,1280,720,{
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    player1Score = 0
    player2Score = 0

    ball1 = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    -- paddle3 = Paddle(10, 20, 10, 40, "r", "f")
    player1 = Paddle(10, 40, 5, 20, 'w', 's')
    player2 = Paddle(VIRTUAL_WIDTH - 15, VIRTUAL_HEIGHT - 30, 5, 20, 'up', 'down')

    --sounds
    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }

    gameStatus = 'start'
end

--[[
    Called by LÖVE whenever we resize the screen; here, we just want to pass in the
    width and height to push so our virtual resolution can be resized as needed.
]]
function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    --[[paddle movement]]
    player1:update(dt)
    player2:update(dt)
    -- paddle3:update(dt)

    if gameStatus == 'play' then
        --ball movement
        ball1:update(dt)
        --ball collides with paddle
        if ball1:collides(player1) then
            ball1.x = player1.x + player1.width
            ball1:horizontalBounce()
            sounds.paddle_hit:play()
        end
        if ball1:collides(player2) then
            ball1.x = player2.x - ball1.width
            ball1:horizontalBounce()
            sounds.paddle_hit:play()
        end
        --ball collides with top or bottom screen
        if ball1.y <= 0 then
            ball1.y = 0
            ball1:verticalBounce()
            sounds.wall_hit:play()
        end
        if ball1.y + ball1.height >= VIRTUAL_HEIGHT then
            ball1.y = VIRTUAL_HEIGHT - ball1.height
            ball1:verticalBounce()
            sounds.wall_hit:play()
        end
        --score
        if ball1.x + ball1.width <=0 then
            sounds.score:play()
            player2Score = player2Score + 1
            if player2Score > 3 then 
                gameStatus = 'done'
            else
                ball1:reset()
                gameStatus = 'start'
            end
        end
        if ball1.x >= VIRTUAL_WIDTH then
            sounds.score:play()
            player1Score = player1Score + 1
            if player1Score > 3 then
                gameStatus = 'done'
            else
                ball1:reset()
                gameStatus = 'start'
            end
        end
    end

    
end

--[[
    Called after update by LÖVE2D, used to draw anything to the screen, updated or otherwise.
]]
function love.draw()
    push:apply('start')
    --grey background_color
    love.graphics.clear(40, 45, 52, 255)

    if gameStatus == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(scoreFont)
        love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH/2 - 50, VIRTUAL_HEIGHT/3)
        love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH/2 + 30, VIRTUAL_HEIGHT/3)
    elseif gameStatus == 'done' then
        if player1Score == 3 then winningPlayer = 'Player 1' else winningPlayer = 'Player 2' end
        love.graphics.setFont(scoreFont)
        love.graphics.printf('Winner is: ' .. winningPlayer, 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH/2 - 50, VIRTUAL_HEIGHT/3)
        love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH/2 + 30, VIRTUAL_HEIGHT/3)
        love.graphics.setFont(smallFont)
        love.graphics.printf('press "R" to start again', 0, VIRTUAL_HEIGHT - 50, VIRTUAL_WIDTH, 'center')
    elseif gameStatus == 'play' then
    end

    -- paddle
    player1:render()
    player2:render()
    -- paddle3:render()

    --ball
    -- love.graphics.rectangle('fill', ballX, ballY, 4, 4)
    ball1:render()

    
    displayFPS()
    
    push:apply('end')
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif (key == 'enter' or key == 'return') and (gameStatus == 'start') then
        gameStatus = 'play'
    elseif (key == 'enter' or key == 'return') and gameStatus == 'play' then
        gameStatus = 'start'
        ball1:reset()
    elseif gameStatus == 'done' and key == 'r' or key == 'R' then
        gameStatus = 'start'
        ball1:reset()
        player1Score, player2Score = 0,0
    end
end

function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end