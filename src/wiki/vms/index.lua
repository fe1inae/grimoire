title = "alternative computing environments"

document {
	h1 {title},
	
	p {
		"computers are kinda bad.",
		"thats not really an uncommon opinon to have nowadays,",
		"at least in the circles that i spectate in.",
		"this is a list of environments that you could 'live' in,",
		"while mostly ignoring the shithole it sits on ☺",
	},

	h2 "small",

	p {
		"fit for oneoff things, but doesnt have the capability",
		"to replicate a truly complex system.",
	},
	
	describe {
		{
			ref("https://wiki.xxiivv.com/site/varvara.html", "varvara/uxn"),
			p {
				"forth-based virtual machine with audio-visual capabilities.",
				"quite limited in scale, designed only for single purpose applications.",
			},
		},
	},

	h2 "medium",

	p "could feasibly 'live' in it with enough effort.",

	describe {
		{
			ref("https://www.gnu.org/software/emacs/", "emacs"),
			p {
				"certainly the most well known of this category,",
				"in this context its functionally a lisp machine with text buffers attatched.",
			},
		},
		{
			ref("http://collapseos.org/download.html", "collapse os"),
			p {
				"a forth based operating system with the goal of being boot-strappable",
				"in the case of civilazation collapsing. or in other words, from nearly",
				"nothing.",
			},
		},
	},

	h2 "large",

	p {
		"mostly full on operating systems,",
		"requires complex emulation such as qemu or bare metal.",
	},

	describe {
		{
			ref("https://9front.org/", "9front"),
			p {
				"community fork of plan9 to continue development.",
				"has quite a cult following and many interesting ideas.",
			},
		},
	},
}
