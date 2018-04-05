#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BIN_DIR="$SCRIPT_DIR"/../bin

"$BIN_DIR"/d++ -of"$BIN_DIR/$1" "$SCRIPT_DIR/run/$1.dpp" -L-lcurl -L-lnanomsg
"$BIN_DIR/$1"
