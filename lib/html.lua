local M = {} -- module functions
local T = {} -- temp values

-- HELPER FUNCTIONS
-- ================

function M.accum(start, stop, sep, v)
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

unpack = _G.unpack or table.unpack

-- document
function M.document(v)
	T.output = ""
	
	if not T.title then T.title = "ulthar.cat" end
	
	T.output = T.output .. [[<!DOCTYPE html>
<html lang="en">
<meta charset="utf-8">
<link rel="stylesheet" href="]] .. T.depth .. [[css/style.css">
<link rel="icon" type="image/x-icon" href="]] .. T.depth .. [[pic/favicon.ico">
<title>]] .. T.title .. [[</title>
</head>
]]
	
	T.output = T.output .. M.accum("<body>\n", "</body>", "\n", v)
	T.output = T.output .. "\n</html>"
end

-- headers
function M.h1(v) return(M.accum("<h1>", "</h1>", " ", v)) end
function M.h2(v) return(M.accum("<h2>", "</h2>", " ", v)) end
function M.h3(v) return(M.accum("<h3>", "</h3>", " ", v)) end
function M.title(v)
	T.title = v
	return M.h1(v)
end
	


-- links
function M.url(lnk, v) 
	if lnk:match("^/") then lnk = T.depth:gsub("/$", "") .. lnk end
	if not v then v = lnk end
	return('<a href="' .. lnk .. '" class="url">' .. M.accum(nil, nil, " ", v) .. "</a>")
end

function M.ref(lnk, v)
	if lnk:match("^/") then lnk = T.depth:gsub("/$", "") .. lnk end
	if not v then v = lnk end
	return('<a href="' .. lnk .. '" class="ref">' .. M.accum(nil, nil, " ", v)  .. "</a>")
end

function M.embed(lnk, alt, w, h)
	if lnk:match("^/") then lnk = T.depth:gsub("/$", "") .. lnk end
	local s = '<img src="' .. lnk .. '" alt="' .. alt .. '"'
	if w then s = s .. ' width="'  .. w .. '"' end
	if h then s = s .. ' height="' .. h .. '"' end
	return(s .. ">")
end

-- misc inline formatting
function M.bold(v)   return(M.accum("<b>",   "</b>",   " ", v)) end
function M.italic(v) return(M.accum("<i>",   "</i>",   " ", v)) end
function M.under(v)  return(M.accum("<u>",   "</u>",   " ", v)) end
function M.strike(v) return(M.accum("<del>", "</del>", " ", v)) end

-- paragraph
function M.p(v) return(M.accum("<p>", "</p>", " ", v):gsub("[\t\n]", "")) end

-- preformatted
function M.code(v) return(M.accum("<pre>", "</pre>", " ", v) .. "\n") end

-- tree of bullets
function M.tree(v)
	if type(v) == "string" then return("<ul><li>".. v .. "</li></ul>\n") end
	
	local s = "<ul>\n"
	for _, i in ipairs(v)
	do
		if type(i) == "table"
		then
			s = s .. M.tree(i)
		else
			s = s .. "<li>" .. i .. "</li>\n"
		end
	end
	
	return s .. "</ul>"
end

-- description list
function M.describe(v)
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
function M.list(v)
	if type(v) == "string" then return("<ol><li>".. v .. "</li></ol>\n") end
	
	local s = "<ol>\n"
	for n, i in ipairs(v)
	do
		if type(i) == "table"
		then
			s = s .. M.list(i)
		else
			s = s .. "<li>" .. i .. "</li>\n"
		end
	end
	
	return s .. "</ol>"
end

-- generic 2d table
function M.table(v)
	if type(v) == "string" then return("<table><tr><td>".. v .. "</td></tr></table>") end

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
function M.calc(f, v)
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

function M.convert(file, out, depth)
	local ohandle = assert(io.open(out:gsub("%.lua", ".html"), "w"))
	
	T = {} -- clear temporary values
	
	-- build the depth path
	if depth > 1
	then
		T.depth = ""
		for i = 2, depth
		do
			T.depth = T.depth .. "../"
		end
	else
		T.depth = "./"
	end
	
	assert(loadfile(file, "t", M))()
	ohandle:write(T.output or "") -- global
	ohandle:close()
end

return M
