#!/bin/bash
docker stop $(docker ps -q) 2>/dev/null || true
docker rm $(docker ps -aq) 2>/dev/null || true
docker system prune -a --volumes -f
kind delete cluster --name lesson 2>/dev/null || true
rm -rf /tmp/lesson-* lesson*.log
