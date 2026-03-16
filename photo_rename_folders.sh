#!/bin/bash

# 指定目录
if [ "$1" ]; then
  base_dir=$1
else
  read -p "Please enter [root directory] to rename 1st level subfolders: " base_dir
fi
if [[ -d "$base_dir" ]]; then
  base_dir=$(realpath $base_dir)
  echo Searching in $base_dir;
else 
  echo not a folder!
  exit 0
fi;

# Prompt user for input
read -p "Please enter [prod] to rename, or [anything else] to dry run: " user_input

# 遍历所有目录
for dir in "$base_dir"/*/; do
    # 提取目录名称，去掉末尾的斜杠
    dir_name=$(basename "$dir")
    
    # 调试输出：检查目录名称
    echo "Processing: $dir_name"
    
    # 使用正则表达式提取前缀（可选）、年份、月份和日期
    if [[ $dir_name =~ ^([^,]*),?\ ([0-9]{4})年([0-9]{1,2})月([0-9]{1,2})日$ ]]; then
        # 有前缀的情况
        prefix="${BASH_REMATCH[1]}"
        year="${BASH_REMATCH[2]}"
        month=$(printf "%02d" "${BASH_REMATCH[3]}")
        day=$(printf "%02d" "${BASH_REMATCH[4]}")

    elif [[ $dir_name =~ ^([0-9]{4})年([0-9]{1,2})月([0-9]{1,2})日$ ]]; then
        # 没有前缀的情况
        prefix=""
        year="${BASH_REMATCH[1]}"
        month=$(printf "%02d" "${BASH_REMATCH[2]}")
        day=$(printf "%02d" "${BASH_REMATCH[3]}")
        
    else
        echo "Skipping: $dir_name (not matching expected format)"
        continue
    fi
    
    # 创建新的目录名称
    new_name="${year}${month}${day}"
    
    if [[ -n "$prefix" ]]; then
        new_name="${new_name}_${prefix// /_}"  # 替换空格为下划线
    fi
    
    # 重命名目录
    if [[ "$user_input" == "prod" ]]; then mv "$dir" "$base_dir/$new_name"; fi;
    echo "Renamed: $dir_name -> $new_name"
done