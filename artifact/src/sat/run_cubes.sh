#!/bin/bash
# usage: run_cubes.sh <outdir-name> <cubes.py args...>  (background, log in cc/<name>.out)
cd /path/to/repo/agents/sat
name=$1; shift
nohup python3 cubes.py --out cc/$name "$@" > cc/$name.out 2>&1 &
