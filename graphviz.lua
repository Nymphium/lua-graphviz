local Graph

local function pcall_wrap(f, ...)
	local ok, cont = pcall(f, ...)

	if not ok then
		error(cont, 2)
	end

	return cont
end

local __Graph = {
	node = function(self, nodename, label)
		table.insert(self.nodes.node, {node =nodename, label = label})
		return self
	end,

	edge = function(self, ...)
		local args = {...}

		for i = 2, #args do
			table.insert(self.edges.edge, {prev = args[1], succ = args[i]})
		end

		return self
	end,

	source = function(self , graphtype , graphname , level)
		graphtype = graphtype or "digraph"
		graphname = graphname or "defaultname"
		level = level or 0
		local src = graphtype .. " " .. graphname .. " {\n" ..
			"\tgraph [" .. self.graph.style:expand() .. "]\n" ..
			"\tnode [" .. self.nodes.style:expand() .. "]\n" ..
			"\tedge [" .. self.edges.style:expand() .. "]\n"

		local node = self.nodes.node
		for i = 1, #node do
			src = src .. ("\t\t%s [label=\"%s\"]\n"):format(node[i].node, node[i].label)
		end

		local subgraphs = self.subgraphs
		for subgraphname , subgraph in pairs(subgraphs) do
			src = src .. ("\n%s\n"):format( subgraph:source("subgraph" , subgraphname , level + 1) )
		end

		local edge = self.edges.edge
		for i = 1, #edge do
			src = src .. ("\t\t\t%s -> %s\n"):format(edge[i].prev, edge[i].succ)
		end

		src = src .. "}"

		--indent
		local function split(str)
			if not str:match("\n$") then
				str = str .. "\n"
			end

			local ret = {}

			for w in str:gmatch("(.-)\n") do
				table.insert(ret, w)
			end

			return ret
		end

		local lines = split(src)
		local indentstr = string.rep("\t\t" , level)
		src = indentstr .. table.concat(lines , "\n" .. indentstr)

		return src
	end,

	subgraph = function(self , subgraphname)
		local subgraph = Graph()
		self.subgraphs[subgraphname] = subgraph
		return subgraph
	end,

	write = function(self, filename)
		local file = pcall_wrap(io.open, filename, "w+")
		file:write(self:source())
		pcall_wrap(io.close, file)
		return self
	end,

	compile = function(self, filename, format, generate_filename)
		format = format or "pdf"

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

		self:write(filename)

		generate_filename = generate_filename or ("%s.%s"):format(filename, format)

		-- compile dot file
		local cmd_str = ("dot -T%s %s -o %s"):format(
			format --[[output format]],
			filename --[[input dot file]],
			generate_filename --[[output file]])

		local cmd = io.popen(cmd_str, "r")

		pcall_wrap(cmd.read, cmd, "*a")
		pcall_wrap(io.close, cmd)

		return self
	end,

	render = function(self, filename, format, generate_filename)
		format = format or "pdf"
		generate_filename = generate_filename or ("%s.%s"):format(filename, format)
		self:compile(filename, format, generate_filename)

		-- open generated file with `xdg-open`
		local cmd_str = ("xdg-open %s &"):format(generate_filename)

		local cmd = io.popen(cmd_str, "r")

		pcall_wrap(cmd.read, cmd, "*a")
		pcall_wrap(io.close, cmd)

		return self
	end,
}

local style_index = {
	update = function(orig_style, styles)
		for k, v in pairs(styles) do
			orig_style[k] = v
		end
	end,

	expand = function(tbl)
		local style_str = ""

		for k, v in pairs(tbl) do
			if k == "fontname" then
				v = ([["%s"]]):format(v)
			end
			style_str = style_str .. (" %s=%s"):format(k, v)
		end

		return style_str:gsub("^ ", "")
	end
}

-- pseudo Graph class
Graph = function()
	return setmetatable({
		edges = {
			 edge = {},
			 style = setmetatable({}, {__index = style_index})},
		nodes = {
			node = {},
			style = setmetatable({}, {__index = style_index})},
		graph = {
			style = setmetatable({}, {__index = style_index})},
		subgraphs = {} ,
	}, {__index = __Graph})
end

return Graph

