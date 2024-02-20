# git.sh
# adds git support to tifm

__tifmgit_in_repo=false
is_git_repo() {
    # check if current directory is a git repo
    git rev-parse --is-inside-work-tree &> /dev/null
}

git.init() {
    # check if current directory is a git repo
    if is_git_repo; then
        __tifmgit_in_repo=true
    fi
}

git.nav() {
    if is_git_repo; then
        __tifmgit_in_repo=true
    fi
}

git.display() {
    # display git status
    if $__tifmgit_in_repo; then
        local branch=$(git rev-parse --abbrev-ref HEAD)
        local gstatus=$(git status --porcelain)
        # remove leading and trailing spaces
        gstatus=$(echo "$gstatus" | sed 's/^ *//g;s/ *$//g')
        # remove leading and trailing newlines
        gstatus=$(echo "$gstatus" | sed 's/^\n//g;s/\n$//g')
        if [[ -z "$gstatus" ]]; then
            gstatus=0
        else
            # replace with count
            gstatus=$(echo "$gstatus" | wc -l)
        fi
        local modif="modif"
        # if modif > 1, replace with "modifs"
        if [[ "$gstatus" -gt 1 ]]; then
            modif="modifs"
        fi
        echo "$BRIGHT$YELLOW(git branch $branch - status: $gstatus $modif)$NORMAL"
    fi
}

git_pull() {
    # pull from remote
    git pull
}
git_push() {
    # push to remote
    git push
}
git_status() {
    # display git status
    if $__tifmgit_in_repo; then
        local branch=$(git rev-parse --abbrev-ref HEAD)
        local gstatus=$(git status --porcelain)
        # colouring
        # M file -> ${BLUE}M${NORMAL}file
        gstatus=$(echo "$gstatus" | sed "s/ M /${BLUE}M${NORMAL} /g")
        # A file -> ${GREEN}A${NORMAL}file
        gstatus=$(echo "$gstatus" | sed "s/ A /${GREEN}A${NORMAL} /g")
        # D file -> ${RED}D${NORMAL}file
        gstatus=$(echo "$gstatus" | sed "s/ D /${RED}D${NORMAL} /g")
        # R file -> ${YELLOW}R${NORMAL}file
        gstatus=$(echo "$gstatus" | sed "s/ R /${YELLOW}R${NORMAL} /g")
        # C file -> ${LIME_YELLOW}C${NORMAL}file
        gstatus=$(echo "$gstatus" | sed "s/ C /${LIME_YELLOW}C${NORMAL} /g")
        # U file -> ${POWDER_BLUE}U${NORMAL}file
        gstatus=$(echo "$gstatus" | sed "s/ U /${POWDER_BLUE}U${NORMAL} /g")
        # ? file -> ${MAGENTA}?${NORMAL}file
        gstatus=$(echo "$gstatus" | sed "s/ ? /${MAGENTA}?${NORMAL} /g")
        # ! file -> ${CYAN}!${NORMAL}file
        gstatus=$(echo "$gstatus" | sed "s/ ! /${CYAN}!${NORMAL} /g")
        # if gstatus is empty, replace it with "nothing to commit"
        if [ -z "$gstatus" ]; then
            gstatus="nothing to commit"
        fi
        echo -e "$BRIGHT${YELLOW}git branch $branch$NORMAL\n$gstatus"
    fi
}
git_add() {
    # add all files to git
    git add .
}
git_commit() {
    # commit all files to git
    read -p "Commit message: " message
    git commit -m "$message"
}
git_diff() {
    # show diff between current and previous commit
    git diff
}
git_log() {
    # show log of all commits
    git log
}
git_log_last() {
    # show log of last commit
    git log -1
}
git_full() { # pull, add, commit, push
    git_pull
    git_add
    git_commit
    git_push
}
git_view_remote() {
    git remote -v
}
git_clone() {
    read -p "Git URL: " url
    git clone "$url"
}
tifmx.add_long G # for global git commands
tifmx.bind_sub G C git_clone
tifmx.bind_sub G p git_pull
tifmx.bind_sub G P git_push
tifmx.bind_sub G s git_status
tifmx.bind_sub G a git_add
tifmx.bind_sub G c git_commit
tifmx.bind_sub G d git_diff
tifmx.bind_sub G l git_log
tifmx.bind_sub G L git_log_last
tifmx.bind_sub G "*" git_full
tifmx.bind_sub G r git_view_remote
tifmx.add_help G "git commands integration ([C]lone, [p]ull, [P]ush, [s]tatus, [a]dd, [c]ommit, [d]iff, [l]og, [L]og last, [*]full, [r]emote)"