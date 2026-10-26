#!/bin/bash
cd "$(dirname "$0")"
setsid nohup ./memguard.sh > /dev/null 2>&1 < /dev/null &
