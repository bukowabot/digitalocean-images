#!/bin/bash
set -e

function get() {
  curl -s -X GET -H "Content-Type: application/json"  \
    -H "Authorization: Bearer ${DO_TOKEN}"   \
    "https://api.digitalocean.com/v2/$1?page=1&per_page=10000" \
    | jq -S -e '.' > "$2"
}

function simple() {
  printf "$1$2\n" >> README.md && \
  printf '````yaml\n' >> README.md && \
  jq -S -e "$2" "$1" | sed 's/\"//g' >> README.md && \
  printf '````\n' >> README.md
}

get "images" "images.json"
get "sizes" "sizes.json"
get "regions" "regions.json"
get "kubernetes/options" "kubernetes.json"

rm README.md || true
printf "\n\n" >> README.md

printf "[images](./images.json)         \n\n " >> README.md
printf "[sizes](./sizes.json)           \n\n " >> README.md
printf "[regions](./regions.json)       \n\n" >> README.md
printf "[kubernetes](./kubernetes.json) \n\n" >> README.md

simple "images.json" ".images[].slug"
simple "sizes.json" ".sizes[].slug"
simple "regions.json" ".regions[].slug"
simple "kubernetes.json" ".options.versions[].kubernetes_version"
#simple "images.json" "."
#simple "sizes.json" "."
#simple "regions.json" "."
