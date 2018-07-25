#!/bin/bash

endpoint="${PB_ENDPOINT:-https://ptpb.pw}"
jq_args="${PB_JSON:--r .url}"
private="${PB_PRIVATE:-0}"
clipboard="${PB_CLIPBOARD}"
clipboard_tool="${PB_CLIPBOARD_TOOL:-xclip}"

pb_ () {
  local filename extension

  filename="${1:--}"
  extension="${2:-}"

  shift 2

  data=$(curl -sF "c=@$filename" -F "f=-$extension" -F "p=$private" \
           -H 'accept: application/json' "$@" "$endpoint" | jq $jq_args)
  if [[ ! -z $clipboard ]]; then
    printf "${data}" | "${clipboard_tool}"
  fi
  echo "${data}"
}

pb_png () {
  maim -s | pb_ - .png
}

pb_gif () {
  capture gif - | pb_ - .gif
}

pb_webm () {
  capture webm - | pb_ - .webm
}

pb () {
  local command="$1"

  case $command in
    png)
      shift
      pb_png "$@"
      ;;
    gif)
      shift
      pb_gif "$@"
      ;;
    webm)
      shift
      pb_webm "$@"
      ;;
    private)
      shift
      private=1
      pb_ "$@"
      ;;
    *)
      pb_ "$@"
      ;;
  esac
}

eval " ${0##*/}" "$@"
