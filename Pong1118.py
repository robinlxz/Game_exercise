import turtle
import os
from random import randint

WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600

wn = turtle.Screen()
wn.title("Pong by xz")
wn.bgcolor("black")
wn.setup(width=WINDOW_WIDTH, height=WINDOW_HEIGHT)
wn.tracer(0)

# Paddle A
paddle_a = turtle.Turtle()
paddle_a.speed(0)
paddle_a.shape("square")
paddle_a.color("blue")
paddle_a.shapesize(stretch_wid=5, stretch_len=1)
paddle_a.penup()
paddle_a.goto(-(7/16*WINDOW_WIDTH), 0)

paddle_b_extend_times = 5
# Right paddle change to noraml
def paddle_b_normalize():
  paddle_b_extend_times = 5
  paddle_b.shapesize(stretch_wid=paddle_b_extend_times, stretch_len=1)
  

# Paddle B
paddle_b = turtle.Turtle()
paddle_b.speed(0)
paddle_b.shape("square")
paddle_b.color("red")
paddle_b.shapesize(stretch_wid=paddle_b_extend_times, stretch_len=1)
paddle_b.penup()
paddle_b.goto(7/16*WINDOW_WIDTH, 0)

# Ball
ball = turtle.Turtle()
ball.speed(0)
ball.shape("square")
ball.color("white")
ball.penup()
ball.goto(0,0)
ball.dx = 2
ball.dy = 2

# Pen
pen = turtle.Turtle()
pen.speed(0)
pen.color("white")
pen.penup()
pen.hideturtle()
pen.goto(0, 26/60*WINDOW_HEIGHT)
pen.write("Player Left: 0, Player Right: 0", align="center", font=("Courier", 24, "normal"))

# Score
score_a = 0
score_b = 0

# Function
def paddle_a_up():
  y = paddle_a.ycor()
  y += 1/20*WINDOW_HEIGHT
  paddle_a.sety(y)

def paddle_a_down():
  y = paddle_a.ycor()
  y -= 1/20*WINDOW_HEIGHT
  paddle_a.sety(y)

def paddle_b_up():
  y = paddle_b.ycor()
  y += 1/20*WINDOW_HEIGHT
  paddle_b.sety(y)

def paddle_b_down():
  y = paddle_b.ycor()
  y -= 1/20*WINDOW_HEIGHT
  paddle_b.sety(y)


# Keyboard binding
wn.listen()
wn.onkeypress(paddle_a_up, "w")
wn.onkeypress(paddle_a_down, "s")
wn.onkeypress(paddle_b_up, "Up")
wn.onkeypress(paddle_b_down, "Down")

# Main game loop
while True:
  wn.update()

  # Move the ball
  ball.setx(ball.xcor() + ball.dx)
  ball.sety(ball.ycor() + ball.dy)

  # Boarder checking
  if abs(ball.ycor()) > WINDOW_HEIGHT/2 - 10:
    # ball.sety(290)
    ball.dy *= -1

  #Left player goal
  if ball.xcor() > WINDOW_WIDTH/2 - 10:
    ball.goto(0,0)
    ball.dx *= -1
    ball.dy = 2+randint(0,10)/6
    score_a += 1
    os.system("afplay boom.wav")
    pen.clear()
    pen.write("Player Left: {}, Player Right: {}".format(score_a,score_b), align="center", font=("Courier", 24, "normal"))
    #Right paddle change to noraml
    paddle_b_normalize()
    

  #Right player goal
  if ball.xcor() < -(WINDOW_WIDTH/2 - 10):
    ball.goto(0,0)
    ball.dx *= -1
    ball.dy = 2+randint(0,10)/6
    score_b += 1
    os.system("afplay boom.wav")
    pen.clear()
    pen.write("Player Left: {}, Player Right: {}".format(score_a,score_b), align="center", font=("Courier", 24, "normal"))
    paddle_b_normalize()
  
  if abs(ball.xcor() - paddle_a.xcor())<20 and abs(ball.ycor() - paddle_a.ycor())<50:
      ball.setx(-(7/16*WINDOW_WIDTH-20))
      ball.dx *= -1

  if abs(ball.xcor() - paddle_b.xcor())<20 and abs(ball.ycor() - paddle_b.ycor())<paddle_b_extend_times*10:
      ball.setx(7/16*WINDOW_WIDTH-20)
      # os.system("afplay boom.wav&")
      ball.dx *= -1.2
      paddle_b_extend_times *= 0.9
      paddle_b.shapesize(stretch_wid=paddle_b_extend_times, stretch_len=1)