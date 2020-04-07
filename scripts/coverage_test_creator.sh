#!/bin/sh

file=test/coverage_test.dart

echo "// ignore_for_file: unused_import" > $file
find lib -name '*.dart' -and -not -name '*_event.dart' -and -not -name '*_state.dart' | cut -c4- | awk -v package=collectio '{printf "import '\''package:collectio%s'\'';\n", $1}' >> $file
echo "\nvoid main(){}" >> $file