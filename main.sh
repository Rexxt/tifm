#!/bin/env bash
clear
echo "
┌─────────────────────────────────────────────────┐
│ %####                                           │
│ #########                                       │
│ @@@###@@# LinFM                                 │
│ @@@@@@@@@ A file manager, in your command line. │
│ Made with <3 by [I> (Icycoide)                  │
└─────────────────────────────────────────────────┘ 
"
sleep 3
echo "Loading contents from " $PWD"..."

clear
main() {
    echo "┌─ Waiting for action at" $PWD
    read -p "└─linfm> " lfm_ans
    case "$lfm_ans" in
      SetDir)
        echo "Select a directory to go to."
        read lfm_setdir
        cd $lfm_setdir
        main
      ;;
      Open)
        echo "Choose a file to open."
        read lfm_setfile
        xdg-open $lfm_setfile
        main
      ;;
      Copy)
        echo "Choose the file and the location you would like to copy it to."
        read lfm_setfile
        cp $lfm_setfile
        main
      ;;
      MoveFile)
        echo "Choose the file and the new location you would like to move it to, with both of them being separated with a space."
        read lfm_setfile
        mv $lfm_setfile
        main
      ;;
      Index)
        ls -a
        main
      ;;
      CreateFolder)
        echo "Please put in the name of the folder you would like to create."
        read lfm_setdir
        mkdir $lfm_setdir
        main
      ;;
      DeleteFile)
        echo "Select the file you would like to delete. (Without confirmation.) To cancel, just press enter without typing in anything."
        read lfm_setfile
        rm $lfm_setfile
        main
      ;;
      DeleteFolder)
        echo "Select the folder you would like to delete. (Without confirmation.) To cancel, just press enter without typing in anything."
        read lfm_setdir
        rm -rf $lfm_setdir
        main
      ;;
      TouchFile)
        echo "Choose the name of the file..."
        read lfm_setfile
        touch $lfm_setfile
        main
      ;;
      PermSet)
        echo "Choose a file or folder to change the permission"
        read lfm_setany
        echo "Choose the arguments from 'chmod' to set as permission for the file or folder. (Read the manual for chmod for more info)"
        read lfm_setperm
        chmod $lfm_setperm $lfm_setany
        main
      ;;
      CmdLine)
        /bin/sh
        main
      ;;
      Help)
        echo "
        List of commands:
        SetDir
        -Goes to a folder
        Open
        -Opens a file
        MoveFile 
        -Moves/Renames a file
        Copy
        -Copies a file to a location
        Index
        -Shows the list of files inside the directory
        CreateFolder
        -Creates a folder
        DeleteFile
        -Deletes a File
        DeleteFolder
        -Deletes folder
        TouchFile
        -Creates new file
        PermSet
        -Sets permissions for a specific file or folder
        CmdLine
        -Switches to command line mode, run 'exit' to exit.
        Exit
        -That exits out of LinFM."
        main
      ;;
      Exit)
        clear
        exit
      ;;
      *)
        echo "Unrecognized command. Type 'Help' for a list of commands."
        main
      ;;
    esac
}

main
