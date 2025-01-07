#!/bin/zsh

current_dir=""
declare -A dir_levels

while IFS= read -r line; do
    echo "Processing: '$line'"
    [[ -z "$line" || "$line" =~ "userStyle" ]] && continue
    indent=$(echo "$line" | awk '{match($0, /^ */); print RLENGTH / 4}')
    clean_line=$(echo "$line" | sed 's/[└├─│]//g' | tr -d ' ' | sed 's/%*$//')
    echo "Cleaned to: '$clean_line'"
    if [[ "$line" =~ "└" || "$line" =~ "├" ]]; then
        if [[ "$clean_line" =~ /$ ]]; then
            dir_path="$current_dir/$clean_line"
            echo "Creating directory: $dir_path"
            mkdir -p "$dir_path"
            dir_levels[$indent]="$dir_path"
            current_dir="$dir_path"
        else
            file_path="$current_dir/$clean_line"
            echo "Creating file: $file_path"
            touch "$file_path"
        fi
    else
        echo "Setting dir: $clean_line"
        current_dir="$clean_line"
        mkdir -p "$clean_line"
        dir_levels[$indent]="$clean_line"
    fi
done

echo "Done."
