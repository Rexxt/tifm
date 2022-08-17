#!/bin/env bash
declare -a -x tifm_extensions
declare -A -x tifm_extensions_commands
declare -a -x tifm_extensions_longcommands
declare -A -x tifm_extensions_subcommands
tifmx.bind() {
	tifm_extensions_commands["$1"]="$2"
}
tifmx.add_long() {
	tifm_extensions_longcommands+=("$1")
}
tifmx.bind_sub() {
	tifm_extensions_subcommands["$1$2"]="$3"
}
# consts
__TIFM_VERSION="0.2.0"
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
LIME_YELLOW=$(tput setaf 190)
POWDER_BLUE=$(tput setaf 153)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)
BLINK=$(tput blink)
REVERSE=$(tput smso)
UNDERLINE=$(tput smul)
DIM=$(tput dim)
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

init() {
	# vars
	STATUS=0
	# config
	source "$SCRIPT_DIR/config.sh"
	# load extensions
	tput sc
	printf "Loading extensions... "
	load_extensions
	printf "Done.\n"
}

load_extensions() {
	local count=0
	# check how many files are in the extensions directory
	local files=$(ls -1 "$SCRIPT_DIR/extensions" | wc -l)
	for extension in "$SCRIPT_DIR/extensions/"*; do
		source "$extension"
		# add only the name of the extension to the array (ex: extensions/git.sh -> git)
		local ext_name=$(basename "$extension" | cut -d. -f1)
		tifm_extensions+=("$ext_name")
		count=$((count + 1))
		# percentage of completion
		local percent=$((count / files * 100))
		tput rc
		printf "Loading extensions... $count/$files ($percent%%)\n"
		# if function $ext_name.init exists, call it
		if type "$ext_name".init &> /dev/null; then
			"$ext_name".init
		fi
	done
}

main() {
	echo "$__TIFM_DECO_COLOUR$__ANGLE_UP_RIGHT $(__TIFM_DISPLAY)$NORMAL"
	while read file; do
		echo "$__TIFM_DECO_COLOUR$__VBAR $__TIFM_LS_COLOUR$file$NORMAL"
	done < <(ls -a)
	read -n 1 -p "$__TIFM_DECO_COLOUR$__ANGLE_DOWN_RIGHT $(__TIFM_PROMPT) $YELLOW" ans

	if [[ "$ans" != "n" ]] && [[ "$ans" != "r" ]] && [[ ! "${tifm_extensions_longcommands[*]}" =~ "$ans" ]]; then
		echo ""
	fi
	printf "$NORMAL"

	case "$ans" in
		N)
			echo "Select a directory to go to (/c(ancel))."
			read -p "nav:: " tifm_dir
			if [[ "$tifm_dir" == "/c" ]]; then
				echo "Cancelled."
				return
			else
				cd $tifm_dir
				# for ever extension, if it has a function called name.nav, call it
				for ext_name in "${tifm_extensions[@]}"; do
					if type "$ext_name".nav &> /dev/null; then
						"$ext_name".nav
					fi
				done
			fi
		;;
		o)
			echo "Choose a file to open (/c(ancel))."
			read -p "file:: " tifm_file
			if [[ "$tifm_file" == "/c" ]]; then
				echo "Cancelled."
				return
			else
				xdg-open $tifm_file
			fi
		;;
		p)
			echo "Choose a file to view (/c(ancel))."
			read -p "file:: " tifm_file
			if [[ "$tifm_file" == "/c" ]]; then
				echo "Cancelled."
				return
			else
				$__TIFM_PAGER $tifm_file
			fi
		;;
		e)
			echo "Choose a file to edit (/c(ancel))."
			read -p "file:: " tifm_file
			if [[ "$tifm_file" == "/c" ]]; then
				echo "Cancelled."
				return
			else
				$__TIFM_EDITOR $tifm_file
			fi
		;;
		c)
			echo "Choose the file and the location you would like to copy it to (/c(ancel))."
			read -p "from:: " tifm_file_from
			if [[ "$tifm_file_from" == "/c" ]]; then
				echo "Cancelled."
				return
			fi
			read -p "to:: " tifm_file_to
			if [[ "$tifm_file_to" == "/c" ]]; then
				echo "Cancelled."
				return
			fi
			cp "$tifm_file_from" "$tifm_file_to"
		;;
		m)
			echo "Choose the file and the new location you would like to move it to."
			read -p "from:: " tifm_file_from
			if [[ "$tifm_file_from" == "/c" ]]; then
				echo "Cancelled."
				return
			fi
			read -p "to:: " tifm_file_to
			if [[ "$tifm_file_to" == "/c" ]]; then
				echo "Cancelled."
				return
			fi
			mv "$tifm_file_from" "$tifm_file_to"
		;;
		i)
			echo "Choose the directory to inspect (/c(ancel))."
			read -p "dir:: " tifm_dir
			if [[ "$tifm_dir" == "/c" ]]; then
				echo "Cancelled."
				return
			else
				ls -l $tifm_dir
			fi
		;;
		n)
			read -n 1 tifm_type
			echo ""
			case "$tifm_type" in
				d)
					echo "Choose the directory you would like to create (/c(ancel))."
					read -p "name:: " tifm_dir_name
					if [[ "$tifm_dir_name" == "/c" ]]; then
						echo "Cancelled."
						return
					fi
					mkdir "$tifm_dir_name"
				;;
				f)
					echo "Choose the file you would like to create (/c(ancel))."
					read -p "name:: " tifm_file_name
					if [[ "$tifm_file_name" == "/c" ]]; then
						echo "Cancelled."
						return
					fi
					touch "$tifm_file_name"
				;;
				*)
					echo "Invalid type ([d]irectory/[f]ile)."
				;;
			esac
		;;
		r)
			read -n 1 tifm_type
			echo ""
			case "$tifm_type" in
				d)
					echo "Choose the directory you would like to remove (/c(ancel))."
					read -p "name:: " tifm_dir_name
					if [[ "$tifm_dir_name" == "/c" ]]; then
						echo "Cancelled."
						return
					fi
					rm -rf "$tifm_dir_name"
				;;
				f)
					echo "Choose the file you would like to remove (/c(ancel))."
					read -p "name:: " tifm_file_name
					if [[ "$tifm_file_name" == "/c" ]]; then
						echo "Cancelled."
						return
					fi
					rm "$tifm_file_name"
				;;
				*)
					echo "Invalid type ([d]irectory/[f]ile)."
				;;
			esac
		;;
		P)
			echo "Choose a file or folder to change the permission (/c(ancel))."
			read -p "item:: " tifm_select
			if [[ "$tifm_select" == "/c" ]]; then
				echo "Cancelled."
				return
			fi
			echo "Choose the arguments from 'chmod' to set as permission for the file or folder (/c(ancel)). (Read the manual for chmod for more info)"
			read -p "perm:: " tifm_perm
			if [[ "$tifm_perm" == "/c" ]]; then
				echo "Cancelled."
				return
			fi
			chmod $tifm_perm $tifm_select
		;;
		t)
			/bin/bash
		;;
		";")
			# open config
			$__TIFM_EDITOR "$SCRIPT_DIR/config.sh"
			# reload config
			source "$SCRIPT_DIR/config.sh"
		;;
		"?")
			echo "${LIME_YELLOW}List of commands:$NORMAL
