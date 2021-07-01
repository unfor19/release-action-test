#!/bin/bash
cd ./golang || exit 1

if [[ "$GOOS" = "windows" ]]; then
    _EXT=".exe"
fi

go build -o "app${_EXT}"
