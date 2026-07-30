#!/bin/bash

# Update ~/.claude/settings.json with Claude environment settings
settings_file="$HOME/.claude/settings.json"
mkdir -p "$(dirname "$settings_file")"

existing_auth_token=""
existing_base_url=""
existing_model="glm-5.2"

if [ -f "$settings_file" ]; then
  existing_auth_token="$(jq -r '.env.ANTHROPIC_AUTH_TOKEN // empty' "$settings_file" 2>/dev/null)"
  existing_base_url="$(jq -r '.env.ANTHROPIC_BASE_URL // empty' "$settings_file" 2>/dev/null)"
  existing_model="$(jq -r '.env.ANTHROPIC_MODEL // "glm-5.2"' "$settings_file" 2>/dev/null)"
fi

echo "Please provide your Anthropic configuration."
read -s -r -p "Anthropic auth token${existing_auth_token:+ [current value hidden]}: " auth_token
echo
read -r -p "Anthropic base URL${existing_base_url:+ [current: $existing_base_url]}: " base_url
read -r -p "Anthropic model${existing_model:+ [current: $existing_model]}: " model

if [ -z "$auth_token" ]; then
  auth_token="$existing_auth_token"
fi
if [ -z "$base_url" ]; then
  base_url="$existing_base_url"
fi
if [ -z "$model" ]; then
  model="$existing_model"
fi

if [ -z "$auth_token" ] || [ -z "$base_url" ] || [ -z "$model" ]; then
  echo "Missing required values. Please re-run the script and provide all fields." >&2
  exit 1
fi

if [ -f "$settings_file" ]; then
  jq --arg auth_token "$auth_token" \
     --arg base_url "$base_url" \
     --arg model "$model" \
     '.env.ANTHROPIC_AUTH_TOKEN = $auth_token |
      .env.ANTHROPIC_BASE_URL = $base_url |
      .env.ANTHROPIC_MODEL = $model' "$settings_file" > "$settings_file.tmp" && mv "$settings_file.tmp" "$settings_file"
else
  cat > "$settings_file" <<EOF
{
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "$auth_token",
    "ANTHROPIC_BASE_URL": "$base_url",
    "ANTHROPIC_MODEL": "$model"
  }
}
EOF
fi

# Update ~/.claude.json with the new settings: "hasCompletedOnbording:true"
if [ -f "$HOME/.claude.json" ]; then
  jq '.hasCompletedOnboarding = true' "$HOME/.claude.json" > "$HOME/.claude.json.tmp" && mv "$HOME/.claude.json.tmp" "$HOME/.claude.json"
else
  echo '{"hasCompletedOnboarding": true}' > "$HOME/.claude.json"
fi
