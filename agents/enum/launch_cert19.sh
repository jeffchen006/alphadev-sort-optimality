#!/bin/bash
cd "$(dirname "$0")"
setsid nohup ./run_cert19.sh > logs/cert19.log 2>&1 < /dev/null &
