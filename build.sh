#!/bin/bash
echo "build app"
cd ./golang || exit 1
ln -s "$GITHUB_WORKSPACE" .
go mod download
go build -o app
