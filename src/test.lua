document {
	h1 "title",
	h2 "tittle2",
	h3 "HEADER 3",
	
	h1 {"a", "b", "c"},
	
	p {
		"a pargarph and inline link, say to",
		url("https://google.com", "google"),
	},
	
	tree {
		"this is one thing",
		"this is another",
		{
			"this is a subtree",
			"AAAAAAA",
			{
				"this is another.",
			},
		},
	},
	
	table "lol",
	
	table {
		{"tables", "for",  "well,", "tables"},
		{1,        2,      3,       "aa"},
		{4,        8,      7,       "aa"},
		{4,        "hang", null,    "aa"},
		{3,        3,      3,       "aa"},
	},
	
	p "this is a thingy majiger that calculate",
	
    calc(
    	function(t)
    		return({t[1], t[2], t[3], t[1]+t[3]})
    	end,
    	{
    		{"a", "b",   "c", "result"},
    		{1,   "aaa", 2,   _},
    		{8,   "aaa", 5,   _},
    		{2,   "aaa", 7,   _},
    	}
    ),
    
    p {
    	"a random shittery",
    	"with a ",
    	bold("bold in it omggg"),
    	under("and underline"),
    	italic("italics"),
    	strike("a strkethrough"),
    },
}
