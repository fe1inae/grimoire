#!/bin/sh

awk '
/^\.Bd.*-literal/ {
	IN=1
	print  $0 "\n```"
	next
}

{
	if (! IN) {
		sub("^.Sh", ".Sh #")
		sub("^.Ss", ".Ss ##")
		sub("^.Lk", "=> ")
		sub("^.It Lk", ".It => ")
	}
}

/^\.Ed/ {
	if (IN) {
		printf "```\n" $0
		IN=0
	}
}

{ print }
'
