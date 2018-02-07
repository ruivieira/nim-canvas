import dom

type
  Canvas* = ref CanvasObj
  CanvasObj {.importc.} = object of dom.Element

  CanvasContext2d* = ref CanvasContext2dObj
  CanvasContext2dObj {.importc.} = object
    font*: cstring

proc getContext2d*(c: Canvas): CanvasContext2d =
  {.emit: "`result` = `c`.getContext('2d');".}

proc width*(c: Canvas): int =
  {.emit: "`result` = `c`.width;".}

proc height*(c: Canvas): int =
  {.emit: "`result` = `c`.height;".}

proc fillStyle*(ctx: CanvasContext2d, value: string) =
  {.emit: "`ctx`.fillStyle = '`value`';".}

proc fillStyle*(ctx: CanvasContext2d, r, g, b: int) =
  {.emit: "`ctx`.fillStyle = 'rgb(`r`,`g`,`b`)';".}

proc fillStyle*(ctx: CanvasContext2d, r, g, b: float) =
  {.emit: "`ctx`.fillStyle = 'rgb(`r`,`g`,`b`)';".}

proc strokeStyle*(ctx: CanvasContext2d, value: string) =
  {.emit: "`ctx`.strokeStyle = '`value`';".}

proc strokeStyle*(ctx: CanvasContext2d, r, g, b: int) =
  {.emit: "`ctx`.strokeStyle = 'rgb(`r`,`g`,`b`)';".}

proc strokeStyle*(ctx: CanvasContext2d, r, g, b: float) =
  {.emit: "`ctx`.strokeStyle = 'rgb(`r`,`g`,`b`)';".}
  
proc requestAnimationFrame*(op: proc) =
  {.emit: "`ran` = window.requestAnimationFrame || window.mozRequestAnimationFrame || window.webkitRequestAnimationFrame || window.msRequestAnimationFrame; `ran`(`op`);".}


proc beginPath*(c: CanvasContext2d) {.importcpp.}
proc stroke*(c: CanvasContext2d) {.importcpp.}
proc strokeText*(c: CanvasContext2d, txt: cstring, x, y: float) {.importcpp.}
proc clearRect*(c: CanvasContext2d, x, y, w, h: float) {.importcpp.}
proc fillRect*(ctx: CanvasContext2d, x, y, w, h: float) {.importcpp.}
proc fillRect*(ctx: CanvasContext2d, x, y, w, h: int) {.importcpp.}
proc closePath*(ctx: CanvasContext2d) {.importcpp.}
