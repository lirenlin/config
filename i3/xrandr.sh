#!/bin/bash

set -o pipefail

export DISPLAY=:0.0
export XAUTHORITY=/home/renli01/.Xauthority

function connect(){
  logger -t udev "$2 connected"
  xrandr --output $2 --auto --right-of $1
}

function disconnect(){
  logger -t udev "$1 disconnected"
  xrandr --output $1 --off
}

query=$(xrandr --query)
primary_output=$(echo "${query}" | awk '/ primary / {print $1}')
if [[ $? != 0 ]]; then
  echo "no primary output found!"
  exit 1
fi

connected_output=$(echo "${query}" | awk '!/primary/ && / connected /  {print $1}')
if [[ $? == 0 ]]; then
  connect $primary_output $connected_output
fi

disconnected_output=$(echo "${query}" | awk '/ disconnected / {print $1}')
if [[ $? == 0 ]]; then
  for output in $disconnected_output
  do
    disconnect $output
  done
fi
