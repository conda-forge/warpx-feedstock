@echo on

:: overwrite Clang with GNU CLI activation
:: https://github.com/conda-forge/clang-win-activation-feedstock/blob/724a3900c88ef1748a9c1d90d0c2927db99c3ef5/recipe/activate-clang_win-64.bat#L3-L8
set LDFLAGS=
set CFLAGS=
set CXXFLAGS=

:: simple install prep
::   copy all warpx*.exe and warpx*.dll files
if not exist %LIBRARY_PREFIX%\bin md %LIBRARY_PREFIX%\bin
if errorlevel 1 exit 1

:: CMAKE_AR and CMAKE_RANLIB are needed for IPO with clang-cl

for %%d in (2 3 RZ) do (
    cmake ^
        -S . -B build                         ^
        -G "Ninja"                            ^
        -DCMAKE_BUILD_TYPE=RelWithDebInfo     ^
        -DCMAKE_C_COMPILER=clang-cl           ^
        -DCMAKE_CXX_COMPILER=clang-cl         ^
        -DCMAKE_AR=llvm-ar.exe   ^
        -DCMAKE_RANLIB=llvm-ranlib.exe   ^
        -DCMAKE_VERBOSE_MAKEFILE=ON           ^
        -DWarpX_ASCENT=OFF  ^
        -DWarpX_LIB=ON      ^
        -DWarpX_MPI=OFF     ^
        -DWarpX_OPENPMD=OFF ^
        -DWarpX_PSATD=OFF   ^
        -DWarpX_QED=ON      ^
        -DWarpX_DIMS=%%d    ^
        %SRC_DIR%
    if errorlevel 1 exit 1

    cmake --build build --config RelWithDebInfo --parallel 2
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
::  cmake --build build --config RelWithDebInfo --target install
::  if errorlevel 1 exit 1

:: add Python API (PICMI interface)
PYWARPX_LIB_DIR=%LIBRARY_PREFIX%\lib python3 -m pip wheel .
python3 -m pip install pywarpx-*whl
