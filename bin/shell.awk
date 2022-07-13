BEGIN { srand()}

/^\$\$\$ / {
	$1=""
	CMD=$0
	STR=""

	IN=1
	next
}

/^\$\$\$/ {
	r=rand()
	cmd=CMD " <<'" r "'\n" STR
	while (cmd | getline)
		print $0
	IN=0
	next
}

{
	if (IN) {
		STR=STR $0 "\n"
	} else {
		print $0
	}

}

