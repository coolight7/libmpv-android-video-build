rm -rf ./output/
mkdir output

target_home_dir=$(pwd)
docker cp 8f15f61ee85c:$target_home_dir/output/ ./output/