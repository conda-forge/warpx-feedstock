#!/usr/bin/env bash

# find out toolchain C++ standard
CXX_STANDARD=14
if [[ ${CXXFLAGS} == *"-std=c++14"* ]]; then
    echo "14"
    CXX_STANDARD=14
elif [[ ${CXXFLAGS} == *"-std=c++17"* ]]; then
    echo "17"
    CXX_STANDARD=17
elif [[ ${CXXFLAGS} == *"-std="* ]]; then
    echo "ERROR: unknown C++ standard in toolchain!"
    echo ${CXXFLAGS}
    exit 1
fi

for dim in "2" "3" "RZ"
do
    cmake \
        -S . -B build                         \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo     \
        -DCMAKE_VERBOSE_MAKEFILE=ON           \
        -DCMAKE_CXX_STANDARD=${CXX_STANDARD}  \
        -DCMAKE_INSTALL_LIBDIR=lib            \
        -DCMAKE_INSTALL_PREFIX=${PREFIX}      \
        -DWarpX_openpmd_internal=OFF          \
        -DWarpX_ASCENT=OFF  \
        -DWarpX_LIB=ON      \
        -DWarpX_OPENPMD=ON  \
        -DWarpX_PSATD=OFF   \
        -DWarpX_QED=ON      \
        -DWarpX_DIMS=${dim} \
        ${SRC_DIR}

    cmake --build build --parallel ${CPU_COUNT}

    # future:
    #CTEST_OUTPUT_ON_FAILURE=1 make ${VERBOSE_CM} test

    # future (if skipping AMReX headers)
    #cmake --build build --target install
done

# simple install
#   copy all binaries and libwarpx* files
mkdir -p ${PREFIX}/bin ${PREFIX}/lib
cp build/bin/warpx.* ${PREFIX}/bin/
cp build/lib/libwarpx.* ${PREFIX}/lib/

# add Python API (PICMI interface)
PYWARPX_LIB_DIR=$PREFIX/lib python3 -m pip wheel .
python3 -m pip install pywarpx-*whl
