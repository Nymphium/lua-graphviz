local Graph = require'graphviz'

local graph = Graph()

graph.nodes.style:update{
	fontname = "Inconsolata Regular",
	shape = "rectangle"
}

graph:node("a", "hoge")
graph:node("b", "huga")

graph:edge("a", "b")

print(graph:source())

graph:render("test")

