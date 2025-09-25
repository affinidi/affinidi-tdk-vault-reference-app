#!/bin/bash 
set -e

echo "------------------------------------------------------------------------"
echo "Generating localized strings"
echo "------------------------------------------------------------------------"

flutter gen-l10n
dart format .
