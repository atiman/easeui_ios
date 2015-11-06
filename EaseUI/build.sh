#!/bin/sh

## global, user customizable variables. 
SDK_VERSION=8.3
MAKE=make
MAKE_FLAGS=-j8

## source directory is generated by Makefile
# root build directory
ROOT=.
BUILD=${ROOT}/build

# configurations, user customizable. 
CONFIGURATIONS[0]=Debug
CONFIGURATIONS[1]=Release

# simulator build directories
SIMULATORS[0]=${BUILD}/${CONFIGURATIONS[0]}-iphonesimulator
SIMULATORS[1]=${BUILD}/${CONFIGURATIONS[1]}-iphonesimulator

# device build directories
DEVICES[0]=${BUILD}/${CONFIGURATIONS[0]}-iphoneos
DEVICES[1]=${BUILD}/${CONFIGURATIONS[1]}-iphoneos

# all directories (simulatorx2 + devicex2)
# these directories are automatically generated 
# by xcodebuild during the build process
SOURCES[0]=${SIMULATORS[0]}
SOURCES[1]=${SIMULATORS[1]}
SOURCES[2]=${DEVICES[0]}
SOURCES[3]=${DEVICES[1]}

## destination directory is generated by build script. 
DIST_ROOT=${ROOT}/export
DIST_LIB_DIR=${DIST_ROOT}/lib
DIST_INCLUDE_DIR=${DIST_ROOT}/include
DIST_RESOURCE_DIR=${DIST_ROOT}/resources

# individual lib directories
DIST_SIMULATORS[0]=${DIST_LIB_DIR}/simulator/${CONFIGURATIONS[0]}
DIST_SIMULATORS[1]=${DIST_LIB_DIR}/simulator/${CONFIGURATIONS[1]}
DIST_DEVICES[0]=${DIST_LIB_DIR}/device/${CONFIGURATIONS[0]}
DIST_DEVICES[1]=${DIST_LIB_DIR}/device/${CONFIGURATIONS[1]}
DIST_FATS[0]=${DIST_LIB_DIR}/fat/${CONFIGURATIONS[0]}
DIST_FATS[1]=${DIST_LIB_DIR}/fat/${CONFIGURATIONS[1]}

# all lib directories
DISTS[0]=${DIST_SIMULATORS[0]}
DISTS[1]=${DIST_SIMULATORS[1]}
DISTS[2]=${DIST_DEVICES[0]}
DISTS[3]=${DIST_DEVICES[1]}
DISTS[4]=${DIST_FATS[0]}
DISTS[5]=${DIST_FATS[1]}

# target names, user customizable. 
TARGETS[0]=EaseUI

# library names
DIST_LIBRARY_NAMES[0]=lib${TARGETS[0]}.a

## reset related directories
# reset build, it will be used during Makefile
if [ -d "${BUILD}" ]; then 
	rm -rf ${BUILD}
else
	echo "${BUILD}" " directory not found, ignored. "
fi

# no need to create platforms directories, they will be created during the build process by xcodebuild. 

# reset dist include directory, it might be a symbolic link, we should do extra work. 
if [ -d "${DIST_ROOT}" ]; then
	rm -rf ${DIST_ROOT}
fi
# remove symbolic link. 
if [ -L "${DIST_ROOT}" ]; then
	rm -f ${DIST_ROOT}
fi

# create dists
count=${#DISTS[@]}
for((i=0;i<count;i++));do
  mkdir -p ${DISTS[i]}
done

## begin build process
count=${#TARGETS[@]}
extra_count=${#CONFIGURATIONS[@]}
for((i=0;i<count;i++));do
	for((j=0;j<extra_count;j++));do
		${MAKE} ${MAKE_FLAGS} target_name=${TARGETS[i]} sdk_version=${SDK_VERSION} configuration=${CONFIGURATIONS[j]}
		ERROR=$?
		if [ $ERROR -gt 0 ]; then
			echo 'Failed to build project!' 'target_name='${TARGETS[i]} 'sdk_version='${SDK_VERSION} 'configuration='${CONFIGURATIONS[j]}
			exit $ERROR
		fi
	done
done

# move libs
count=${#SOURCES[@]}
extra_count=${#DIST_LIBRARY_NAMES[@]}
for((i=0;i<count;i++));do
	for((j=0;j<extra_count;j++));do
		mv ${SOURCES[i]}/${DIST_LIBRARY_NAMES[j]} ${DISTS[i]}
	done
done

# create fat libs for all targets
count=${#DIST_LIBRARY_NAMES[@]}
extra_count=${#CONFIGURATIONS[@]}
for((i=0;i<count;i++));do
	for((j=0;j<extra_count;j++));do
		lipo -create ${DISTS[j]}/${DIST_LIBRARY_NAMES[i]} ${DISTS[j+extra_count]}/${DIST_LIBRARY_NAMES[i]} -output ${DISTS[j+2*extra_count]}/${DIST_LIBRARY_NAMES[i]}
	done
done

# generate doc
sh gendoc.sh

# create timestamp directory
#GIT_VERSION="`git rev-list HEAD -n 1 | cut -c 1-7`"
# use the line above if we want shorter. 
GIT_REVISION="`git rev-list HEAD -n 1`"
GIT_BRANCH="`git rev-parse --abbrev-ref HEAD`"
BUILD_DIR="`date '+%Y%m%d'`_`date '+%H%M%S'`_${GIT_BRANCH}_${GIT_REVISION}"

SYMBOLIC_DIR=export
# make build directory
## debug
#echo ${DIST_ROOT} " -> " ${BUILD_DIR}
mv ${DIST_ROOT} ${BUILD_DIR}

# create symbolic link, it will be used in xcode project.
if [ -L "${SYMBOLIC_DIR}" ]; then
	rm -f ${SYMBOLIC_DIR}
fi
## it might be physical directory on disk which produced by xcode. 
## we need rm -rf it. 
if [ -d "${SYMBOLIC_DIR}" ]; then
	rm -rf ${SYMBOLIC_DIR}
fi
## debug
#echo ${BUILD_DIR} " -> " ${SYMBOLIC_DIR}
ln -s ${BUILD_DIR} ${SYMBOLIC_DIR}

# print report
ERROR=$?
if [ $ERROR -eq 0 ]; then
  echo 'library files located at '${BUILD_DIR}
else
  echo 'failed to build library files.'
  exit $ERROR
fi

exit 0
