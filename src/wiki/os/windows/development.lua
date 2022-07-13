document {
	title "development on windows",

	p "programs and general setup that i use for development on windows",

	h2 "software",

	describe {
		{
			ref("https://scoop.sh/", "scoop"),
			p {
				"i use this for most things, and many of my scripts are hardcoded for the",
				"default installation path. unless otherwise noted, the following programs",
				"are installed using this.",
			},
		},
		{
			ref("https://github.com/mintty/wsltty/", "wsltty"),
			p {
				"minimalish mintty wrapper around wsl, has some nice features but mostly ",
				"used for the convenient mintty.",
			},
		},
		{
			ref("https://git-scm.com/", "scoop"),
			p {
				"a given, no? especially helpful is submodules for as dependency",
				"management in projects is even more of a pain on windows, so embedding them",
				"inside of the project itself is the way to go (for my complexity at least)",
			},
		},
	},
	
	h2 "scripts",

	
	describe {{
		"edit.bat",
		p {
			"wrapper script that runs program `edit` inside wsl `Alpine`. requires path",
			"conversion inside wsl, so use a script to shim it.",
		},
	}},

	code [[
%USERPROFILE%\scoop\apps\wsltty\current\bin\mintty.exe --WSL="Alpine" --configdir="%USERPROFILE%\scoop\apps\wsltty\current\config" sh -lic ^'edit %*^'
]],

	p {
		"i use this as my ide basically, opening a separate cmd window if i need it.",
		"(fun and quite useful windows trick: in file explorer, pressing Alt+d selects ",
		"the path, and you can enter commands there!)",
	},
}
