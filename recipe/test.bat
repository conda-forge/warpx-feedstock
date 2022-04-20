@echo on

set "OMP_NUM_THREADS=2"
set "TEST_DIR=Examples\Physics_applications\laser_acceleration"

:: 3D
warpx.3d.NOMPI.OMP.DP.OPMD.PSATD.QED.exe %TEST_DIR%\inputs_3d max_step=50 diag1.intervals=10 diag1.format=openpmd
if errorlevel 1 exit 1

:: 2D
warpx.2d.NOMPI.OMP.DP.OPMD.PSATD.QED.exe %TEST_DIR%\inputs_2d max_step=50 diag1.intervals=10 diag1.format=openpmd
if errorlevel 1 exit 1

:: 1D
warpx.1d.NOMPI.OMP.DP.OPMD.PSATD.QED.exe %TEST_DIR%\inputs_1d max_step=50 diag1.intervals=10 diag1.format=openpmd
if errorlevel 1 exit 1

:: RZ
warpx.RZ.NOMPI.OMP.DP.OPMD.PSATD.QED.exe %TEST_DIR%\inputs_rz max_step=50 diag1.intervals=10 diag1.format=openpmd diag1.fields_to_plot=Er Et Ez Br Bt Bz jr jt jz rho
if errorlevel 1 exit 1

:: Python: 3D
%PYTHON% %TEST_DIR%\PICMI_inputs_3d.py
if errorlevel 1 exit 1

:: Python: 2D
%PYTHON% %TEST_DIR%\PICMI_inputs_2d.py
if errorlevel 1 exit 1

:: Python: 1D
%PYTHON% %TEST_DIR%\PICMI_inputs_1d.py
if errorlevel 1 exit 1

:: Python: RZ
%PYTHON% %TEST_DIR%\PICMI_inputs_rz.py
if errorlevel 1 exit 1
