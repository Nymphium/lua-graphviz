local function style_expand(tbl)
	local style_str = ""

	for k, v in pairs(tbl) do
		if k == "fontname" then
			v = ([["%s"]]):format(v)
		end
		style_str = style_str .. (" %s=%s"):format(k, v)
	end

	return style_str:gsub("^ ", "")
end

local __Graph = {
	node = function(self,nodename, label)
		self.nodes.node[nodename] = label
	end,

	edge = function(self, ...)
		local args = {...}

		for i = 2, #args do
			table.insert(self.edges.edge, {from = args[1], to = args[i]})
		end
	end,

	source = function(self)
		local src = "digraph {\n" ..
			"\tgraph [" .. style_expand(self.graph.style) .. "]\n" ..
			"\tnode [" .. style_expand(self.nodes.style) .. "]\n" ..
			"\tedge [" .. style_expand(self.edges.style) .. "]\n"

		node_style = self.nodes.style
		self.nodes.style = nil

		for k, v in pairs(self.nodes.node) do
			src = src .. ("\t\t%s [label=\"%s\"]\n"):format(k, v)
		end

		self.nodes.style = node_style

		edge_style = self.edges.style
		self.edges.style = nil

		edge = self.edges.edge

		for i = 1, #edge do
			src = src .. ("\t\t\t%s -> %s\n"):format(edge[i].from, edge[i].to)
		end

		self.edges.style = edge_style

		return src .. "}"
	end,

	render = function(self, filename, format)
		local file = assert(io.open(filename, "w+"))
		format = format or "pdf"

		file:write(self:source())
		assert(file:close())

		if not (
			format:match("^ps$") or
			format:match("^svg$") or
			format:match("^fig$") or
			format:match("^png$") or
			format:match("^imap$") or
			format:match("^cmapx$") or
			format:match("^pdf$")) then

			error("Graphviz supports the following output formats: ps, svg, fig, png, imap, and cmapx")
		end

		local cmd_str = ("dot -T%s %s -o %s.%s"):format(
			format --[[output format]],
			filename --[[input dot file]],
			filename, format --[[output file name(`filename.format`]])

		local cmd = io.popen(cmd_str, "r")

		assert(cmd:read("*a"))
		cmd:close()
	end,
}

local update = function(orig_style, styles)
	for k, v in pairs(styles) do
		orig_style[k] = v
	end
end

-- pseudo Graph class
local Graph = function()
	return setmetatable({
		 edges = {
			 edge = {},
			 style = setmetatable({}, {__index = {update = update}})},
		nodes = {
			node = {},
			style = setmetatable({}, {__index = {update = update}})},
		graph = {
			style = setmetatable({}, {__index = {update = update}})},
	}, {__index = __Graph})
end

return Graph

