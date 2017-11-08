#!/bin/bash

endpoint="${PB_ENDPOINT:-https://ptpb.pw}"
jq_args="${PB_JSON:--r .url}"
private="${PB_PRIVATE:-0}"


pb_ () {
  local command filename

  filename="${1:--}"
  extension="${2:-}"

  shift 2

  curl -sF "c=@$filename" -F "f=-$extension" -F "p=$private" \
       -H 'accept: application/json' "$@" "$endpoint" | jq $jq_args
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
    clipboard)
      shift
      pb_clipboard "$@"
      ;;
    *)
      pb_ "$@"
      ;;
  esac
}

eval " ${0##*/}" "$@"
