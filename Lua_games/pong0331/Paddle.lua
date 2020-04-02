Paddle = Class{}

function Paddle:init(x, y, width, height, upKey, downKey)
  self.x = x
  self.y = y
  self.width = width
  self.height = height

  self.speed = 200
  self.upKey = upKey
  self.downKey = downKey
end

function Paddle:update(dt)
  if (love.keyboard.isDown(self.upKey) and self.y > 0) then
    self.y = self.y + -PADDLE_SPEED * dt 
  end
  if (love.keyboard.isDown(self.downKey) and self.y < VIRTUAL_HEIGHT - 20) then
    self.y = self.y + PADDLE_SPEED * dt 
  end
end

function Paddle:render()
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end