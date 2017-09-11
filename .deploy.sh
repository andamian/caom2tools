#!/usr/bin/env bash
# Deploys a Python library or application

product=$(echo $TRAVIS_TAG | awk -F '==' '{print $1}')
version=$(echo $TRAVIS_TAG | awk -F '==' '{print $2}')
echo "Deploying $product, version $version..."
cd $product || exit -1
# check that the version in the tag and in setup.cfg match
grep "^version = $version" setup.cfg || echo "Version in tag ($version) does not match version in setup.cfg" && exit -1
# build
python setup.py clean sdist
# upload to pypi
# generate the .pypirc file first
echo "[pypi]" > .pypirc
chmod 600 .pypirc
echo "username = Canadian.Astronomy.Data.Centre" >> .pypirc
echo "password = ${TWINE_PASSWORD}" >> .pypirc
echo "Configured .pypirc: "
less .pypirc
twine upload --config-file .pypirc dist/*i || exit -1

# check version available
pip install --upgrade --pre $product==$version || exit -1 
