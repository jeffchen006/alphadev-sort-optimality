#!/bin/bash
# after the c=9 127..253 runner (3704944) ends: run c=9 cases 0..126 (unless codex-fleet w10 owns them: then kill this)
cd $(dirname $0); while kill -0 3704944 2>/dev/null; do sleep 60; done
python3 src/run.py --cs 9 --workers 12 --limit 3600 --cases $(cat c9_first.txt) > run_c9_first.log 2>&1
