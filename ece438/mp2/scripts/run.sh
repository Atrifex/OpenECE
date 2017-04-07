#!/bin/bash

# Settings
DEFAULT_TOPO_DIR="./example_topology/"
DEFAULT_TOPO_FILE_PREFIX="test2initcosts"
DEFAULT_TOPO_FILE="topoexample.txt"

# Command line parameters
TOPO_DIR=${1:-$DEFAULT_TOPO_DIR}
TOPO_FILE_PREFIX=${2:-$DEFAULT_TOPO_FILE_PREFIX}
TOPO_FILE=${3:-$DEFAULT_TOPO_FILE}
INIT_COSTS=$(find ${TOPO_DIR} -maxdepth 1 -name "${TOPO_FILE_PREFIX}*" -print)

pkill ls_router
make clean
make

rm -rf ./log/
mkdir ./log/

perl make_topology.pl ${TOPO_DIR}${TOPO_FILE}

echo "\nUsing graphs from ${TOPO_DIR}"

for FILE_NAME in ${INIT_COSTS}; do
    NODE_ID=${FILE_NAME#*${TOPO_FILE_PREFIX}}
    ./ls_router ${NODE_ID} ${FILE_NAME} ./log/log${NODE_ID} &
done

echo ""
