document {
	title "favorite programming languages",

	p {
		"theres a lot of languages, i tend to like small ones that each fit into a niche.",
		"both in terms of purpose driven design, and overarching paradigms.",
	},

	h2 "known like",

	tree {
		url("./awk.html", "awk")     .. "for its text processing focus",
		url("./c.html", "c")         .. "for its universality and control",
		url("./forth.html", "forth") .. "for its representation of the computer",
		url("./lisp.html", "lisp")   .. "for its representation of data",
		url("./sh.html", "shell")    .. "for its stupid yet versatile hackiness",
	},

	h2 "should try",

	tree {
		"go for being so boring its good",
		"erlang for its actor model of concurrency",
		ref("https://wiki.xxiivv.com/site/uxntal.html", "uxn") 
		.. "for its simplicity in making small gui applications",
		"zig for consolidated systems which make working cross platform easier and comptime abuse",
		"nim for the hilarious macro abuse in a compiled language",
		"odin for its amassed stdlib",
	},
}
