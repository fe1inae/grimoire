#!/bin/sh

IMAGES="fel.png loki.png thor.png"

if [ -z "$QUERY_STRING" ]; then
	printf '20 text/gemini\r\n'
	printf '# render image\n'
	printf 'select an image\n\n'
	for img in $IMAGES; do
		printf '=> ?%s\n' "$img"
	done
else
	for img in $IMAGES; do
		if [ "$QUERY_STRING" = "$img" ]; then
			printf '20 text/gemini\r\n'
			printf '```\n'
			chafa                      \
				-c none                \
				-s 80x                 \
				--dither diffusion     \
				--dither-intensity 0.5 \
				--symbols braille      \
				"img/$QUERY_STRING"
			printf '```\n'
			exit 0
		fi
	done
	printf '51 invalid image\r\n'
fi
