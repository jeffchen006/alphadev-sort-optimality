#!/bin/bash
cd "$(dirname "$0")"
setsid nohup ./supervise19.sh > /dev/null 2>&1 < /dev/null &
