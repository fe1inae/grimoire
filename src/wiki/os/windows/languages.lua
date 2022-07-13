document {
	title "windows languages",
	
	p {
		"cross platform languages are hard. and i am lazy. this is list of tolerable",
		"programming languages that work well enough for me on linux and windows. ",
	},
	
	p {
		"immediately, platform locked or even platform inconvenient ones are tossed.",
		"C#, despite the improvement, is still largely a windows only thing. or at least",
		"the complexity required is not worth it for me.",
	},

	h2 "vms",

	describe {
		{
			url("https://git.sr.ht/~rabbits/uxn", "uxnemu") .. "/" .. url("https://github.com/randrew/uxn32", uxn32),
			p {
				"one of those (mostly) pure vms, so innatively cross platform if people take ",
				"the time to write the emulators. which the uxn community seems to like to",
				"do. very solid option for a minimal, small graphical interface **without much",
				"foreign interaction**.",
			},
		},
	},

	h2 "compiled",
	
	h2 "dynamic",
}
