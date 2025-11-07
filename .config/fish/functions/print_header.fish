function print_header
    # Parse arguments
    argparse e/empty -- $argv
    or return

    set -l message $argv[1]
    set -l frame_color (test (count $argv) -ge 2; and echo $argv[2]; or echo yellow)
    set -l text_color (test (count $argv) -ge 3; and echo $argv[3]; or echo white)
    set -l bg_color (test (count $argv) -ge 4; and echo $argv[4]; or echo normal)
    set -l show_empty (set -q _flag_empty; and echo true; or echo false)

    _print_box "$message" $frame_color $text_color $bg_color $show_empty
end

function _print_box
    set -l message $argv[1]
    set -l frame_color $argv[2]
    set -l text_color $argv[3]
    set -l bg_color $argv[4]
    set -l show_empty $argv[5]

    set -l divider (pad_string -l "" 65 "═")
    set -l p_message (pad_string "$message" 65)

    echo
    _print_line "╔$divider╗" $bg_color $frame_color
    test "$show_empty" = true; and _print_line "║                                                               ║" $bg_color $frame_color
    _print_content_line "$p_message" $bg_color $frame_color $text_color
    test "$show_empty" = true; and _print_line "║                                                               ║" $bg_color $frame_color
    _print_line "╚$divider╝" $bg_color $frame_color
    echo
end

function _print_line
    cecho -b $argv[2] $argv[3] --bold "$argv[1]"
end

function _print_content_line
    cecho -n -b $argv[2] $argv[3] --bold "║"
    cecho -n -b $argv[2] $argv[4] --bold "$argv[1]"
    cecho -b $argv[2] $argv[3] --bold "║"
end
