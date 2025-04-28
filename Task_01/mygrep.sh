#!/bin/bash
# check if parameter is --help 
if [[ $1 == "--help" ]]; then
    echo <<EOF
Usage: mygrep [OPTION]... WORD [FILE]...

Search for WORD in FILE or standard input.
   options:
    -n print line number with output lines
    -v invert match (select non-matching lines)
fi
EOF
    exit 0
fi
# Initialize Options n and v 
show_line_numbers=false
invert_match=false
# parse options using getopts => n and v 
while getopts ":nv" opt; do
    case $opt in 
        n)
            show_line_numbers=true ;;
        v)
            invert_match=true ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1 ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1 ;;
    esac
done
# shift the arguments to get the word and file
shift $((OPTIND - 1))
# check that 2 parameters at leatst are passed 
if [[ $# -lt 2 ]]; then
    echo "Please provide a word and file" >&2
    exit 1
fi
search_string="$1"
file_name="$2"
# check if file exists ? 
if [[ ! -f "$file_name" ]]; then
    echo "File $file_name does not exist" >&2
    exit 1
fi
# => build grep command 
grep_options="-i" # make it case insensitive
if [[ $show_line_numbers == true ]]; then
    grep_options+=" -n"
fi
if [[ $invert_match == true ]]; then
    grep_options+=" -v"
fi

# execute grep command 
grep $grep_options "$search_string" "$file_name"
