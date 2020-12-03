
echo "CXXFLAGS: %CXXFLAGS%"
set "CXXFLAGS=%CXXFLAGS% /FI%RECIPE_DIR%\myiso646.h"
echo "CXXFLAGS: %CXXFLAGS%"

cmake ^
    -S . -B build                         ^
    -G "Ninja"                            ^
    -DCMAKE_BUILD_TYPE=RelWithDebInfo     ^
    -DCMAKE_C_COMPILER=clang-cl           ^
    -DCMAKE_CXX_COMPILER=clang-cl         ^
    -DCMAKE_VERBOSE_MAKEFILE=ON           ^
    -DWarpX_amrex_repo=https://github.com/ax3l/amrex.git  ^
    -DWarpX_amrex_branch=fix-andOrWin     ^
    -DWarpX_openpmd_internal=OFF          ^
    -DWarpX_picsar_branch=47c269eb242815f9382da61a110c0c8f12be2d08 ^
    -DWarpX_ASCENT=OFF  ^
    -DWarpX_MPI=OFF     ^
    -DWarpX_OPENPMD=ON  ^
    -DWarpX_PSATD=OFF   ^
    -DWarpX_QED=ON      ^
    -DWarpX_DIMS=3      ^
    %SRC_DIR%
if errorlevel 1 exit 1

cmake --build build --config RelWithDebInfo --parallel 2
if errorlevel 1 exit 1

:: future: test

:: future: install
mkdir %LIBRARY_PREFIX%\bin
cp build\bin\warpx*.exe %LIBRARY_PREFIX%\bin\

