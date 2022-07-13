# FUNCTIONS
# =========

# basic stack push
function push(val) {
	STACK[length(STACK)+1] = val
}

# basic stack pop
function pop() { 
	i = length(STACK)
	val = STACK[i]
	delete STACK[i]
	return val 
}

# greedy function to pull everything from the stack
# joins with a seperator
function greed(sep) {
	tmp=""
	while (str = pop()) {
		if (str == "\n") {
			tmp = "\n" tmp
		} else {
			tmp = sep str tmp
		}
	}
	gsub(/[^[:alnum:]]/, "\\\\&", sep)
	sub(sep, "", tmp) # remove trailing
	return tmp
}

# VARIABLES
# =========

# STACK: the big boi
# REFS: references

BEGIN {}

# MODIFYING PATTERNS
# ==================

# inline reference, gemini doesnt support natively so
# save to an array and write in the footer.
/^\.REF$/ {
	n = length(REFS)+1
	tmp = pop()
	push(sprintf("%s[%d]", pop(), n))
	REFS[n] = tmp
}

# PRINTING PATTERNS
# =================

# newline
/^\.$/ { printf("\n") }

# headers
/^\.H1$/ { printf("# %s\n\n", greed(" ")) }
/^\.H2$/ { printf("## %s\n\n", greed(" ")) }
/^\.H3$/ { printf("### %s\n\n", greed(" ")) }

# formatting
/^\.PP$/ { printf("%s\n\n", greed(" ")) }
/^\.NF$/ { printf("```\n%s\n```\n\n", greed("\n")) }
/^\.BL$/ { printf("* %s\n", greed("\n* ")) }

# links
/^\.LINK$/ { printf("=> %s %s\n", pop(), greed(" ")) }

# FALLBACK
# ========

# no command, push to stack
/^[^\.;]/ { 
	# remove escaped comment/comamnd
	sub("\\\\;", ";")
	sub("\\\\\\.", ".")
	push($0) 
}


# FOOTER
# ======

END {
	# handle references
	len = length(REFS)
	if (len > 0) {
		printf "# references\n\n"
		i = 1
		while ( i <= len ) {
			printf("=> %s [%d]\n", REFS[i], i);
			i=i+1
		}
	}
}
