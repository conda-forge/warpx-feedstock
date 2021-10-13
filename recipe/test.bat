@echo on

set "OMP_NUM_THREADS=2"
set "TEST_DIR=Examples\Physics_applications\laser_acceleration"

:: 3D
warpx.3d.NOMPI.NOACC.DP.OPMD.PSATD.QED.exe %TEST_DIR%\inputs_3d max_step=50 diag1.intervals=10 diag1.format=openpmd
if errorlevel 1 exit 1

:: 2D
warpx.2d.NOMPI.NOACC.DP.OPMD.PSATD.QED.exe %TEST_DIR%\inputs_2d max_step=50 diag1.intervals=10 diag1.format=openpmd
if errorlevel 1 exit 1

:: RZ
warpx.RZ.NOMPI.NOACC.DP.OPMD.PSATD.QED.exe %TEST_DIR%\inputs_2d_rz max_step=50 diag1.intervals=10 diag1.format=openpmd
if errorlevel 1 exit 1
