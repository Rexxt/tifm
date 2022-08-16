#!/bin/env bash
consts() {
	__TIFM_VERSION="0.1.0"
}

main() {
	echo "╭ $PWD"
	while read file; do
		echo "│ $file"
	done < <(ls -1)
	read -n 1 -p "╰ tifm> " ans
	if [ "$ans" != "n" ] && [ "$ans" != "r" ]; then
		echo ""
	fi
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
		p)
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
			echo "
			List of commands:
			N
			- Goes to a folder
			o
			- Opens a file
			m 
			- Moves/Renames a file
			c
			- Copies a file to a location
			i
			- Shows the list of files inside the directory (with detail)
			n
			- Creates a folder or file
			r
			- Removes a folder or file
			p
			- Sets permissions for a specific file or folder
			t
			- Switches to command line mode, run 'exit' to exit.
			Q
			- Quits the program"
		;;
		Q)
			clear
			exit
		;;
		*)
			echo "Unrecognized command. Type '?' for a list of commands."
		;;
	esac
}

(
	consts
	echo "╭ tifm $__TIFM_VERSION
│ github.com/Rexxt/tifm
╰ Strike '?' for help
"
	echo "Loading contents from $PWD..."
	while true; do
		main
	done
)
