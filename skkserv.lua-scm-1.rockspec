package = "SkkServ.lua"
version = "scm-1"
source = {
   url = "git+https://github.com/akimichi/SkkServ.lua.git"
}
description = {
   homepage = "https://github.com/akimichi/SkkServ.lua",
   license = "MIT"
}
dependencies = {
   "lua >= 5.1, <= 5.3",
   "busted >= 2.0.rc12",
   "json-lua >= 0.1"
}
build = {
   type = "builtin",
   modules = {}
}
