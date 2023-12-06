@echo on

:: simple install prep
::   copy all warpx*.exe and warpx*.dll files
if not exist %LIBRARY_PREFIX%\bin md %LIBRARY_PREFIX%\bin
if errorlevel 1 exit 1

cmake ^
    -S %SRC_DIR% -B build                 ^
    %CMAKE_ARGS%                          ^
    -G "Ninja"                            ^
    -DCMAKE_BUILD_TYPE=Release            ^
    -DCMAKE_C_COMPILER=clang-cl           ^
    -DCMAKE_CXX_COMPILER=clang-cl         ^
    -DCMAKE_INSTALL_LIBDIR=lib            ^
    -DCMAKE_LINKER=lld-link               ^
    -DCMAKE_NM=llvm-nm                    ^
    -DCMAKE_VERBOSE_MAKEFILE=ON           ^
    -DPYINSTALLOPTIONS="--no-build-isolation"  ^
    -DPython_EXECUTABLE=%PYTHON%  ^
    -DWarpX_amrex_internal=OFF    ^
    -DWarpX_ASCENT=OFF            ^
    -DWarpX_MPI=OFF               ^
    -DWarpX_OPENPMD=ON            ^
    -DWarpX_openpmd_internal=OFF  ^
    -DWarpX_PSATD=ON              ^
    -DWarpX_pyamrex_internal=OFF  ^
    -DWarpX_pybind11_internal=OFF ^
    -DWarpX_PYTHON=ON             ^
    -DWarpX_QED=ON                ^
    -DWarpX_DIMS="1;2;RZ;3"
if errorlevel 1 exit 1

:: build
cmake --build build --config Release --parallel 2
if errorlevel 1 exit 1

:: install
cmake --build build --config Release --target install
if errorlevel 1 exit 1
cmake --build build --config Release --target pip_install_nodeps
if errorlevel 1 exit 1

:: test
::   skip the pyAMReX tests to save CI time
::set "EXCLUSION_REGEX=AMReX"
::ctest --test-dir build --build-config Release --output-on-failure -E %EXCLUSION_REGEX%
::if errorlevel 1 exit 1

:: do not install static libs from ABLASTR
del "%LIBRARY_PREFIX%\lib\ablastr_*.lib"
