#!/bin/bash

function usage() {
    echo <<EOF
Usage:
    eqn2png FILE
    eqn2png > FILE.png

DISCRIPTION:
    Convert Tex equation to png image file.
    If FILE is not specified, read equation from stdin, output png data to stdout.

Example:
    eqn2png NAND.eqn

    Where
    $ cat NAND.eqn
    Y = \overline{AB}

EOF
}

if [ $# -eq 1 ]; then
    EQN_FILE="$1";
else
    EQN_FILE=`mktemp --suffix=.eqn`
    NO_FILE="Y"
    cat >${EQN_FILE}
fi

if [ "$1" = "-h" ]; then
    usage
    exit 0
fi

FILE_BASENAME="${EQN_FILE%.*}"

EQUATION=`cat ${EQN_FILE}`

# Texファイルを作成
cat <<EOF >${FILE_BASENAME}.tex
\documentclass{article}
\pagestyle{empty}
\begin{document}
\begin{eqnarray*}
$EQUATION
\end{eqnarray*}
\end{document}
EOF

# Texファイルをコンパイルしてdviファイルを作成
platex -interaction=nonstopmode -output-directory=`dirname ${FILE_BASENAME}.tex` ${FILE_BASENAME}.tex >/dev/null

# dviファイルからpngファイルへ変換
dvipng -q -D 144 -T tight -o ${FILE_BASENAME}.png ${FILE_BASENAME}.dvi >/dev/null

if [ "$NO_FILE" = "Y" ]; then
    cat ${FILE_BASENAME}.png
    rm ${FILE_BASENAME}.*
fi


