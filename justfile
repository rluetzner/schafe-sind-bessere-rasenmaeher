default:
  @just --list

run-hugo:
  #! /usr/bin/env bash
  set -euxo pipefail
  xdg-open http://localhost:1313
  hugo server -D

convert-all-to-webp type:
  #! /usr/bin/env bash
  set -euxo pipefail

  if ! type cwebp &> /dev/null; then
    echo "webp is not installed"
    exit 1
  fi

  for file in $(find "{{invocation_directory()}}/" -name '*.{{type}}'); do
    echo "Converting $file"
    PATH_WITHOUT_SUFFIX=$(echo $file | sed "s/^\(.*\)\..*$/\1/")
    cwebp "$file" -o "$PATH_WITHOUT_SUFFIX.webp"
    rm "$file"
  done

resize-images type min-size:
  #! /usr/bin/env bash
  set -euxo pipefail

  if ! type convert &> /dev/null; then
    echo "imagemagick is not installed"
    exit 1
  fi

  for file in $(find "{{invocation_directory()}}/" -name '*.{{type}}'); do
    echo "Converting $file"
    BN=$(basename "$file" ".{{type}}")
    DN=$(dirname "$file")
    convert -resize {{min-size}}x{{min-size}}^ "$file" "$DN/$BN.new.{{type}}"
    mv "$DN/$BN.new.{{type}}" "$file"
  done

fix-images:
  #! /usr/bin/env bash
  set -euxo pipefail

  just resize-images jpg 1024 &&
  just convert-all-to-webp jpg
