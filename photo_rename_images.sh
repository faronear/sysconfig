#!/bin/bash

# 设置要处理的目录
if [ "$1" ]; then
  base_dir=$1
else
  read -p "Please enter [root directory] to rename images recursively: " target_directory
fi
if [[ -d "$target_directory" ]]; then
  echo Searching in $(realpath $target_directory);
else 
  echo $target_directory is not a folder!
  exit 0
fi;

# Prompt user for input
read -p "Please enter [prod] to rename, or [anything else] to dry run: " user_input


# 查找并遍历所有文件
find "$target_directory" -type f | while read -r file; do
    # 获取文件的原名和扩展名
    dir_name=$(dirname "$file")
    base_name=$(basename "$file")
    extension="${base_name##*.}"

    if [[ "$extension" = "7z" ]] || [[ "$extension" = "DS_Store" ]] || [[ "$extension" = "aae" ]] ||  [[ "$base_name" == *"unkn#own"* ]]; then
      echo === Bypassing $base_name
    elif [[ "$base_name" =~ ^\[?[0-9]{8}[-_][0-9]{6}\]? ]]; then

      #echo === Formatting $base_name

      # 删除文件名中的 [ 和 ]，并将日期时间后的 - 或空格 替换为 #
      new_name=$(echo "$base_name" | sed -E 's/\[?([0-9]{8})[-_]([0-9]{6})\]?[- ]/\1#\2_/g; s/\[?([0-9]{8})[-_]([0-9]{6})\]?/\1#\2/g; s/\[|\]//g')
          
      # 如果重命名后的文件名与原文件名不同，则进行重命名
      if [[ "$base_name" != "$new_name" ]]; then
          if [[ "$user_input" == "prod" ]]; then mv "$file" "$dir_name/$new_name"; fi;
          echo "$base_name -> $new_name"
      fi

    elif [[ ! "$base_name" =~ ^[0-9]{8}#[0-9]{6} ]]; then

      #echo === Add datetime $base_name

      # 获取文件的拍摄日期，假设日期以EXIF元数据存储
      # 需要安装 exiftool
      date_taken=$(exiftool -ExtractEmbedded -d "%Y%m%d#%H%M%S" -DateTimeOriginal -CreationDate -s -s -s "$file")
      
      # 检查日期是否为空和文件名格式
      if [ -n "$date_taken" ]; then
          # 生成新的文件名
          new_name="${date_taken}_${base_name}"
          
          # 重命名文件
          if [[ "$user_input" == "prod" ]]; then mv "$file" "$dir_name/$new_name"; fi;
          echo "$base_name -> $new_name"
      else
          new_name="unkn#own_${base_name}"
          
          # 重命名文件
          if [[ "$user_input" == "prod" ]]; then mv "$file" "$dir_name/$new_name"; fi;
          echo "$base_name -> $new_name"
      fi

    else 

      echo === Unknown $base_name

    fi
done