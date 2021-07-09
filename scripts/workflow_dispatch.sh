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

_BEARER_TOKEN="${BEARER_TOKEN:-"$GH_TOKEN"}"
_BEARER_TOKEN="${_BEARER_TOKEN:-"$GITHUB_TOKEN"}"
_USE_BEARER_TOKEN="${USE_BEARER_TOKEN:-"false"}"
_WGET_BEARER_AUTH="${WGET_BEARER_TOKEN:-""}"
if [[ "$_USE_BEARER_TOKEN" = "true" && -n "$_BEARER_TOKEN" ]]; then
  log_msg "Using bearer token to get remote repo"
  _WGET_BEARER_AUTH="\"Authorization: Bearer ${_BEARER_TOKEN}\""
fi

log_msg "PWD = $PWD"

log_msg "Target URL: ${_TARGET_URL}"
log_msg "Extracting file name ..."
_FILE_NAME=$(basename "${TARGET_URL}")
log_msg "File name: ${_FILE_NAME}"

log_msg "Downloading file ..."
wget -header="$_WGET_BEARER_AUTH" -O "$_FILE_NAME" "$TARGET_URL"
ls -lh
log_msg "Finished downloading file"

log_msg "Extracting file ..."
tar -xzf "$_FILE_NAME" --one-top-level --strip-components=1
ls -lh
log_msg "Finished extracting file"

log_msg "Getting SRC_DIR ..."
_SRC_DIR="${_FILE_NAME%.t*}"
log_msg "SRC_DIR=${_SRC_DIR}"

log_msg "Setting output for GitHub Action ..."
echo "::set-output name=SRC_DIR::${_SRC_DIR}"
log_msg "Completed successfully"
