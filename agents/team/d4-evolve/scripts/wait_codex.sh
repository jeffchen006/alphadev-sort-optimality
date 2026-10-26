#!/bin/bash
while [ $(ps -eo args | grep -c "^codex exec resume") -gt 0 ]; do sleep 60; done
tail -c 3000 "$1"
