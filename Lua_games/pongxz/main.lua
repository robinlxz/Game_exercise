--[[
  Exercise based on learning CS50
]]

-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
--
-- https://github.com/Ulydev/push
push = require 'push'

WINDOW_WIDTH = 1080
WINDOW_HEIGHT = 640

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

-- OOP
Class = require 'class'
require 'Paddle'
require 'Ball'

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  math.randomseed(os.time())

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = false,
    vsync = true
  })

  paddleX = Paddle(VIRTUAL_WIDTH/2-15, VIRTUAL_HEIGHT-10, 30, 5)
  paddleY = Paddle(VIRTUAL_WIDTH/2-25, VIRTUAL_HEIGHT-200, 20, 5)

  ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

  gameState = 'start'

  -- setup sound effects
  sound = {
    ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav','static'),
    ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
    ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
  }
end



function love.update(dt)
  -- collision
  -- Question: why error when if ball:c(X) or ball:c(Y)? Error: Ball.lua:46: attempt to index local 'paddle' (a nil value)
  if ball:collides(paddleX) then
    if ball.y + ball.height > paddleX.y then
      ball.y = paddleX.y - ball.height
    end
    ball.dy = -ball.dy*1.04
    -- add random for paddleX
    ball.dx = ball.dx + math.random(-10,10)

    sound['paddle_hit']:play()

    -- paddleX.release()
  end

  if ball:collides(paddleY) then
    ball.y = paddleY.y + paddleY.height
    ball.dy = -ball.dy*1.04
    -- add more random for paddleY
    ball.dx = ball.dx + math.random(-40,40)

    sound['paddle_hit']:play()
  end

  -- bounce the left and right wall
  if ball.x <= 0 then
    ball.x = 0
    ball.dx = -ball.dx
    sound['wall_hit']:play()
  elseif ball.x + ball.width >= VIRTUAL_WIDTH then
    ball.x = VIRTUAL_WIDTH - ball.width
    ball.dx = -ball.dx
    sound['wall_hit']:play()
  end

  -- bounce the top wall for brick knock game #brick-knock
  -- if ball.y <=0 then
  --   ball.y =0
  --   ball.dy = -ball.dy
  --   sound['wall_hit']:play()
  -- end

  if love.keyboard.isDown('left') then
    -- paddleX = paddleX + -PADDLE_SPEED * dt
    paddleX.dx = -PADDLE_SPEED
  elseif love.keyboard.isDown('right') then
    -- paddleX = paddleX + PADDLE_SPEED * dt
    paddleX.dx = PADDLE_SPEED
  else
    paddleX.dx = 0
  end

  if love.keyboard.isDown('a') then
    paddleY.dx = -PADDLE_SPEED
  elseif love.keyboard.isDown('d') then
    -- paddleX = paddleX + PADDLE_SPEED * dt
    paddleY.dx = PADDLE_SPEED
  else
    paddleY.dx = 0
  end

  if gameState == 'play' then
    ball:update(dt)
  end

  paddleX:update(dt)
  paddleY:update(dt)


end


function love.keypressed(key)
  -- quit game
  if key == 'escape' then
    love.event.quit()
  elseif key == 'enter' or key == 'return' then
    if gameState == 'start' then
      gameState = 'play'
    else
      gameState = 'start'
      ball:reset()
    end
  end
end

function love.draw()
  push:apply('start')
  -- background color
  love.graphics.clear(160/255, 80/255, 0/255, 255/255)

  -- game title
  love.graphics.setFont(love.graphics.newFont(16))
  love.graphics.printf('Bricks!', 0, 20, VIRTUAL_WIDTH, 'center')

  paddleX:render()
  paddleY:render()
  ball:render()

  displayFPS()

  push:apply('end')
end

function displayFPS()
  love.graphics.setFont(love.graphics.newFont(8))
  love.graphics.setColor(0,255,0,255)
  love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end