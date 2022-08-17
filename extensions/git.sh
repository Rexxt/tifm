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
        # replace newlines with ,
        gstatus=$(echo "$gstatus" | tr '\n' ',')
        # remove leading and trailing spaces
        gstatus=$(echo "$gstatus" | sed 's/^ *//g;s/ *$//g')
        # remove trailing ,
        gstatus=$(echo "$gstatus" | sed 's/,$//g')
        echo "$BRIGHT$YELLOW(git branch $branch - status: $gstatus)$NORMAL"
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
tifmx.add_long G # for global git commands
tifmx.bind_sub G p git_pull
tifmx.bind_sub G P git_push
tifmx.bind_sub G s git_status
tifmx.bind_sub G a git_add
tifmx.bind_sub G c git_commit