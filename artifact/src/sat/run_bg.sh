#!/bin/bash
# usage: run_bg.sh <logname> <cegis args...>   (nice, 2h timeout, unbuffered log in logs/)
cd /path/to/repo/agents/sat
name=$1; shift
nohup nice -n 10 timeout ${TMO:-7200} python3 -u cegis.py "$@" > logs/$name.log 2>&1 &
