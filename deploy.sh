#!/bin/bash
# Deploys a Python library or application
product=$(echo $TRAVIS_TAG | awk -F '==' '{print $1}')
version=$(echo $TRAVIS_TAG | awk -F '==' '{print $2}')
echo "Deploying $product, version $version..."
cd $product
# build
python setup.py clean sdist
# upload to pypi
echo "[pypi]" > .pypirc
chmod 600 .pypirc
echo "username = Canadian.Astronomy.Data.Centre" > .pypirc
echo "password = $TWINE_PASSWORD" > .pypirc
echo "Configured .pypirc: "
less .pypirc
twine upload --config-file .pypirc dist
