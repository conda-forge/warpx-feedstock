#!/usr/bin/env bash

# avoid side-injection of -std=c++14 flag in some toolchains
if [[ ${CXXFLAGS} == *"-std=c++14"* ]]; then
    echo "14 -> 17"
    export CXXFLAGS="${CXXFLAGS} -std=c++17"
fi
# Darwin modern C++
#   https://conda-forge.org/docs/maintainer/knowledge_base.html#newer-c-features-with-old-sdk
if [[ ${target_platform} =~ osx.* ]]; then
    export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
fi

# IPO/LTO does only work with certain toolchains
WarpX_IPO=ON
if [[ ${target_platform} =~ osx.* ]]; then
    WarpX_IPO=OFF
fi

for dim in "1" "2" "3" "RZ"
do
    cmake \
        -S ${SRC_DIR} -B build                \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo     \
        -DCMAKE_VERBOSE_MAKEFILE=ON           \
        -DCMAKE_INSTALL_LIBDIR=lib            \
        -DCMAKE_INSTALL_PREFIX=${PREFIX}      \
        -DWarpX_openpmd_internal=OFF          \
        -DWarpX_IPO=${WarpX_IPO}              \
        -DWarpX_ASCENT=OFF  \
        -DWarpX_LIB=ON      \
        -DWarpX_MPI=OFF     \
        -DWarpX_OPENPMD=ON  \
        -DWarpX_PSATD=ON    \
        -DWarpX_QED=ON      \
        -DWarpX_DIMS=${dim}

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
export PYWARPX_LIB_DIR=$PREFIX/lib
$PYTHON -m pip install . -vv --no-build-isolation
