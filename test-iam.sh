#!/usr/bin/env bash

source ./test-multiple.sh
run_test iam $(units --terse 10min sec)
