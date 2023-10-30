#!/bin/bash -e

# Проверка наличия аргумента
if [ "$#" -ne 1 ]; then
    echo "Error! No argument"
    exit 1
fi

START_FILE="$1"
TEMP_DIR=$(mktemp -d)

exit_signal() {
    # Обработка сигналов для удаления временной директории
    trap 'rm -rf "$TEMP_DIR"' EXIT HUP INT QUIT PIPE TERM
}
exit_signal

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

    # Если компиляция не удалась:
    if [ $? -ne 0 ]; then
        echo "Error! Compilation failed"
        exit 5
    fi
}

compile_file

# Перемещение выходного файла рядом с исходным файлом
push_out_file() {
    mv "$TEMP_DIR/$OUTPUT_FILE" "$(dirname "$START_FILE")/$OUTPUT_FILE"

    echo "Success! Output: $(dirname "$START_FILE")/$OUTPUT_FILE"
}

push_out_file