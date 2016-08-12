package = "v1"
version = "0-1"
source = {
   url = "git://github.com/nymphium/lua-graphviz"
}
description = {
   summary = "## usage```lualocal Graphviz = require(\"graphviz\")",
   detailed = [[
## usage
```lua
local Graphviz = require("graphviz")]],
   homepage = "https://github.com/nymphium/lua-graphviz",
   license = "MIT"
}
dependencies = {}
build = {
   type = "builtin",
   modules = {
      graphviz = "graphviz.lua"
   }
}
