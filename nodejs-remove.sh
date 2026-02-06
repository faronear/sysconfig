#!/bin/bash

echo "Usage: $(basename $0) [VERSION]"

sudo rm -fr /usr/local/bin/node
sudo rm -fr /usr/local/bin/npm
sudo rm -fr /usr/local/lib/node_modules
sudo rm -fr /usr/local/include/node