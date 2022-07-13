-- HELPER FUNCTIONS
-- ================

local function accum(start, stop, sep, v)
	if not start then start = "" end
	if not stop  then stop  = "" end
	if not sep   then sep   = "" end
	if type(v) == "string" then return(start .. v .. stop) end
	
	local s = start
	for n, i in ipairs(v)
	do
		if n > 1 
		then
			s = s .. sep
		end
		s = s .. i
	end
	return s .. stop
end

-- COMPISITION FUNCTIONS
-- =====================

local unpack = _G.unpack or table.unpack

-- document
function document(v)
	-- OUTPUT is a hack so the in document formatting doesnt have to return :)
	OUTPUT = ""
	
	OUTPUT = OUTPUT .. [[<!DOCTYPE html>
<html lang="en">
<meta charset="utf-8">
<link rel="stylesheet" href="]] .. DEPTH .. [[css/style.css">
<link rel="icon" type="image/x-icon" href="]] .. DEPTH .. [[pic/favicon.ico">
<title>]] .. title .. [[</title>
</head>
]]
	
	OUTPUT = OUTPUT .. accum("<body>\n", "</body>", "\n", v)
	OUTPUT = OUTPUT .. "\n</html>"
end

-- headers
function h1(v) return(accum("<h1>", "</h1>", " ", v)) end
function h2(v) return(accum("<h2>", "</h2>", " ", v)) end
function h3(v) return(accum("<h3>", "</h3>", " ", v)) end

-- links
function url(lnk, v) 
	if lnk:match("^/") then lnk = DEPTH:gsub("/$", "") .. lnk end
	if not v then v = lnk end
	return('<a href="' .. lnk .. '" class="url">' .. accum(nil, nil, " ", v) .. "</a>")
end

function ref(lnk, v)
	if lnk:match("^/") then lnk = DEPTH:gsub("/$", "") .. lnk end
	if not v then v = lnk end
	return('<a href="' .. lnk .. '" class="ref">' .. accum(nil, nil, " ", v)  .. "</a>")
end

function embed(lnk, alt, w, h)
	if lnk:match("^/") then lnk = DEPTH:gsub("/$", "") .. lnk end
	local s = '<img src="' .. lnk .. '" alt="' .. alt .. '"'
	if w then s = s .. ' width="'  .. w .. '"' end
	if h then s = s .. ' height="' .. h .. '"' end
	return(s .. ">")
end

-- misc inline formatting
function bold(v)   return(accum("<b>",   "</b>",   " ", v)) end
function italic(v) return(accum("<i>",   "</i>",   " ", v)) end
function under(v)  return(accum("<u>",   "</u>",   " ", v)) end
function strike(v) return(accum("<del>", "</del>", " ", v)) end

-- paragraph
function p(v) return(accum("<p>", "</p>", " ", v):gsub("[\t\n]", "") .. "\n") end

-- preformatted
function code(v) return(accum("<pre>", "</pre>", " ", v) .. "\n") end

-- tree of bullets
function tree(v)
	if type(v) == "string" then return("<ul><li>".. v .. "</li></ul>\n") end
	
	local s = "<ul>\n"
	for _, i in ipairs(v)
	do
		if type(i) == "table"
		then
			s = s .. tree(i)
		else
			s = s .. "<li>" .. i .. "</li>\n"
		end
	end
	
	return s .. "</ul>"
end

-- description list
function describe(v)
	local s = "<dl>\n"
	for n, i in ipairs(v)
	do
		if type(i[2]) == "table"
		then
			s = s .. "<dt>".. i[1] .. "</dt>\n<dd>" .. desc({i[2]}) .. "</dd>\n"
		else
			s = s .. "<dt>".. i[1] .. "</dt>\n<dd>" .. i[2] .. "</dd>\n"
		end
	end
	
	return s .. "</dl>"
end

-- numbered list
function list(v)
	if type(v) == "string" then return("<ol><li>".. v .. "</li></ol>\n") end
	
	local s = "<ol>\n"
	for n, i in ipairs(v)
	do
		if type(i) == "table"
		then
			s = s .. tree(i)
		else
			s = s .. "<li>" .. i .. "</li>\n"
		end
	end
	
	return s .. "</ol>"
end

-- generic 2d table
function table(v)
	if type(v) == "string" then return("<table><tr><td>".. v .. "</td></tr></table>\n") end

    local s = "<table>\n"
	for nr, r in ipairs(v)
	do
		s = s .. "<tr>\n"
		for ni, i in ipairs(r)
		do
			if nr == 1
			then
				s = s .. "<th>" .. i .. "</th>\n"
			else
				s = s .. "<td>" .. i .. "</td>\n"
			end
		end
		s = s .. "</tr>\n"
	end

	return(s .. "</table>")
end

-- table with function mapping
function calc(f, v)
	if type(v) == "string" then return("<table><tr><td>".. v .. "</td></tr></table>") end

    local s = "<table>\n"
	for nr, r in ipairs(v)
	do
		if nr > 1 then
			r = f(r)
		end
		s = s .. "<tr>\n"
		for ni, i in ipairs(r)
		do
			if nr == 1 then
				s = s .. "<th>" .. i .. "</th>\n"
			else
				s = s .. "<td>" .. i .. "</td>\n"
			end
		end
		s = s .. "</tr>\n"
	end

	return(s .. "</table>")
end

-- RETURN
-- ======

local M = {}

function M.convert(f, o, d)
	o = o:gsub("%.lua", ".html");
	local ohandle = io.open(o, "w")
	
	-- build the depth path
	if d > 1
	then
		DEPTH = ""
		for i = 2, d
		do
			DEPTH = DEPTH .. "../"
		end
	else
		DEPTH = "./"
	end
	
	assert(loadfile(f, "t"))()
	ohandle:write(OUTPUT)
	ohandle:close()
end

return M
