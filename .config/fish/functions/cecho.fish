# Color echo function with enhanced multi-style support
function cecho
    set -l fg_color normal
    set -l bg_color normal
    set -l style_args
    set -l message_parts
    set -l no_newline false
    set -l skip_next 0
    set -l color_set false
    set -l collecting_message false
    
    for i in (seq (count $argv))
        if test $skip_next -eq 1
            set skip_next 0
            continue
        end
        set -l arg $argv[$i]
        set -l upper_arg (string upper -- $arg)
        
        # Once we start collecting message parts, everything goes into message
        if test "$collecting_message" = true
            set -a message_parts $arg
            continue
        end
        
        switch $arg
            case -n
                set no_newline true
            case -b
                if test (count $argv) -ge (math $i + 1)
                    set bg_color $argv[(math $i + 1)]
                    set skip_next 1
                end
            case --bold --underline --dim --italics
                set -a style_args $arg
            case '*'
                # Check if this is a recognized color/style keyword
                switch $upper_arg
                    case BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE
                        if test "$color_set" = false
                            set fg_color (string lower -- $upper_arg)
                            set color_set true
                        else
                            # If color already set, this starts the message
                            set -a message_parts $arg
                            set collecting_message true
                        end
                    case BOLD
                        set -a style_args --bold
                    case UNDERLINE
                        set -a style_args --underline
                    case DIM
                        set -a style_args --dim
                    case ITALICS
                        set -a style_args --italics
                    case NC NORMAL RESET
                        # These don't do anything but don't start the message either
                    case '*'
                        # Not a recognized keyword, must be message
                        set -a message_parts $arg
                        set collecting_message true
                end
        end
    end
    
    set -l message (string join " " $message_parts)
    
    # Apply colors and styles
    test "$bg_color" != normal; and set_color -b $bg_color
    
    if test (count $style_args) -gt 0
        set_color $style_args $fg_color
    else
        set_color $fg_color
    end
    
    # Print and reset
    printf "%b" "$message"
    set_color normal
    test "$no_newline" = false; and echo
end