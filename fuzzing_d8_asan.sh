#!/bin/bash

# color style
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# fuzzing config
seed_dir="./input/"
crash_dir="crashes"
core_dir="core"
target="./d8"
target_param="--wasm-grow-shared-memory --abort-on-uncaught-exception"
asan_op="detect_leaks=0,exitcode=42,abort_on_error=1,disable_coredump=0"

clear
echo -e "${RED}[*] Fuzzing d8/ASAN using seeds${NC}"
echo

mkdir "$crash_dir"

echo -e "${RED}[*] Start execution${NC}"
echo -e "${RED}[*] Seeds folder: input/${NC}"
echo -e "${RED}[*] Crashes folder: crashes/${NC}"
echo

for i in `find "$seed_dir" -name "*.js" | sort -u`; do
  echo -e "${RED}[*] TestCase: $i${NC}";

  # exec target with ASAN options
  ASAN_OPTIONS=${asan_op} ${target} ${target_param} $i > /dev/null

  # check if ASAN crash
  if [ $? -gt 0 ]; then
    echo -e "${GREEN}[*][*] d8 ASAN crash${NC}"
    cp $i crashes/
  fi

done
