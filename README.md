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
