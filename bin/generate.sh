#!/bin/sh -e

PANDOC_ARGS="$(sed 's/\n/ /g' <<EOF
--self-contained
--standalone
--lua-filter filter/misc/diagram-generator/diagram-generator.lua
--lua-filter filter/misc/include-code-files/include-code-files.lua
--lua-filter filter/misc/not-in-format/not-in-format.lua
--lua-filter filter/lua/fix-links.lua
EOF
)"

write_html() {
	find "source" -name "*.md" | while read -r line; do
		file="${line##source/}"
		file="out/html/${file%%.md}.html"
		dir="${file%/*}"
		mkdir -p "$dir"
		pandoc $PANDOC_ARGS \
			-s \
			-t html \
			-c style/style.css \
			--template=template/minimal.html \
			"$line" -o "$file"
	done
}

write_plain() {
	find "source" -name "*.md" | while read -r line; do
		file="${line##source/}"
		file="out/plain/${file%%.md}.txt"
		dir="${file%/*}"
		mkdir -p "$dir"
		pandoc $PANDOC_ARGS \
			-t plain \
			"$line" -o "$file"
	done
}

write_man() {
	find "source" -name "*.md" | while read -r line; do
		file="${line##source/}"
		file="out/man/${file%%.md}.roff"
		dir="${file%/*}"
		mkdir -p "$dir"
		pandoc $PANDOC_ARGS \
			-t man \
			"$line" -o "$file"
	done
}

write_gemini() {
	find "source" -name "*.md" | while read -r line; do
		file="${line##source/}"
		file="out/gemini/${file%%.md}.txt"
		dir="${file%/*}"
		mkdir -p "$dir"
		pandoc $PANDOC_ARGS \
			-s \
			-t plain \
			--lua-filter filter/gemini/gemini.lua \
			"$line" -o "$file"
	done
}

main() {
        write_gemini
        write_html
        write_man
        write_plain
}

main
