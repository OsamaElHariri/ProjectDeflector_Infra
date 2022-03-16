#!/bin/bash

script_dir=$(dirname $(realpath $0))
parent_dir=$(dirname $script_dir)

rm -rf -- $script_dir/script_temp/

mkdir $script_dir/script_temp
mkdir $script_dir/script_temp/nginx

cp $parent_dir/docker-compose.yaml $script_dir/script_temp/docker-compose.yaml
cp $parent_dir/nginx/nginx.conf $script_dir/script_temp/nginx/nginx.conf


array=($(echo $1 | tr "," "\n"))
for i in "${array[@]}"
do
	regex="#(\s)+$i start.*(\s)*#(\s)+$i end"
	gawk -i inplace -v RS="" "{gsub(/$regex/, \"\")}1" $script_dir/script_temp/docker-compose.yaml
done

docker-compose -f $script_dir/script_temp/docker-compose.yaml up --remove-orphans