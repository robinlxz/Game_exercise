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

-- function Ball:collides(paddle)
--   -- x is the position of the left boarder for any object
--   if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
--     return false
--   end

--   -- y is the position of the top boarder for any object (in love2d, y axis is point to downwards)
--   if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
--     return false
--   end

--   return true
-- end

function Ball:collides(paddle)
  -- first, check to see if the left edge of either is farther to the right
  -- than the right edge of the other
  if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
      return false
  end

  -- then check to see if the bottom edge of either is higher than the top
  -- edge of the other
  if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
      return false
  end 

  -- if the above aren't true, they're overlapping
  return true
end