#!/bin/bash -e

# Проверка наличия аргумента
if [ "$#" -ne 1 ]; then
    echo "Error! No argument"
    exit 1
fi

START_FILE="$1"
TEMP_DIR=$(mktemp -d)
FILE_DIRECTORY=$(dirname "$START_FILE")
	cp "$START_FILE" "$TEMP_DIR/"
	cd "$TEMP_DIR"

exit_signal() {
    rm -rf "$TEMP_DIR"
}
trap exit_signal EXIT HUP INT QUIT PIPE TERM


# Получение имени выходного файла из комментария &Output: в компилируемом файле
create_out_file() {

OUTPUT_FILE=$(grep -o "&Output::[^ ]*" "$START_FILE" | sed 's/&Output::\(.*\)/\1/')
    # Если выходной файл отсутствует:
    if [ -z "$OUTPUT_FILE" ]; then
        echo "Error! Output file is abscent or incorrect"
        exit 3
    fi
}
create_out_file


compile_file() {
	
    # Компиляция cpp
    if [ "${START_FILE##*.}" = "cpp" ]; then
        g++ "$START_FILE" -o "$TEMP_DIR/$OUTPUT_FILE"
    else
        echo "Error! Incorrect file type"
        exit 4
    fi
	cd "$FILE_DIRECTORY"
	
}

compile_file

# Перемещение выходного файла рядом с исходным файлом
push_out_file() {
TARGET_DIRECTORY="/home/natali/UnixLab/lab1"
TEMP_OUTPUT_FILE="$TEMP_DIR/$OUTPUT_FILE"

    # Переместить выходной файл в целевую директорию
    mv "$TEMP_OUTPUT_FILE" "$TARGET_DIRECTORY/$OUTPUT_FILE"

    rm -rf "$TEMP_DIR"
    echo "Success! Output: $(pwd)/$OUTPUT_FILE"
}

push_out_file