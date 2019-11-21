Ball = Class{}

function Ball:init(x, y, width, height)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.dx = math.random(-50,50)
  self.dy = math.random(60,80)
end

-- reset function for game enter start state
function Ball:reset()
  self.x = VIRTUAL_WIDTH / 2 - 2
  self.y = VIRTUAL_HEIGHT / 2 - 2
  self.dx = math.random(-50,50)
  self.dy = math.random(60,80)
end

function Ball:update(dt)
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt
end

function Ball:render()
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end