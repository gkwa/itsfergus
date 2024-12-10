#!/usr/bin/env bash

source ./test-multiple.sh
run_test key $(units --terse 5min sec)
