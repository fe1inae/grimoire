. etc/fetch.env

# VARIABLES
# ---------

COLORS="black white"

SYMBOLS="ascii"

DOPTS="-s 0.1"
COPTS="--invert -p off -c none"

MAXLEN=80

W=$(($MAXLEN/2))
H=$(($MAXLEN/2))

# CONTENTS
# --------

MSG="
 NICKNAME  felinae
 PRONOUNS  she/her

 REPOS   gemini://ulthar.cat/git/
 GEMINI  gemini://ulthar.cat/
 HTTPS   https://ulthar.cat/

 CONTACT  felinae@ulthar.cat

 OS      $OS
 TERM    $TERM
 SHELL   $SHELL
 VISUAL  $VISUAL
 EDITOR  $EDITOR
"

# WRITE SHIT
# ----------

printf '+'
for i in $(seq 1 $(($MAXLEN-2))); do
    printf '-'
done
printf '+\n'

i=1
didder                                          \
	-x "$MAXLEN"                                \
	-y "$MAXLEN"                                \
	-p "$COLORS"                                \
	$DOPTS                                      \
	-out -                                      \
	-in "etc/fel.png"                           \
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
    printf '%s %s%s%*s%s\n'                     \
    	"|"                                     \
    	"$imgline" "$txtline"                   \
    	"$((MAXLEN-${imglen}-${txtlen}-3))" " " \
    	"|"

    i=$((i+=1))
done

printf '+'
for i in $(seq 1 $(($MAXLEN-2))); do
    printf '-'
done
printf '+\n'
