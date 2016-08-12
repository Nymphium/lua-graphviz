Lua-Graphviz
===

[Graphviz](http://www.graphviz.org/) for [Lua](https://lua.org)

## usage
```lua
local Graphviz = require("graphviz")

local graph = Graphviz()
```
## function
### `graph:node(nodename, label)`
add a node

### `graph:edge(...)`
add a edges

```
args[1] -> args[2]
args[1] -> args[3]
...
args[1] -> args[n]
```

### `graph:source()`
return graph as string

```
digraph {
	graph []
	node[]
	edge[]
		a [label="hoge"]
		b [label="huga"]
			a -> b
}
```

### `graph:render(filename, format)`
write dot file to (`filename`), and compile the dot file as `format`

```lua
graph:render("file", "pdf")
```

### `graph.nodes.style:update(styles)`, `graph.edges.style:update(styles`, `graph.graph.style:update(styles)`

update each style

```lua
graph.nodes.style:update{
	fontname = "Inconsolata Regular",
	shape = "rectangle"
}
```

## LICENSE
[MIT](https://github.com/nymphium/lua-graphviz/tree/master/LICENSE)

