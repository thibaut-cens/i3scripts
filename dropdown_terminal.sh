#!/bin/bash

# Controls a dropdown terminal for use in i3wm

DISPLAY_WIDTH=1920
TERMINAL_WIDTH=1000
TERMINAL_HEIGHT=400

TERMINAL=kitty # Change this to whatever terminal emulator you want

# Temporary file to record the terminal state
TERMINAL_STATE=/tmp/dropdown_terminal_state

# Adjust the sleep time and step size as necessary to make the animation smooth
STEP_SIZE=10
SLEEP_TIME=0.002

usage() {
    echo "Open/closes a dropdown terminal"
    echo "Usage: ./dropdown_terminal <start|open|close|toggle>"
}

term_launch() {
    $TERMINAL &
    local term_pid=$!
    # Wait for terminal to open
    xdotool search --sync --pid $term_pid > /dev/null
    i3-msg -q mark dropdown # Mark the terminal so we can identify it
    #i3-msg -q mark sticky # Mark the terminal so we can identify it
    i3-msg -q [con_mark=dropdown] move scratchpad
    echo "closed" > $TERMINAL_STATE
}

term_open() {
    if [ "$(cat $TERMINAL_STATE)" == "closed" ]; then
        echo "animating" > $TERMINAL_STATE
        i3-msg -q [con_mark=dropdown] scratchpad show
        i3-msg -q resize set $TERMINAL_WIDTH $TERMINAL_HEIGHT
		echo "($DISPLAY_WIDTH - $TERMINAL_WIDTH)/2 = $(((DISPLAY_WIDTH - TERMINAL_WIDTH)/2))" > /tmp/terminal_size
        i3-msg -q move absolute position $(( (DISPLAY_WIDTH - TERMINAL_WIDTH)/2 )) 0
        i3-msg -q move up $(( TERMINAL_HEIGHT - 1 ))

        for i in `seq 1 $STEP_SIZE $TERMINAL_HEIGHT`; do
            i3-msg -q [con_mark=dropdown] move down $STEP_SIZE
            sleep $SLEEP_TIME
        done
        echo "open" > $TERMINAL_STATE
    fi
}

term_close() {
    if [ "$(cat $TERMINAL_STATE)" == "open" ]; then
        echo "animating" > $TERMINAL_STATE
        i3-msg -q [con_mark=dropdown] focus
        for i in `seq 1 $STEP_SIZE $TERMINAL_HEIGHT`; do
            i3-msg -q [con_mark=dropdown] move up $STEP_SIZE
            sleep $SLEEP_TIME
        done
        i3-msg -q [con_mark=dropdown] scratchpad show
        echo "closed" > $TERMINAL_STATE
    fi
}

term_toggle() {
    case "$(cat $TERMINAL_STATE)" in
        open)   term_close;;
        closed) term_open;;
        *)      ;;
    esac
}

if [ $# != 1 ]; then
    usage
    exit 1
else
    case $1 in
        start)  term_launch;;
        open)   term_open;;
        close)  term_close;;
        toggle) term_toggle;;
        *)      usage; exit 1;;
    esac
fi

