package = "graphviz"
version = "v1.0-1"
source = {
	url = "git://github.com/nymphium/lua-graphviz",
	tag = "vv1.0"
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