N      - Goes to a folder
o      - Opens a file
p      - View file (uses 'less' by default - change in config.sh)
e      - edit a file (uses 'nano' by default - change in config.sh)
m      - Moves/Renames a file
c      - Copies a file to a location
i      - Inspects a directory (ls -l) and pipes it to the selected pager ('less' by default - change in config.sh)
n(f/d) - Creates a folder or file
r(f/d) - Removes a folder or file
P      - Sets permissions for a specific file or folder
t      - Switches to command line mode, run 'exit' to exit.
;      - Open config file
Q      - Quits the program"
		;;
		Q)
			clear
			exit
		;;
		*)
			if [[ ! -z "${tifm_extensions_commands[$ans]}" ]]; then
				eval "${tifm_extensions_commands[$ans]}"
			elif [[ "${tifm_extensions_longcommands[*]}" =~ "$ans" ]]; then
				read -n 1 tifm_subcommand
				echo ""
				if [[ ! -z "${tifm_extensions_subcommands[$ans$tifm_subcommand]}" ]]; then
					eval "${tifm_extensions_subcommands[$ans$tifm_subcommand]}"
				else
					echo "Invalid subcommand."
				fi
			else
				echo "Unrecognized command. Type '?' for a list of commands."
			fi
		;;
	esac
	STATUS=$?
	echo ""
}

(
	clear
	init
	echo "$__TIFM_DECO_COLOUR$__ANGLE_UP_RIGHT$GREEN tifm $__TIFM_VERSION$NORMAL
$__TIFM_DECO_COLOUR$__VBAR$NORMAL $BLUE${UNDERLINE}https://github.com/Rexxt/tifm$NORMAL
$__TIFM_DECO_COLOUR$__VBAR$NORMAL $RED$REVERSE/!\\ you are running a bleeding edge version of tifm. $NORMAL
$__TIFM_DECO_COLOUR$__VBAR$NORMAL $RED$REVERSE    if you encounter any bugs, report them on github.$NORMAL
$__TIFM_DECO_COLOUR$__ANGLE_DOWN_RIGHT$NORMAL strike '?' for help"
	echo ""
	while true; do
		main
	done
)
