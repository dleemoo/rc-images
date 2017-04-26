#!/usr/bin/env bash

declare -a all_versions=(rc1 rc2)

for i in "${all_versions[@]}"; do
  docker push dleemoo/${i}
  docker push dleemoo/${i}
done
