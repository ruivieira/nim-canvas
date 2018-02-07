# Package

version       = "0.0.2"
author        = "Rui Vieira"
description   = "Nim HTML5 canvas module"
license       = "GPL3"

# Dependencies

requires "nim >= 0.14.3"

bin = @["canvas"]
backend = "js"

task examples, "Build the examples":
  exec "nim js -d:nodejs -d:release -o:examples/ants.js examples/ants.nim"
