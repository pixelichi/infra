#!/bin/bash -e

pushd ./prod-00
make refresh
popd

pushd ./prod-01
make
popd
