#!/bin/bash
scriptdir="$(dirname "$0")"
cd "$scriptdir"

cat ./perceptron_module_test.s > ./main.s
cat ../math_module/* ../linalg_module/* ../debug_module/* ../perceptron_module/* > ./temp
sed -i "/^.*globl.*$/d" ./temp
cat ./temp >> ./main.s
rm ./temp