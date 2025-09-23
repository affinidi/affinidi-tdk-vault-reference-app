#!/bin/bash

flutter clean
flutter pub get
flutter build appbundle --dart-define-from-file=.env.prod --flavor prod