-- IMPORTS
-- =======

local lfs  = require("lfs")

-- UTILITIES
-- =========

local html = require("lib/html")

-- VARIABLES
-- =========

local INPUT  = "src"
local OUTPUT = "www"

-- RECURSE
-- =======

function build(path, d)
	if not d then d = 1 end
	lfs.mkdir(path:gsub("^" .. INPUT, OUTPUT))
	for file in lfs.dir(path)
	do
		if file ~= "." and file ~= ".."
		then
			local f = path .. "/" .. file
			local o = f:gsub("^" .. INPUT, OUTPUT)
			
			if assert(lfs.attributes(f)).mode == "directory"
			then
				build(f, d + 1)
			else
				-- convert or copy
				if f:match("%.lua$")
				then
					html.convert(f, o, d)
				else
					-- raw copy
					local ohandle = assert(io.open(o, "w"))
					local fhandle = assert(io.open(f, "r"))
					ohandle:write(fhandle:read("*a"))
					ohandle:close()
					fhandle:close()
				end
			end
		end
	end
end

build(INPUT)
