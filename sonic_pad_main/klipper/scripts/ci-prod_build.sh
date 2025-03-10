#!/bin/bash
set -eu

# Paths to tools installed by ci-install.sh
MAIN_DIR=${PWD}
BUILD_DIR=${PWD}/ci_build
export PATH=${BUILD_DIR}/pru-gcc/bin:${PATH}
PYTHON=${BUILD_DIR}/python-env/bin/python
PYTHON2=${BUILD_DIR}/python2-env/bin/python

######################################################################
# Run compile tests for several different MCU types
######################################################################

DICTDIR=${BUILD_DIR}/dict
mkdir -p ${DICTDIR}

for TARGET in ./cr10smart.config ; do
    start_prod mcu_compile "$TARGET"
    make clean
    make distclean
    unset CC
    cp ${TARGET} .config
    make olddefconfig
    make V=1
    size out/*.elf
    size out/*.bin
        cp out/*.bin /prod/
    finish_prod mcu_compile "$TARGET"
    cp out/klipper.dict ${DICTDIR}/$(basename ${TARGET} .config).dict
done

for TARGET in ./FYSETC.config ; do
    start_prod mcu_compile "$TARGET"
    make clean
    make distclean
    unset CC
    cp ${TARGET} .config
    make olddefconfig
    make V=1
    size out/*.elf
    size out/*.bin
    cp out/*.bin /prod/
    finish_prod mcu_compile "$TARGET"
    cp out/klipper.dict ${DICTDIR}/$(basename ${TARGET} .config).dict
done

#for TARGET in ./cr10spro.config ; do
#    start_prod mcu_compile "$TARGET"
#    make clean
#    make distclean
#    unset CC
#    cp ${TARGET} .config
#    make olddefconfig
#    make V=1
#    size out/*.elf
#    size out/*.bin
#    cp out/*.bin /prod/
#    finish_prod mcu_compile "$TARGET"
#    cp out/klipper.dict ${DICTDIR}/$(basename ${TARGET} .config).dict
#done
