#!/bin/bash

../../../robust ../src/base/axi2apb.v -od out -I ../src/gen -list list.txt -listpath -header ${@}

echo Completed RobustVerilog axi2apb run - results in run/out/
