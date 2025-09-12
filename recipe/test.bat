@echo on

set "OMP_NUM_THREADS=2"
set "TEST_DIR=Examples\Physics_applications\laser_acceleration"
set "TEST_DIR_LANGMUIR=Examples\Tests\langmuir"

:: 3D
warpx.3d.NOMPI.OMP.DP.PDP.OPMD.FFT.EB.QED.exe %TEST_DIR%\inputs_base_3d max_step=50 diag1.intervals=10 diag1.format=openpmd
if errorlevel 1 exit 1

:: 2D
warpx.2d.NOMPI.OMP.DP.PDP.OPMD.FFT.EB.QED.exe %TEST_DIR%\inputs_base_2d max_step=50 diag1.intervals=10 diag1.format=openpmd
if errorlevel 1 exit 1

:: 1D
warpx.1d.NOMPI.OMP.DP.PDP.OPMD.FFT.EB.QED.exe %TEST_DIR%\inputs_base_1d max_step=50 diag1.intervals=10 diag1.format=openpmd
if errorlevel 1 exit 1

:: RZ
warpx.rz.NOMPI.OMP.DP.PDP.OPMD.FFT.EB.QED.exe %TEST_DIR%\inputs_base_rz max_step=50 diag1.intervals=10 diag1.format=openpmd diag1.fields_to_plot=Er Et Ez Br Bt Bz jr jt jz rho
if errorlevel 1 exit 1

:: RCYLINDER
warpx.rcylinder.NOMPI.OMP.DP.PDP.OPMD.FFT.EB.QED.exe %TEST_DIR_LANGMUIR%\inputs_test_rcylinder_langmuir_multi max_step=50 diag1.intervals=10 diag1.format=openpmd
if errorlevel 1 exit 1

:: RSPHERE
warpx.rsphere.NOMPI.OMP.DP.PDP.OPMD.FFT.EB.QED.exe %TEST_DIR_LANGMUIR%\inputs_test_rsphere_langmuir_multi max_step=50 diag1.intervals=10 diag1.format=openpmd
if errorlevel 1 exit 1

:: Python: 3D
python %TEST_DIR%\inputs_test_3d_laser_acceleration_picmi.py
if errorlevel 1 exit 1

:: Python: 2D
python %TEST_DIR%\inputs_test_2d_laser_acceleration_mr_picmi.py
if errorlevel 1 exit 1

:: Python: 1D
python %TEST_DIR%\inputs_test_1d_laser_acceleration_picmi.py
if errorlevel 1 exit 1

:: Python: RZ
python %TEST_DIR%\inputs_test_rz_laser_acceleration_picmi.py
if errorlevel 1 exit 1
