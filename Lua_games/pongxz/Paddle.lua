

Paddle = Class{}

function Paddle:init(x, y, width, height)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.dx = 0
end

function Paddle:update(dt)
  if self.dx < 0 then
    self.x = math.max(0, self.x + (self.dx * dt))
  elseif self.dx > 0 then
    self.x = math.min(self.x + (self.dx * dt), VIRTUAL_WIDTH - self.width)
  end
end

function Paddle:render()
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end