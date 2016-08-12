local function style_expand(tbl)
	local style_str = ""

	for k, v in pairs(tbl) do
		style_str = style_str .. " " .. k .. "=" .. v
	end

	return style_str
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
		local src = "digraph " .. "{\n" ..
			"\tgraph [" .. (self.graph.style and style_expand(self.graph.style) or "") .. "]\n" ..
			"\tnode[" .. (self.nodes.style and style_expand(self.nodes.style) or "") .. "]\n" ..
			"\tedge[" ..  "]\n"

		node_style = self.nodes.style
		self.nodes.style = nil

		for k, v in pairs(self.nodes.node) do
			src = src .. "\t\t".. k .. " [label=\"" .. v .. "\"]\n"
		end

		self.nodes.style = node_style

		edge_style = self.edges.style
		self.edges.style = nil
		
		edge = self.edges.edge

		-- print((require'inspect')(edge[1]))

		for i = 1, #edge do
			src = src .. "\t\t\t" .. edge[i].from .. " -> " .. edge[i].to .. "\n"
		end

		self.edges.style = edge

		return src .. "}"
	end,
	render = function(self, filename)
		local file = assert(io.open(filename, "a+"))

		-- print(require'inspect'(self))
		file:write(self:source())
		assert(file:close())
	end,
}

local Graph = function()
	return setmetatable({nodes = {node = {}}, graph = {},  edges = {edge = {}}}, {__index = __Graph})
end

return Graph

