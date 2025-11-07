# Function pad_string
#
# description: Pad string to ensure max_width characters long
#
# Example usage:
#
# pad_string TEST 65            # Centers (default)
# pad_string -c TEST 65         # Centers (explicit)
# pad_string --center TEST 65   # Centers (explicit long form)
#
# pad_string -l Test 20         # "Test              "
# pad_string -c Test 20         # "       Test       "
# pad_string -r Test 20         # "              Test"
# pad_string -l Test 20 "*"     # "Test**************"
#
function pad_string
    # Parse flags
    argparse l/left c/center r/right -- $argv
    or return

    # Get positional arguments (after flags are removed)
    set -l str $argv[1] # Will be empty string if not provided
    set -l max_width (test (count $argv) -ge 2; and echo $argv[2]; or tput cols)
    set -l pad_char (test (count $argv) -ge 3; and echo $argv[3]; or echo " ")

    # Truncate if string is too long
    set str (string sub -l $max_width -- "$str")

    # Apply alignment
    if set -ql _flag_left
        # Left align: pad on the right
        string pad --right --char "$pad_char" --width $max_width "$str"

    else if set -ql _flag_right
        # Right align: pad on the left 
        # (use negative width or just pad normally)
        string pad --char "$pad_char" --width $max_width "$str"

    else if set -ql _flag_center; or true
        # Center align: manual calculation
        string pad --center --char $pad_char --width $max_width "$str"
    end
end
