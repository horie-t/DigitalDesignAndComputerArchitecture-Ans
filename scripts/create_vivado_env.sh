#!/bin/bash

function usage() {
    cat <<EOF
Usage:
    create_vivado_env.sh <prj_name> <dir_name> <part_name>
Example:
     create_vivado_dev.sh 4-0_LED_Lighting 4-0_LED_Lighting xc7a100tcsg324-1

This create directory and Vivado project as following.
  +- <dir_name>/
     +- srcs/
     |  +- constrs/
     |  +- sources/
     +- vivado_prj/
        +- <prj_name>.xpr
EOF
}

if [ $# -lt 1 ]; then
    usage
    exit 1
fi

if [ "$1" = "-h" ]; then
    usage
    exit 0
fi

PRJ_NAME=$1
if [ $# -ge 2 ]; then
    DIR_NAME=$2
else
    DIR_NAME="."
fi

if [ $# -ge 3 ]; then
    PART_NAME=$3
else
    PART_NAME=""
fi

mkdir -p ${DIR_NAME}/srcs/constrs
mkdir -p ${DIR_NAME}/srcs/sources

SCRIPT_DIR=`dirname $BASH_SOURCE`

cp ${SCRIPT_DIR}/../templates/Nexys4DDR.xdc ${DIR_NAME}/srcs/constrs

vivado -mode batch -source ${SCRIPT_DIR}/create_prj.tcl -tclargs ${PRJ_NAME} ${DIR_NAME}/vivado_prj ${PART_NAME}
