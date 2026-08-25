#!/bin/bash

echo "::*** Enter Pi precision to calculate (leave blank for default to 5000): "
read -p "***:: " precision
if [ ! $precision ]; then
  precision=5000
fi

time echo "scale=$precision; 4*a(1)" | bc -l -q
