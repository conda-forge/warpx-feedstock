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

cmake \
    -S ${SRC_DIR} -B build                \
    ${CMAKE_ARGS}                         \
    -DCMAKE_BUILD_TYPE=Release            \
    -DCMAKE_VERBOSE_MAKEFILE=ON           \
    -DCMAKE_INSTALL_LIBDIR=lib            \
    -DCMAKE_INSTALL_PREFIX=${PREFIX}      \
    -DPYINSTALLOPTIONS="--no-build-isolation"  \
    -DPython_EXECUTABLE=${PYTHON}         \
    -DPython_INCLUDE_DIR=$(${PYTHON} -c "from sysconfig import get_paths as gp; print(gp()['include'])") \
    -DWarpX_amrex_internal=OFF    \
    -DWarpX_ASCENT=OFF            \
    -DWarpX_IPO=${WarpX_IPO}      \
    -DWarpX_MPI=OFF               \
    -DWarpX_OPENPMD=ON            \
    -DWarpX_openpmd_internal=OFF  \
    -DWarpX_PSATD=ON              \
    -DWarpX_pyamrex_internal=OFF  \
    -DWarpX_pybind11_internal=OFF \
    -DWarpX_PYTHON=ON             \
    -DWarpX_QED=ON                \
    -DWarpX_DIMS="1;2;RZ;3"

cmake --build build --parallel ${CPU_COUNT}

# future:
#CTEST_OUTPUT_ON_FAILURE=1 make ${VERBOSE_CM} test

# install (libs)
cmake --build build --target install

# simple install
#   copy all binaries and libwarpx* files
mkdir -p ${PREFIX}/bin ${PREFIX}/lib
cp build/bin/warpx.* ${PREFIX}/bin/
cp build/lib/libwarpx.* ${PREFIX}/lib/

# add Python API (PICMI interface)
cmake --build build --target pip_install_nodeps

# do not install static libs from ABLASTR
rm -rf ${PREFIX}/lib/libablastr_*.a
