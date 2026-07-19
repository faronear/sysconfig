#!/bin/bash

## this file is used to start all the backend services on system startup.

## /usr/bin/npm is not available even if nodejs is apt-installed. Must enable nvm to use npm.
source /root/.nvm/nvm.sh

## add `sudo` to run tasks as root so as to be displayed in `sudo pm2 list`