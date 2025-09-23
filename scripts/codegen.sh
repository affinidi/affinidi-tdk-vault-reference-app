#!/bin/bash 
set -e

echo "------------------------------------------------------------------------"
echo "Generating code"
echo "------------------------------------------------------------------------"

fvm flutter clean
fvm flutter pub get
fvm dart run build_runner build --delete-conflicting-outputs
fvm dart format -l 120 .

