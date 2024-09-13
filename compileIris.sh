#!/bin/bash

keyboard=keebio/iris_ce/rev1
iris_folder=./keyboards/keebio/iris_ce/keymaps/qwertyIris
keymap="${iris_folder##*/}"

# flags
do_compile=true
do_json2c=true

# Using getopts to parse options
while getopts "cj" option; do
    case $option in
        c)  # Only compile, skip json2c
            do_json2c=false
            ;;
        j)  # Only json2c, skip compile
            do_compile=false
            ;;
        \?) # Invalid option
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

main () {
    local folder="$iris_folder"
    
    if [ "$do_json2c" = true ]; then
        # Call select_json_file to get the JSON file
        local json_file=$(select_json_file "$folder" | tail -n1)
        echo "$json_file"
        json_2_keymap "$folder" "$json_file"
    fi

    if [ "$do_compile" = true ]; then
        check_and_append "${folder}/keymapAchordion.c" "${folder}/keymap.c"
        compile_qmk
    fi
}

select_json_file() {
    # Specify the folder to scan for JSON files
    local folder="$1"

    # Find all JSON files in the specified folder
    json_files=($(find "$folder" -type f -name "*.json"))

    # Check if there are any JSON files found
    if [ ${#json_files[@]} -eq 0 ]; then
        echo "No JSON files found in $folder"
        return 1
    fi

    # List the found JSON files and prompt for selection
    echo "Select a JSON file:"
    select file in "${json_files[@]}"; do
        if [ -n "$file" ]; then
            echo "Selected JSON file:"
            echo "$file"
            return 0
        else
            echo "Invalid selection, try again."
        fi
    done
}

# Function to run an arbitrary command on the selected JSON file
json_2_keymap() {
    local folder="$1"
    local json_file="$2"

    # Check if a file was selected
    if [ -z "$json_file" ]; then
        echo "No file selected or no files found."
        return 1
    fi

    qmk json2c "$json_file" -o "$folder/keymap.c"
}

compile_qmk() {
    qmk compile -kb "$keyboard" -km "$keymap"
}

# ------ Utils ------

check_and_append() {
    local source_file=$1
    local target_file=$2

    # Check if source file exists
    if [ ! -f "$source_file" ]; then
        echo "Source file '$source_file' does not exist."
        return 1
    fi

    # Check if target file exists (optional, will create if it doesn't exist)
    if [ ! -f "$target_file" ]; then
        echo "Target file '$target_file' does not exist."
        return 1
    fi

    # Remove newline characters and store source content in a variable.
    # This is done since grep does not work with newlines, so putting all the content
    # in a single line to search for it.
    local source_content=$(tr -d '\n' < "$source_file")
    # Check if the source content already exists in the target file (ignoring newlines)
    if ! grep -qF "$source_content" <(tr -d '\n' < "$target_file"); then
        # Append the source content to the target file if not found
        cat "$source_file" >> "$target_file"
        echo "Content appended to $target_file."
    else
        echo -e "\nContent already exists in $target_file, skipping append\n"
    fi
}

main