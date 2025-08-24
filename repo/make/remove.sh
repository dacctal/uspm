#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
source $SCRIPT_DIR/../config.sh
source $SCRIPT_DIR/./builds.sh

remove_package

echo "
$Package successfully removed!"
