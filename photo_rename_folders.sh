#!/bin/bash

# 指定目录
if [ "$1" ]; then
  base_dir=$1
else
  read -p "Please enter [root directory] to rename 1st level subfolders: " base_dir
fi
if [[ -d "$base_dir" ]]; then
  base_dir=$(realpath "$base_dir")
  echo Searching in "$base_dir";
else 
  echo not a folder!
  exit 0
fi;

# Prompt user for input
read -p "Please enter [prod] to rename, or [anything else] to dry run: " user_input

# 遍历所有目录
find "$base_dir" -type d | while read -r fullpath; do
    # 提取目录名称，去掉末尾的斜杠
    dir_name=$(dirname "$fullpath")
    folder_name=$(basename "$fullpath")
    
    # 调试输出：检查目录名称
    #echo "Processing: $folder_name"
    
    # 使用正则表达式提取前缀（可选）、年份、月份和日期
    if [[ $folder_name =~ ^([^,]*),?\ ([0-9]{4})年([0-9]{1,2})月([0-9]{1,2})日$ ]]; then
        # 有前缀的情况
        intro="${BASH_REMATCH[1]}"
        year="${BASH_REMATCH[2]}"
        month=$(printf "%02d\n" "$((10#${BASH_REMATCH[3]}))")
        day=$(printf "%02d\n" "$((10#${BASH_REMATCH[4]}))")

    elif [[ $folder_name =~ ^.?([0-9]{4})[年-]([0-9]{1,2})[月-]([0-9]{1,2})日?\]?_?\ ?(.*)$ ]]; then
        # 没有前缀的情况
        year="${BASH_REMATCH[1]}"
        month=$(printf "%02d\n" "$((10#${BASH_REMATCH[2]}))")
        day=$(printf "%02d\n" "$((10#${BASH_REMATCH[3]}))")
        intro="${BASH_REMATCH[4]}"

    else
        echo "Skip: $folder_name"
        continue
    fi
    
    # 创建新的目录名称
    new_name="${year}${month}${day}"
    
    if [[ -n "$intro" ]]; then
        new_name="${new_name}_${intro// /_}"  # 替换空格为下划线
    fi
    
    # 重命名目录
    if [[ "$user_input" == "prod" ]]; then mv "$fullpath" "$dir_name/$new_name"; fi;
    echo "Renamed: $folder_name"
    echo "    >>>> $dir_name/$new_name"
done