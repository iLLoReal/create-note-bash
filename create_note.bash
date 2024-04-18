write_note() {
    fileToWrite=$1
    cat ~/bin/scripts/template >$fileToWrite
}

safety_confirm() {
    confirm=$1
    fileName=$2
    if [ "$confirm" = "y" ]; then
        echo ""
        echo "\"$fileName\" will be overwritten. Are you sure ?(y/n)"
        read -ns 1 finalConfirm
        if [ "$finalConfirm" = "n" ]; then
            echo ""
            echo "Canceled."
            return 1
        fi
    else
        echo ""
        echo "Canceled"
        return 1
    fi
    return 0
}

build_fileName() {
    fileName=$(LC_TIME="C" date "+%A_%d" | tr '[:upper:]' '[:lower:]')
    if [ -z "$1" ]; then
        parsedArg="todo"
    else
        parsedArg=$(echo $1 | tr 'âàäêéèëîìïôòöûùü [:upper:]' 'aaaeeeeiiiooouuu-[:lower:]')
    fi
    echo "$fileName"_"$parsedArg.txt"
}

check_fileExists() {
    ls "$finalFileName" >/dev/null 2>&1
    echo $?
}

write_file() {
    finalFileName=$(build_fileName $1)

    if [ $(check_fileExists $finalFileName) -eq 0 ]; then
        echo "file already exist. Proceed ?(y/n)"
        read -ns 1 confirm
        safety_confirm $confirm $finalFileName
        if [ $? -eq 0 ]; then
            echo ""
            echo "Overwritten."
            write_note "$finalFileName"
            echo ""
        fi
    else
        echo "Creating note"
        write_note "$finalFileName"
    fi
}

write_file $1
