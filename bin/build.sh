#!/usr/bin/env bash

root_dir=$(pwd)
docker_user=dleemoo

declare -a all_versions=(rc1 rc2)

if [ -z "$1" ]; then
  declare -a list=(${all_versions[@]})
else
  declare -a list=()
  for i in $@; do
    if [[ " ${all_versions[@]} " =~ " $i " ]]; then
      list=(${list[@]} $i)
    else
      echo "Invalid version: $i" >&2
      exit
    fi
  done
fi

function build() {
  dir=$1
  repo=$2

  cd $dir \
     && docker build --build-arg USER_ID=$UID --rm -t $repo:latest . \
     && docker tag $repo:latest $repo:$(cat VERSION) \
     && echo "$repo:$(cat VERSION) is the lastest" \
     && echo -e "\n============\n" \
     && cd $root_dir
}

if [ ${#list[@]} -gt 0 ]; then
  for i in "${list[@]}"; do
    build "${i}" "${docker_user}/${i}"
  done
fi
