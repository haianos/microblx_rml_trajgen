#!/bin/bash

source $UBX_ROOT/env.sh
exec $UBX_ROOT/tools/ubx_launch -webif 8888 -c rml_test.usc
