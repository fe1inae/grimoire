# heuristically un "hard-wrap" gemtext

NR == 1 { PREV=$0; next }

/^.*/   { TYPE="IDK" }

/^# /   { TYPE="H1" }
/^## /  { TYPE="H2" }
/^### / { TYPE="H3" }

/^```/ { TYPE="PRE"; PRE=( PRE==0 ? 1 : 0 ) }

/^=> /  { TYPE="LINK" }
/^\* /  { TYPE="LIST" }
/^> /   { TYPE="QUOTE" }
/^$/    { TYPE="NL" }

{
	if (PRE || TYPE == PRE)
		print PREV
	else
		if (TYPE == "IDK")
			if (PTYPE == "IDK" || PTYPE == "LIST")
				printf("%s ", PREV)
			else
				printf("%s\n", PREV)
		else
			printf("%s\n", PREV)
	
	PTYPE=TYPE
	PREV=$0
}


END { print PREV }
