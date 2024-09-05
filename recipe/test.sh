#!/usr/bin/env bash

set -eu -x -o pipefail

export OMP_NUM_THREADS=2
export TEST_DIR=Examples/Physics_applications/laser_acceleration

# 3D
warpx.3d.NOMPI.OMP.DP.PDP.OPMD.FFT.QED ${TEST_DIR}/inputs_3d max_step=50 diag1.intervals=10 diag1.format=openpmd

# 2D
warpx.2d.NOMPI.OMP.DP.PDP.OPMD.FFT.QED ${TEST_DIR}/inputs_2d max_step=50 diag1.intervals=10 diag1.format=openpmd

# 1D
warpx.1d.NOMPI.OMP.DP.PDP.OPMD.FFT.QED ${TEST_DIR}/inputs_1d max_step=50 diag1.intervals=10 diag1.format=openpmd

# RZ
warpx.rz.NOMPI.OMP.DP.PDP.OPMD.FFT.QED ${TEST_DIR}/inputs_rz max_step=50 diag1.intervals=10 diag1.format=openpmd diag1.fields_to_plot=Er Et Ez Br Bt Bz jr jt jz rho

# Python: 3D
$PYTHON ${TEST_DIR}/PICMI_inputs_3d.py

# Python: 2D
$PYTHON ${TEST_DIR}/PICMI_inputs_2d.py

# Python: 1D
$PYTHON ${TEST_DIR}/PICMI_inputs_1d.py

# Python: RZ
$PYTHON ${TEST_DIR}/PICMI_inputs_rz.py
