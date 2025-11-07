# Create a header with full background color and separate frame/text colors
function header
    # Parse arguments
    argparse e/empty d/double -- $argv
    or return

    set -l message $argv[1]
    set -l frame_color (test (count $argv) -ge 2; and echo $argv[2]; or echo yellow)
    set -l text_color (test (count $argv) -ge 3; and echo $argv[3]; or echo white)
    set -l bg_color (test (count $argv) -ge 4; and echo $argv[4]; or echo normal)

    if set -ql _flag_double
        set -l LENGTH 65
        set -l divider (pad_string -l "" $LENGTH "═")
        set -l p_message (pad_string "$message" $LENGTH)
        set -l empty_line "║"(string repeat -n $LENGTH " ")"║"

        echo
        cecho -b $bg_color $frame_color --bold "╔$divider╗"
        set -ql _flag_empty; and cecho -b $bg_color $frame_color --bold "$empty_line"
        cecho -n -b $bg_color $frame_color --bold "║"
        cecho -n -b $bg_color $text_color --bold "$p_message"
        cecho -b $bg_color $frame_color --bold "║"
        set -ql _flag_empty; and cecho -b $bg_color $frame_color --bold "$empty_line"
        cecho -b $bg_color $frame_color --bold "╚$divider╝"
        echo
    else
        _internal_header $message $frame_color $text_color $bg_color
    end
end

function _internal_header --argument-names message frame_color text_color bg_color
    # You can switch frame to "▒", "▓", "█", "#", "*", etc.
    set -l frame_char "░"

    # Set defaults
    test -z "$frame_color"; and set frame_color yellow
    test -z "$text_color"; and set text_color white
    test -z "$bg_color"; and set bg_color normal #black

    # Get terminal width once
    set -l max_frame_width (math (tput cols) - 2)
    set -l center_width (math $max_frame_width - 2)

    # Pre-compute frame elements
    set -l divider (pad_string -l "" $max_frame_width $frame_char)
    set -l empty_divider "$frame_char"(pad_string "" $center_width)"$frame_char"
    set -l padded_message (pad_string "$message" $center_width)

    echo
    cecho -b $bg_color $frame_color --bold "$divider"
    cecho -b $bg_color $frame_color --bold "$empty_divider"
    cecho -n -b $bg_color $frame_color --bold "$frame_char"
    cecho -n -b $bg_color $text_color --bold "$padded_message"
    cecho -b $bg_color $frame_color --bold "$frame_char"
    cecho -b $bg_color $frame_color --bold "$empty_divider"
    cecho -b $bg_color $frame_color --bold "$divider"
    echo
end
