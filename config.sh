__TIFM_PAGER="less" # [p]eek command
__TIFM_EDITOR="nano" # [e]dit command
__ANGLE_UP_RIGHT="╭"
__ANGLE_UP_LEFT="╮"
__ANGLE_DOWN_RIGHT="╰"
__ANGLE_DOWN_LEFT="╯"
__VBAR="│"
__TIFM_DECO_COLOUR="$CYAN"
__TIFM_DISPLAY() {
    local stat=""
    if [ "$STATUS" == "0" ]; then
        stat="${GREEN}✓$NORMAL"
    else
        stat="${RED}× $STATUS$NORMAL"
    fi
    echo "$GREEN$BRIGHT$PWD$NORMAL $stat"
}
__TIFM_LS_COLOUR="$BLUE"
__TIFM_PROMPT() {
    echo "${CYAN}tifm>"
}