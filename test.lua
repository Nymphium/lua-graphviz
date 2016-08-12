local Graph = require'graphviz'

local graph = Graph()
graph:node("a", "hoge")
graph:node("b", "huga")

graph:edge("a", "b")

print(graph:source())

graph:render("test")

