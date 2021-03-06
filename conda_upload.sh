#!/bin/bash

export PKG_NAME=test_release_4

conda config --set anaconda_upload no
export ANACONDA_API_TOKEN=$CONDA_UPLOAD_TOKEN
export VERSION=$(python setup.py)

echo "Building conda package..."
conda build . || exit 1
export CONDA_BUILD_PATH=/home/travis/miniconda/envs/test-environment/conda-bld
export BASE_PATH=$(pwd)

echo "Move conda package..."
mv ${CONDA_BUILD_PATH}/linux-64/${PKG_NAME}-${VERSION}-py37_0.tar.bz2  ${CONDA_BUILD_PATH} || exit 1

echo "Making new_tar dir..."
mkdir ${CONDA_BUILD_PATH}/new_tar || exit 1

echo "Extracting conda package..."
tar -xf ${CONDA_BUILD_PATH}/${PKG_NAME}-${VERSION}-py37_0.tar.bz2 -C ${CONDA_BUILD_PATH}/new_tar || exit 1

cd ${CONDA_BUILD_PATH}/new_tar
echo "Creating new conda package without some files..."
tar -cjvf ${PKG_NAME}-${VERSION}-py37_0.tar.bz2 --exclude=info/recipe/dir_to_exclude --exclude=info/recipe/test --exclude='*.sh' --exclude='*.gitignore' --exclude='*.pytest_cache' info lib || exit 1

cd ..

echo "Move conda package to linux dir..."
mv new_tar/${PKG_NAME}-${VERSION}-py37_0.tar.bz2 linux-64 || exit 1
echo "Making testing dir..."
mkdir linux-64/testing || exit 1
echo "Extracting testing conda package..."
tar xf linux-64/${PKG_NAME}-${VERSION}-py37_0.tar.bz2 -C linux-64/testing || exit 1
echo "Listing linux-64/testing"
ls linux-64/testing
echo "Listing linux-64/testing/info"
ls linux-64/testing/info
echo "Listing linux-64/testing/info/recipe"
ls linux-64/testing/info/recipe
echo "Listing linux-64/testing/lib"
ls linux-64/testing/lib

cd ${BASE_PATH}
echo "Converting conda package..."
conda convert --platform osx-64 $CONDA_BUILD_PATH/linux-64/***.tar.bz2 --output-dir $CONDA_BUILD_PATH || exit 1
conda convert --platform linux-32 $CONDA_BUILD_PATH/linux-64/***.tar.bz2 --output-dir $CONDA_BUILD_PATH -q || exit 1
conda convert --platform linux-64 $CONDA_BUILD_PATH/linux-64/***.tar.bz2 --output-dir $CONDA_BUILD_PATH -q || exit 1
conda convert --platform win-32 $CONDA_BUILD_PATH/linux-64/***.tar.bz2 --output-dir $CONDA_BUILD_PATH -q || exit 1
conda convert --platform win-64 $CONDA_BUILD_PATH/linux-64/***.tar.bz2 --output-dir $CONDA_BUILD_PATH -q || exit 1

echo "Deploying to Anaconda.org..."
anaconda upload $CONDA_BUILD_PATH/**/$PKG_NAME-*.tar.bz2 --force || exit 1


