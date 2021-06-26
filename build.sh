#!/bin/bash
echo "build app"
cd ./golang || exit 1
go mod download
go build -o /usr/local/bin/app
