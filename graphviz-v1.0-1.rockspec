package = "graphviz"
version = "v1.0-2"
source = {
	url = "git://github.com/nymphium/lua-graphviz"
}
description = {
	homepage = "http://github.com/nymphium/lua-graphviz",
	license = "MIT"
}
dependencies = {}
build = {
	type = "builtin",
	modules = {
		["graphviz"] = "graphviz.lua"
	}
}
