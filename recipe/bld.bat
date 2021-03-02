
echo "CXXFLAGS: %CXXFLAGS%"

for %%d in (2 3 RZ) do (
    cmake ^
        -S . -B build                         ^
        -G "Ninja"                            ^
        -DCMAKE_BUILD_TYPE=RelWithDebInfo     ^
        -DCMAKE_C_COMPILER=clang-cl           ^
        -DCMAKE_CXX_COMPILER=clang-cl         ^
        -DCMAKE_VERBOSE_MAKEFILE=ON           ^
        -DWarpX_amrex_branch=%PKG_VERSION%    ^
        -DWarpX_openpmd_internal=OFF          ^
        -DWarpX_picsar_branch=47c269eb242815f9382da61a110c0c8f12be2d08 ^
        -DWarpX_ASCENT=OFF  ^
        -DWarpX_MPI=OFF     ^
        -DWarpX_OPENPMD=ON  ^
        -DWarpX_PSATD=OFF   ^
        -DWarpX_QED=ON      ^
        -DWarpX_DIMS=%%d    ^
        %SRC_DIR%
    if errorlevel 1 exit 1

    cmake --build build --config RelWithDebInfo --parallel 2
    if errorlevel 1 exit 1
)

:: future: test

:: future: install
:: now: copy all warpx*.exe files
if not exist %LIBRARY_PREFIX%\bin md %LIBRARY_PREFIX%\bin
if errorlevel 1 exit 1

for /r "build\bin" %%f in (*.exe) do (
    echo %%~nf
    dir
    copy build\bin\%%~nf.exe %LIBRARY_PREFIX%\bin\
    if errorlevel 1 exit 1
)
