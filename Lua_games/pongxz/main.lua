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

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = false,
    vsync = true
  })

  -- paddleX = VIRTUAL_WIDTH/2-15
  paddleX = Paddle(VIRTUAL_WIDTH/2-15, VIRTUAL_HEIGHT-10, 30, 5)
  paddleY = Paddle(VIRTUAL_WIDTH/2-25, VIRTUAL_HEIGHT-200, 20, 5)
end



function love.update(dt)
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

  paddleX:update(dt)
  paddleY:update(dt)

end


function love.keypressed(key)
  -- quit game
  if key == 'escape' then
    love.event.quit()
  end
end

function love.draw()
  push:apply('start')
  -- background color
  love.graphics.clear(160/255, 80/255, 0/255, 255/255)

  -- game title
  love.graphics.printf('Bricks!', 0, 20, VIRTUAL_WIDTH, 'center')

  -- paddle
  -- love.graphics.rectangle('fill', paddleX, VIRTUAL_HEIGHT-10, 30, 5)
  paddleX:render()
  paddleY:render()

  -- ball
  love.graphics.rectangle('fill', VIRTUAL_WIDTH/2-2, VIRTUAL_HEIGHT/2-2, 4, 4)

  push:apply('end')
end