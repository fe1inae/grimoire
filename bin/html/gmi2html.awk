# CHUNKIES
# ========

# no formatting
/^```/ { 
	sub("^```", "")
	printf("<pre alt=\"%s\">", $0)
	while (getline) {
		if ($0 ~ /^```/)
			break
		print $0
	}
	printf("</pre>")
	next
}

# lists
/^\* +/ {
	printf("<ul>")
	sub("^\\* +", "")
	printf("<li>%s</li>", $0)
	while (getline) {
		if ($0 !~ /^\* +/)
			break
		sub("^\\* +", "")
		printf("<li>%s</li>", $0)
	}
	printf("</ul>")
}

# HEADERS
# =======

/^# +/ {
	sub("^# +", "")
	printf("<h1>%s</h1>", $0)
	next
}
/^## +/ {
	sub("^## +", "")
	printf("<h2>%s</h2>", $0)
	next
}
/^### +/ {
	sub("^### +", "")
	printf("<h3>%s</h3>", $0)
	next
}

# LINKS
# =====

/^=> +/ {
	sub("^=> +", "")
	url=$1
	sub("^" $1 " *", "")
	
	if ($0)
		alt = $0
	else
		alt = url
	
	if (url ~ /\.(png|jpg|jpeg|gif)$/) {
		printf("<a href=\"%s\"><img src=\"%s\" alt=\"%s\"></a><br>", 
			url, url, alt)
	} else {
		printf("<a href=\"%s\">%s</a><br>", url, alt)
	}
	
	next
}

# BLOCK QUOTES
# ============

/^> +/ {
	sub("^> ", "")
	printf("<blockquote>%s</blockquote>", $0)
	next
}

# FALLBACKS
# =========

{ printf("<p>%s</p>", $0) }
