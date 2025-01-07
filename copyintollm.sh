#!/bin/zsh
tree_output=""
file_output=""
last_dirs=()

read content

for path in "$@"; do
    # Get all path components
    dir=$(/usr/bin/dirname "$path")
    file=$(/usr/bin/basename "$path")
    
    # Split directory path into components
    IFS='/' read -A dir_parts <<< "$dir"
    indent=""
    current=""
    
    # Process each directory in the path
    for part in $dir_parts; do
        if [[ -n $part ]]; then
            # output+="/$part"
            current+="/$part"
            if [[ ! " ${last_dirs[@]} " =~ " ${current} " ]]; then
                tree_output+="\n${indent}├── $part"
                last_dirs+=($current)
            fi
            indent+="    "
        fi
    done
    
    # Add the file at the appropriate indent level
    tree_output+="\n${indent}└── $file"
    if [ $content = "1" ]; then
        file_output+="$file content:\n $(/bin/cat "$path")\n"
    fi
done

echo "$tree_output\n\n\n$file_output" | /usr/bin/pbcopy

#echo "$output"
