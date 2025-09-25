#!/bin/bash 
set -e

echo "------------------------------------------------------------------------"
echo "Generating code"
echo "------------------------------------------------------------------------"

flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart format .
