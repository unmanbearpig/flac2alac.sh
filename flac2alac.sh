#!/bin/sh

# required flac, ffmpeg and gnu-sed on OS X
# for linux replace SED="gsed" with SED="sed"

function convert_file {
    INPUT_FILE=$1
    OUTPUT_FILE="`basename "$1" .flac`.m4a"

    SED="gsed"

    echo n|ffmpeg  -i "$1" \
        -metadata title="$(metaflac --show-tag=TITLE "$1" | $SED 's/title=//gI')" \
        -metadata artist="$(metaflac --show-tag=ARTIST "$1" | $SED 's/artist=//gI')" \
        -metadata album="$(metaflac --show-tag=ALBUM "$1" | $SED 's/album=//gI')" \
        -metadata year="$(metaflac --show-tag=DATE "$1" | $SED 's/date=//gI')" \
        -metadata track="$(metaflac --show-tag=TRACKNUMBER "$1" | $SED 's/tracknumber=//gI')" \
        -metadata genre="$(metaflac --show-tag=GENRE "$1" | $SED 's/genre=//gI')" \
        -acodec alac "`basename "$1" .flac`.m4a"
}


function convert_file_to_same_dir {
    filename=$@

    echo "converting file '$filename'"

    dir=${filename%/*}
    file=${filename##*/}

    cd "$dir"
    pwd
    ls -l "$file"

    convert_file "$file"

    cd -

    echo
    echo
}

function convert_dir {
    IFS=$'\n'
    for file in read $(find "$@" -name "*.flac")
    do
        convert_file_to_same_dir $file
    done
}

convert_dir $@
