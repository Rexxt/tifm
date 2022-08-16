#!/bin/env bash
init() {
	# consts
	__TIFM_VERSION="0.1.0"
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
	SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
	# config
	source "$SCRIPT_DIR/config.sh"
}

main() {
	echo "$CYAN╭ $BRIGHT$GREEN$PWD$NORMAL"
	while read file; do
		echo "$CYAN│ $BLUE$file$NORMAL"
	done < <(ls -1)
	read -n 1 -p "$CYAN╰ ${RED}tifm> $YELLOW" ans
	if [ "$ans" != "n" ] && [ "$ans" != "r" ]; then
		echo ""
	fi
	printf "$NORMAL"
	case "$ans" in
		N)
			echo "Select a directory to go to (/cancel)."
			read -p "nav:: " tifm_dir
			if [ "$tifm_dir" == "/cancel" ]; then
				echo "Cancelled."
				return
			else
				cd $tifm_dir
			fi
		;;
		o)
			echo "Choose a file to open (/cancel)."
			read -p "from:: " tifm_file
			if [ "$tifm_file" == "/cancel" ]; then
				echo "Cancelled."
				return
			else
				xdg-open $tifm_file
			fi
		;;
		p)
			echo "Choose a file to view (/cancel)."
			read -p "from:: " tifm_file
			if [ "$tifm_file" == "/cancel" ]; then
				echo "Cancelled."
				return
			else
				$__TIFM_PAGER $tifm_file
			fi
		;;
		e)
			echo "Choose a file to edit (/cancel)."
			read -p "from:: " tifm_file
			if [ "$tifm_file" == "/cancel" ]; then
				echo "Cancelled."
				return
			else
				$__TIFM_EDITOR $tifm_file
			fi
		;;
		c)
			echo "Choose the file and the location you would like to copy it to (/cancel)."
			read -p "from:: " tifm_file_from
			if [ "$tifm_file_from" == "/cancel" ]; then
				echo "Cancelled."
				return
			fi
			read -p "to:: " tifm_file_to
			if [ "$tifm_file_to" == "/cancel" ]; then
				echo "Cancelled."
				return
			fi
			cp "$tifm_file_from" "$tifm_file_to"
		;;
		m)
			echo "Choose the file and the new location you would like to move it to."
			read -p "from:: " tifm_file_from
			if [ "$tifm_file_from" == "/cancel" ]; then
				echo "Cancelled."
				return
			fi
			read -p "to:: " tifm_file_to
			if [ "$tifm_file_to" == "/cancel" ]; then
				echo "Cancelled."
				return
			fi
			mv "$tifm_file_from" "$tifm_file_to"
		;;
		i)
			ls -l -1
		;;
		n)
			read -n 1 tifm_type
			echo ""
			case "$tifm_type" in
				d)
					echo "Choose the directory you would like to create (/cancel)."
					read -p "name:: " tifm_dir_name
					if [ "$tifm_dir_name" == "/cancel" ]; then
						echo "Cancelled."
						return
					fi
					mkdir "$tifm_dir_name"
				;;
				f)
					echo "Choose the file you would like to create (/cancel)."
					read -p "name:: " tifm_file_name
					if [ "$tifm_file_name" == "/cancel" ]; then
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
					echo "Choose the directory you would like to remove (/cancel)."
					read -p "name:: " tifm_dir_name
					if [ "$tifm_dir_name" == "/cancel" ]; then
						echo "Cancelled."
						return
					fi
					rm -rf "$tifm_dir_name"
				;;
				f)
					echo "Choose the file you would like to remove (/cancel)."
					read -p "name:: " tifm_file_name
					if [ "$tifm_file_name" == "/cancel" ]; then
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
			echo "Choose a file or folder to change the permission (/cancel)."
			read -p "item:: " tifm_select
			if [ "$tifm_select" == "/cancel" ]; then
				echo "Cancelled."
				return
			fi
			echo "Choose the arguments from 'chmod' to set as permission for the file or folder (/cancel). (Read the manual for chmod for more info)"
			read -p "perm:: " tifm_perm
			if [ "$tifm_perm" == "/cancel" ]; then
				echo "Cancelled."
				return
			fi
			chmod $tifm_perm $tifm_select
		;;
		t)
			/bin/bash
		;;
		"?")
			echo "${LIME_YELLOW}List of commands:$NORMAL
N      - Goes to a folder
o      - Opens a file
p      - View file (uses 'less' by default - change in config.sh)
e      - edit a file (uses 'nano' by default - change in config.sh)
m      - Moves/Renames a file
c      - Copies a file to a location
i      - Shows the list of files inside the directory (with detail)
n(f/d) - Creates a folder or file
r(f/d) - Removes a folder or file
P      - Sets permissions for a specific file or folder
t      - Switches to command line mode, run 'exit' to exit.
Q      - Quits the program"
		;;
		Q)
			clear
			exit
		;;
		*)
			echo "Unrecognized command. Type '?' for a list of commands."
		;;
	esac
	echo ""
}

(
	clear
	init
	echo "$CYAN╭$NORMAL tifm $__TIFM_VERSION
$CYAN│$NORMAL github.com/Rexxt/tifm
$CYAN╰$NORMAL Strike '?' for help"
	echo ""
	while true; do
		main
	done
)
