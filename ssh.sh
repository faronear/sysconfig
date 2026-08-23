#!/bin/bash

echo "Usage: $(basename $0) [host_to_ssh] [cmd_to_run]"

# Ensure jq is installed
if ! command -v jq &> /dev/null; then
    echo "jq is required but not installed. Please install jq and run the script again."
    exit 1
fi

# Path to the settings.json file
SETTINGS_FILE="$HOME/Library/Application Support/Code/User/settings.json"
if [[ ! -f "$SETTINGS_FILE" ]]; then
    SETTINGS_FILE="$HOME/product_产品/.vscode/settings.json"
    if [[ ! -f "$SETTINGS_FILE" ]]; then
        echo "settings.json file not found!"
        exit 1
    fi
fi

# Parse the JSON to get labels and corresponding details
labels=($(jq -r '.["sshfs.configs"][] | .label' "$SETTINGS_FILE"))
hosts=($(jq -r '.["sshfs.configs"][] | .host' "$SETTINGS_FILE"))
ports=($(jq -r '.["sshfs.configs"][] | .port' "$SETTINGS_FILE"))
names=($(jq -r '.["sshfs.configs"][] | .name' "$SETTINGS_FILE"))
usernames=($(jq -r '.["sshfs.configs"][] | .username' "$SETTINGS_FILE"))
passwords=($(jq -r '.["sshfs.configs"][] | .password' "$SETTINGS_FILE"))
privateKeyPaths=($(jq -r '.["sshfs.configs"][] | .privateKeyPath' "$SETTINGS_FILE"))

options=()
prefixes=()
for i in "${!labels[@]}"; do
    option=$(echo "${labels[$i]}" | sed 's/[^[:alnum:]].*//')  # 提取前几个字母和数字
    options+=("$option: ${labels[$i]}")  # 去掉序号，保留前缀和完整label
    prefixes+=("$option")  # 保存前缀
done

# Check if a command-line argument is provided
if [ "$1" != "" ]; then
    # 如果提供了参数，则直接使用这个前缀
    host_to_ssh=$1
else
    echo "Select a target to connect via SSH, or press 0 to exit:"
    echo

    # Display options without numbers
    for opt in "${options[@]}"; do
        echo "$opt"
    done

    echo
    read -p "请输入要连接的主机前缀: " host_to_ssh
fi

echo

# 查找用户输入对应的索引
selected_index=-1
for i in "${!prefixes[@]}"; do
    if [[ "${prefixes[$i]}" == "$host_to_ssh" ]]; then
        selected_index=$i
        break
    fi
done

# 如果没有找到匹配的索引
if [ "$selected_index" -eq -1 ]; then
    echo "无效的选择，请重试。"
    exit 1
fi

label="${labels[$selected_index]}"
name="${names[$selected_index]}"
host="${hosts[$selected_index]}"
port="${ports[$selected_index]}"
username="${usernames[$selected_index]}"
password="${passwords[$selected_index]}"
privateKeyPath="${privateKeyPaths[$selected_index]}"

if [ "$port" = "null" ]; then
    port=22
fi

# 未提供 $2 时，默认在远程执行：若装有 tmux 则 tmux a（附加到已有会话），否则进入交互式 shell
if [ -n "$2" ]; then
    cmd="$2"
else
    cmd='if command -v tmux >/dev/null 2>&1; then tmux a || tmux new; else exec "${SHELL:-sh}"; fi'
fi

echo "::*** Connecting to ${label}"
if [ "$password" != "null" ]; then
    if command -v sshpass &> /dev/null; then
        echo "::*** sshpass -p $password -Y -p $port $username@$host '$cmd'"
        sshpass -p "$password" ssh -Y -p "$port" "$username@$host" "$cmd"
    else
        echo "::*** ssh -Y -p $port $username@$host '$cmd'"
        ssh -Y -p "$port" "$username@$host" "$cmd"
    fi
else
    echo "::*** ssh -Y -p $port $username@$host '$cmd'"
    ssh -Y -p "$port" "$username@$host" "$cmd"
fi