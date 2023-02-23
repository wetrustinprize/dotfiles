#!/bin/sh

# Get the directory of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Get the name of this script
SCRIPT_NAME="$(basename -- $0)"

# Get the list of files in the directory
FILES=$(ls $DIR)

# For each file in the directory
for FILE in $FILES
do
    # If the file is a .sh file and is not this script
    if [[ $FILE == *.sh ]] && [[ $FILE != $SCRIPT_NAME ]]
    then
        # Execute the file
        $DIR/$FILE
    fi
done