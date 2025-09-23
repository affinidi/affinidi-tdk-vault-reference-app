#!/bin/bash

flutter clean
flutter pub get
cd ios
pod install
flutter build ipa --dart-define-from-file=configurations/production/configuration.json --flavor prod