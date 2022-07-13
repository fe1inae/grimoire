#!/bin/sh

# The following environment variables can be used to retrieve the configuration
# of the repository for which this script is called:
# CGIT_REPO_URL        ( = repo.url       setting )
# CGIT_REPO_NAME       ( = repo.name      setting )
# CGIT_REPO_PATH       ( = repo.path      setting )
# CGIT_REPO_OWNER      ( = repo.owner     setting )
# CGIT_REPO_DEFBRANCH  ( = repo.defbranch setting )
# CGIT_REPO_SECTION    ( = section        setting )
# CGIT_REPO_CLONE_URL  ( = repo.clone-url setting )

cd "/lib/cgit/filter/tohtml"

case "$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')" in
	*.markdown|*.mdown|*.md|*.mkd) exec ./md2html; ;;
	*.[1-9]) exec ./man2html; ;;
	*.htm|*.html) exec cat; ;;
	*.txt|*) exec ./txt2html; ;;
esac
