#!/bin/sh

awk '
/^ *```/ { IN=(IN==1 ? 0 : 1) }

NR == 1 {
	split($0, tmp, "  +")
	PREV=tmp[1] " - " tmp[2]
	next
}

{
	if (IN)
		gsub("^     ", "") # XXX: make more robust, unindent no format
	else {
		# replace characters
		gsub("•", "*") # bullet points
		
		# greedily trim leading whitespace
		gsub("^ +", "") 
		
		# trim weird leading spaces
		gsub("^\\* +", "* ")
		gsub("^=> +", "=> ")
		
		# misc
		gsub("^#.*$", "&\n") # add indent after headers
	}
}

{ 
	print PREV
	PREV=$0
}

END {
	split(PREV, tmp, "  +")
	print tmp[2]
}

'
