#!/bin/bash
set -e
set -o pipefail

### Functions
error_msg(){
  local msg="$1"
  local code="${2:-"1"}"
  echo -e "[ERROR] $(date) :: [CODE=$code] $msg"
  exit "$code"
}


log_msg(){
  local msg="$1"
  echo -e "[LOG] $(date) :: $msg"
}

_TARGET_URL="${TARGET_URL:-""}"
if [[ "$_TARGET_URL" = "" ]]; then
    error_msg "Must provide target-url"
fi

log_msg "Target URL: ${_TARGET_URL}"
log_msg "Extracting file name ..."
_FILE_NAME=$(basename "${TARGET_URL}")
log_msg "File name: ${_FILE_NAME}"

log_msg "Downloading file ..."
wget -O "$_FILE_NAME" "$TARGET_URL"
log_msg "Finished downloading file"

log_msg "Extracting file ..."
tar -xzvf "$_FILE_NAME"
log_msg "Finished extracting file"

log_msg "Getting SRC_DIR ..."
_SRC_DIR=$(tar -tzf "$_FILE_NAME" | head -1 | cut -f1 -d"/")
log_msg "SRC_DIR=${_SRC_DIR}"

log_msg "Setting output for GitHub Action ..."
echo "::set-output name=src-dir::${_SRC_DIR}"
log_msg "Completed successfully"