#! /bin/bash -e

if [[ $1 == "--version" || $1 == "--help" ]]; then
    $HELM_PLUGIN_DIR/bin/conftest $1
    exit
fi

render=$(helm template ${1:-.})

echo "$render" | $HELM_PLUGIN_DIR/bin/conftest test - ${@:2}
