import dom, strutils, canvas, random, sequtils

echo "Langton's Ant(s). [Nim version]"

const WIDTH = 640
const HEIGHT = 480
const CELLSIZE = 4
const COLUMNS : int = toInt(WIDTH / CELLSIZE)
const ROWS : int = toInt(HEIGHT / CELLSIZE)

randomize()

type
  World = array[COLUMNS, array[ROWS, bool]]
  Direction = enum
    left = 1, bottom = 2, right = 3, top = 4
  Ant* = ref object of RootObj
    x : int
    y : int
    direction : Direction

proc drawAnt(ctx: CanvasContext2d, ant : Ant) =
    ctx.beginPath()
    ctx.fillStyle(255, 0, 0)
    ctx.fillRect(ant.x * CELLSIZE, ant.y * CELLSIZE, CELLSIZE, CELLSIZE)
    ctx.closePath()

proc moveForward(ant: Ant) : Ant =
    result =
      case ant.direction
        of Direction.left:
          if ant.x > 0:
            Ant(x: ant.x - 1, y: ant.y, direction: ant.direction)
          else:
            Ant(x: ant.x, y: ant.y, direction: Direction.right)
        of Direction.bottom:
          if ant.y < COLUMNS - 2:
            Ant(x: ant.x, y: ant.y + 1, direction: ant.direction)
          else:
            Ant(x: ant.x, y: ant.y, direction: Direction.top)
        of Direction.right:
          if ant.x < ROWS - 2:
            Ant(x: ant.x + 1, y: ant.y, direction: ant.direction)
          else:
            Ant(x: ant.x, y: ant.y, direction: Direction.left)
        of Direction.top:
          if ant.y > 0:
            Ant(x: ant.x, y: ant.y - 1, direction: ant.direction)
          else:
            Ant(x: ant.x, y: ant.y, direction: Direction.bottom)

var states : World
for col in 0..<COLUMNS:
    for row in 0..<ROWS:
        states[col][row] = false

proc turnRight(ant : Ant) : Ant  =
    let direction =
      if ant.direction > Direction.left:
        Direction(ord(ant.direction) - 1)
      else:
        Direction.top
    result = Ant(x: ant.x, y: ant.y, direction: direction)


proc turnLeft(ant : Ant) : Ant =
    let direction =
      if ant.direction < Direction.top:
        Direction(ord(ant.direction) + 1)
      else:
        Direction.left
    result = Ant(x: ant.x, y: ant.y, direction: direction)

proc moveAnt*(ant: Ant) : Ant =
    let x = ant.x
    let y = ant.y
    #echo "ant is at $1, $2" % [intToStr(ant.x), intToStr(ant.y)]
    let white_cell = states[x][y]
    if white_cell==false: states[x][y]=true else: states[x][y]=false
    let new_ant =
      if white_cell:
        turnRight(ant)
      else:
        turnLeft(ant)
    result = new_ant

proc drawWorld(ctx: CanvasContext2d) =
    for j in 0..<ROWS:
      for i in 0..<COLUMNS:
        if states[i][j]==true:
          ctx.beginPath()
          ctx.fillStyle(0,0,0)
          ctx.fillRect(i * CELLSIZE, j * CELLSIZE, CELLSIZE, CELLSIZE)
          ctx.closePath()

dom.window.onload = proc (e: dom.Event) =
  let c = dom.document.getElementById("ants").Canvas
  let ctx = c.getContext2d()
  echo "Canvas is $1 (px) by $2 (px)." % [intToStr(WIDTH), intToStr(HEIGHT)]
  echo "Canvas is $1 (columns) by $2. (rows)" % [intToStr(COLUMNS), intToStr(ROWS)]

  var ants = @[Ant(x: toInt(COLUMNS / 2), y: toInt(ROWS / 2), direction: Direction.left)]

  proc draw() =
    ctx.clearRect(0, 0, WIDTH, HEIGHT)

    drawWorld(ctx)
    for ant in ants:
      drawAnt(ctx, ant)
    ants = ants.mapIt(moveForward(it)).mapIt(moveAnt(it))
    requestAnimationFrame(draw)

  proc onkeydown(evt: dom.Event) =
    ants.add(Ant(x: random(COLUMNS-1), y: random(ROWS-1), direction: Direction.right))

  let button = dom.document.getElementById("addAntButton")
  button.addEventListener("click", onkeydown, false)

  draw()
