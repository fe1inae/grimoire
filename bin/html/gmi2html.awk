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

	# embed images
	if (url ~ /\.(png|jpg|jpeg|gif)$/) {
		# local file, do extra shit
		if (url ~ /^\//) {
			file = "src" url

			# get dimensions
			CMD = "identify -format \"%[fx:w]x%[fx:h]\" " file
			CMD | getline size
			close(CMD)
			width  = size
			sub(/x.*$/, "", width)
			height = size
			sub(/^.*x/, "", height)

			# base64
			CMD = "base64 -w 0 " file
			CMD | getline b64
			close(CMD)

			# mime type
			CMD = "file -b --mime-type " file
			CMD | getline mime
			close(CMD)

			data = sprintf("data:%s;base64,%s", mime, b64)

			# print image
			printf( \
				"<p><a href=\"%s\">" \
				"<img " \
					"src=\"%s\" " \
					"alt=\"%s\" "  \
					"width=\"%d\" " \
					"height=\"%d\"/>" \
				"</a></p>", 
				url, data, alt, width, height)

		# external
		} else {
			printf("<p><a href=\"%s\"><img src=\"%s\" alt=\"%s\"/></a></p>", 
				url, url, alt)
		}

	} else {
		printf("<p><a href=\"%s\">%s</a></p>", url, alt)
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
