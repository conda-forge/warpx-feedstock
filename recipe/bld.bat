@echo on

:: simple install prep
::   copy all warpx*.exe and warpx*.dll files
if not exist %LIBRARY_PREFIX%\bin md %LIBRARY_PREFIX%\bin
if errorlevel 1 exit 1

for %%d in (1 2 3 RZ) do (
    cmake ^
        -S %SRC_DIR% -B build                 ^
        %CMAKE_ARGS%                          ^
        -G "Ninja"                            ^
        -DCMAKE_BUILD_TYPE=Release            ^
        -DCMAKE_C_COMPILER=clang-cl           ^
        -DCMAKE_CXX_COMPILER=clang-cl         ^
        -DCMAKE_LINKER=lld-link               ^
        -DCMAKE_NM=llvm-nm                    ^
        -DCMAKE_VERBOSE_MAKEFILE=ON           ^
        -DWarpX_ASCENT=OFF  ^
        -DWarpX_LIB=ON      ^
        -DWarpX_MPI=OFF     ^
        -DWarpX_OPENPMD=ON  ^
        -DWarpX_openpmd_internal=OFF ^
        -DWarpX_PSATD=ON    ^
        -DWarpX_QED=ON      ^
        -DWarpX_DIMS=%%d
    if errorlevel 1 exit 1

    cmake --build build --config Release --parallel 2
    if errorlevel 1 exit 1

    for /r "build\bin" %%f in (*.exe) do (
        echo %%~nf
        dir
        copy build\bin\%%~nf.exe %LIBRARY_PREFIX%\bin\
        if errorlevel 1 exit 1
    )
    for /r "build\lib" %%f in (*.dll) do (
        echo %%~nf
        dir
        copy build\lib\%%~nf.dll %LIBRARY_PREFIX%\lib\
        if errorlevel 1 exit 1
    )
    
    rmdir /s /q build
)
:: future (if skipping AMReX headers) - inside above loop
::  cmake --build build --config Release --target install
::  if errorlevel 1 exit 1

:: add Python API (PICMI interface)
set "PYWARPX_LIB_DIR=%LIBRARY_PREFIX%\lib"
%PYTHON% -m pip install . -vv --no-build-isolation
