title = "ulthar cat"

document {
	h1 "about",
	
	p "felinae she/her",
	
	embed("./pic/fel.png", "current avatar", 256, 256),
	
	p {
		"perma lurking adhd computer cat.",
		"fan of movement shooters, personal(ized) computing,",
		"emergent behavior, and cats."
	},
	
	tree { url("./contacts.html", "contacts") },
	
	h1 "pages",
	
	tree {
		url("/cgi-bin/cgit", "git repos"),
		url("/blog/index.html", "blog and/or rants"),
		url("/misc/index.html", "miscellaneous posts"),
		url("/wiki/index.html", "personal wiki/notes tree"),
	}
}
