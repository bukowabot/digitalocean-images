#!/bin/bash
set -e

function get() {
  curl -s -X GET -H "Content-Type: application/json"  \
    -H "Authorization: Bearer ${DO_TOKEN}"   \
    "https://api.digitalocean.com/v2/$1?page=1&per_page=10000" \
    | jq -e '.' > "$2"
}

function simple() {
  printf "$1$2\n" >> README.md && \
  printf '````yaml\n' >> README.md && \
  jq -e "$2" "$1" | sed 's/\"//g' >> README.md && \
  printf '````\n' >> README.md
}

get "images" "images.json"
get "sizes" "sizes.json"
get "regions" "regions.json"

rm README.md || true
printf "https://bukowa.github.io/digitalocean-images/\n\n" >> README.md
printf "[images](./images.json) ||| " >> README.md
printf "[sizes](./sizes.json) ||| " >> README.md
printf "[regions](./regions.json) |||\n\n" >> README.md

simple "images.json" ".images[].slug"
simple "sizes.json" ".sizes[].slug"
simple "regions.json" ".regions[].slug"

simple "images.json" "."
simple "sizes.json" "."
simple "regions.json" "."
