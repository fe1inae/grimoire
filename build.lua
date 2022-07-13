-- IMPORTS
-- =======

local lfs  = require("lfs")

-- RECURSE
-- =======

function build(in_dir, out_dir, tl, path, depth)

	-- set defaults for init
	if not path  then path  = in_dir end
	if not depth then depth = 1      end
	
	-- make current path dir
	local tmp = "."
	for p in path:gsub("^" .. in_dir, out_dir):gmatch("[^/\\]+")
	do
		tmp = tmp .. "/" .. p
		lfs.mkdir(tmp)
	end
	
	-- loop over files in path
	for file in assert(lfs.dir(path))
	do
		-- ignore "virtual?" files
		if file ~= "." and file ~= ".."
		then
			-- merge paths
			local f = path .. "/" .. file 
			
			-- transform to output directory
			local o = f:gsub("^" .. in_dir, out_dir)
		
			-- check if file is a directory
			if assert(lfs.attributes(f)).mode == "directory"
			then
				-- recurse if so
				build(in_dir, out_dir, tl, f, depth + 1)
			else
				-- convert or copy
				if f:match("%.lua$")
				then
					-- convert in current func table
					tl.convert(f, o, depth)
				else
					-- raw copy
					local fhandle = assert(io.open(f, "rb"))
					local ohandle = assert(io.open(o, "wb"))
					ohandle:write(fhandle:read("*a"))
					ohandle:close()
					fhandle:close()
				end
			end
		end
	end
end

-- CALL
-- ====

local html = require("lib/html")
build("src", "out/html", html)
