. etc/fetch.env

# FUNCTIONS
# ---------

FG() {
	printf '\033[38;2;%s;%s;%sm'             \
		"$(printf 'ibase=16; %s\n' "$1" | bc)" \
		"$(printf 'ibase=16; %s\n' "$2" | bc)" \
		"$(printf 'ibase=16; %s\n' "$3" | bc)"
}

BG() {
	printf '\033[48;2;%s;%s;%sm'             \
		"$(printf 'ibase=16; %s\n' "$1" | bc)" \
		"$(printf 'ibase=16; %s\n' "$2" | bc)" \
		"$(printf 'ibase=16; %s\n' "$3" | bc)"
}

RESET="$(printf '\033[0m')"

# VARIABLES
# ---------

COLORS="\
#252121 #3e3333 #644a4a #996363 #cb7d7d \
#e4a0a0 #f2bebe #f9d6d6 #252121 #3e3333 \
#644c4a #996b63 #cb8c7d #e4aca0 #f2c6be \
#f9dad6 #252521 #3e3e33 #64644a #999963 \
#cbcb7d #e4e4a0 #f2f2be #f9f9d6 #212521 \
#333e33 #4c644a #6b9963 #8ccb7d #ace4a0 \
#c6f2be #daf9d6 #212521 #333e33 #4a644a \
#639963 #7dcb7d #a0e4a0 #bef2be #d6f9d6 \
#212521 #333e33 #4a644c #63996b #7dcb8c \
#a0e4ac #bef2c6 #d6f9da #212525 #333e3e \
#4a6464 #639999 #7dcbcb #a0e4e4 #bef2f2 \
#d6f9f9 #212125 #33333e #4a4c64 #636b99 \
#7d8ccb #a0ace4 #bec6f2 #d6daf9 #212125 \
#33333e #4a4a64 #636399 #7d7dcb #a0a0e4 \
#bebef2 #d6d6f9 #212125 #33333e #4c4a64 \
#6b6399 #8c7dcb #aca0e4 #c6bef2 #dad6f9 \
#252125 #3e333e #644a64 #996399 #cb7dcb \
#e4a0e4 #f2bef2 #f9d6f9 #252121 #3e3333 \
#644a4c #99636b #cb7d8c #e4a0ac #f2bec6 \
#f9d6da #222222 #373737 #555555 #7a7a7a \
#a0a0a0 #bebebe #d5d5d5 #e5e5e5"

SYMBOLS="half"

DOPTS="-s 0.0001"
COPTS="-p off -c full"

MAXLEN=80

W=$(($MAXLEN/2))
H=$(($MAXLEN/3))

# COLORS
# ------

WHITE="FF FF FF"
BLACK="00 00 00"

DEFAULT="$(FG ${WHITE})$(BG ${BLACK})"

# TYPES
# -----

ME="$(BG FF CC FF)$(FG $BLACK)"
MISC="$(BG 22 22 22)$(FG $WHITE)"

# CONTENTS
# --------

MSG="
$ME NICKNAME $DEFAULT felinae
$ME PRONOUNS $DEFAULT she/her



$(BG CC FF FF)$(FG $BLACK) LINKS $DEFAULT
$(BG ${BLACK})$(FG CC FF FF)|$DEFAULT https://ulthar.cat/cgi-bin/cgit/
$(BG ${BLACK})$(FG CC FF FF)|$DEFAULT mailto:felinae@ulthar.cat
$(BG ${BLACK})$(FG CC FF FF)|$DEFAULT https://sr.ht/~fel
$(BG ${BLACK})$(FG CC FF FF)|$DEFAULT fel@nixnet.social



$MISC OS     $DEFAULT $OS
$MISC TERM   $DEFAULT $TERM
$MISC SHELL  $DEFAULT $SHELL
$MISC EDITOR $DEFAULT $EDITOR
$MISC VISUAL $DEFAULT $VISUAL
"

# WRITE SHIT
# ----------

printf '%s' "$DEFAULT"

i=1
didder                                          \
	-x "$MAXLEN"                                \
	-y "$MAXLEN"                                \
	-p "$COLORS"                                \
	$DOPTS                                      \
	-out -                                      \
	-in "src/pic/fel.png"                       \
	bayer 256 256                               \
	| chafa                                     \
		-s "${W}x${H}"                          \
		--symbols "$SYMBOLS"                    \
		$COPTS                                  \
		-                                       \
| while IFS= read -r imgline; do
	txtline="$(printf "$MSG" | sed -n "${i}p" | tr -d '\n')"
	txtlen="$(printf '%s' "$txtline" | sed -E 's/\x1b\[[^mK]*[m|K]//g' | wc -m)"
	imglen="$(printf '%s' "$imgline" | sed -E 's/\x1b\[[^mK]*[m|K]//g' | wc -m)"
	printf '%s %s%s%*s%s\n'                       \
		"$imgline$DEFAULT" "$txtline" "$DEFAULT"  \
		"$((MAXLEN-${imglen}-${txtlen}-3))" " "   \
		"$RESET"

	i=$((i+=1))
done
