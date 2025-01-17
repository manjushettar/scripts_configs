#!/bin/zsh

# Ensure empty globs don't produce an error message
setopt nullglob

# Global arrays and variables to track state
tree_output=""
file_output=""
last_dirs=()

# Recursive function to build tree structure
function build_tree() {
    local item="$1"
    local indent="$2"

    if [ -d "$item" ]; then
        # If item is a directory
        if [[ ! " ${last_dirs[@]} " =~ " ${item} " ]]; then
            tree_output+="
${indent}├── $(/usr/bin/basename "$item")"
            last_dirs+=("$item")
        fi
        
        # New indent for children
        local child_indent="${indent}│   "

        # Process each child in the directory
        for child in "$item"/*; do
            build_tree "$child" "$child_indent"
        done
    else
        # If item is a file
        tree_output+="
${indent}└── $(/usr/bin/basename "$item")"
        if [[ $content == "1" ]]; then
            file_output+="$(/usr/bin/basename "$item") content:
$(/bin/cat "$item")

"
        fi
    fi
}

# Read if content should be included
read content

# Process each argument passed to the script
for path in "$@"; do
    if [ -e "$path" ]; then
        build_tree "$path" ""
    else
        echo "Error: $path does not exist" >&2
    fi
done

# Combine tree and file content, copy to clipboard
echo "$tree_output

$file_output" | /usr/bin/pbcopy


