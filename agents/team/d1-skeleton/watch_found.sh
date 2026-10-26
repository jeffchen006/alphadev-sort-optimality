#!/bin/bash
until grep -rl "^RESULT FOUND" sk/*/res sk/c8n1/*/res 2>/dev/null | grep -v "^$" | head -1 | grep -q .; do sleep 120; grep -q "QUEUE DONE" logs/queue.log && break; done
grep -rl "^RESULT FOUND" sk/*/res sk/c8n1/*/res 2>/dev/null | head
