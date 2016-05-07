last_key=""
last_value=""
# read line by line
while read -r line; do
    # split at = into pairs
    IFS="=" read -r key value <<< "$line"
    # Check if key contains "New" and the value from the line before is
    # different from the value in the current line. Note: uses bash
    # extended test ([[]]), use grep for posix shell.
    if [[ "$key" == *New* ]] && [ "$last_value" != "$value" ]; then
        echo "warning: $last_value != $value"
        exit 1 # omit if you want to find all differences
    fi
    # save value, key for the next iteration
    last_key="$key"
    last_value="$value"
done < "$1"
