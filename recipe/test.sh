#!/usr/bin/env bash

set -eu -x -o pipefail

export OMP_NUM_THREADS=2
export TEST_DIR=Examples/Physics_applications/laser_acceleration

# 3D
warpx.3d.NOMPI.OMP.DP.OPMD.PSATD.QED ${TEST_DIR}/inputs_3d max_step=50 diag1.intervals=10 diag1.format=openpmd

# 2D
warpx.2d.NOMPI.OMP.DP.OPMD.PSATD.QED ${TEST_DIR}/inputs_2d max_step=50 diag1.intervals=10 diag1.format=openpmd

# 1D: input in 22.01+
#warpx.1d.NOMPI.OMP.DP.OPMD.PSATD.QED ${TEST_DIR}/inputs_1d max_step=50 diag1.intervals=10 diag1.format=openpmd

# RZ
warpx.RZ.NOMPI.OMP.DP.OPMD.PSATD.QED ${TEST_DIR}/inputs_2d_rz max_step=50 diag1.intervals=10 diag1.format=openpmd

# TODO: Python tests
