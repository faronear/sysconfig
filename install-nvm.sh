#!/bin/bash

echo "Usage: this-script.sh"

defaultVersion=0.39.0

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v$defaultVersion/install.sh | bash
