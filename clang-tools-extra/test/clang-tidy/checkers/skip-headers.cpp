// Test --skip-headers, --show-all-warnings, and --header-filter.
// TODO(chh): when skip-headers implementation is complete, add back
//      -implicit-check-not="{{warning|error}}:"
// and use no_hint instead of hint
//
// Default shows no warning in .h files, and give HINT to use --header-filter
// RUN: clang-tidy %s -checks='*' -- \
// RUN: 2>&1 | FileCheck %s -check-prefixes WARN,MAIN,HINT
// later:    -implicit-check-not="{{warning|error}}:"
//
// --skip-headers skips included files; finds only warnings in the main file.
// RUN: clang-tidy %s -checks='*' --skip-headers -- \
// RUN: 2>&1 | FileCheck %s -check-prefixes WARN,MAIN,HINT
// later:    no_hint -implicit-check-not="{{warning|error}}:"
//
// --show-all-warnings reports all warnings, even without --header-filters
// RUN: clang-tidy %s -checks='*' --show-all-warnings -- \
// RUN: 2>&1 | FileCheck %s -check-prefixes WARN,WARN_BOTH,MAIN,NO_HINT
//
// --header-filter='.*' is like --show-all-warnings
// RUN: clang-tidy %s -checks='*' --header-filter='.*' -- \
// RUN: 2>&1 | FileCheck %s -check-prefixes WARN,WARN_BOTH,MAIN,NO_HINT
//
// --header-filter='header1.h' shows only warnings in header1.h
// RUN: clang-tidy %s -checks='*' --header-filter='header1.h' -- \
// RUN: 2>&1 | FileCheck %s -check-prefixes WARN,WARN1,MAIN,HINT
// later:    -implicit-check-not="{{warning|error}}:"
//
// The main purpose of --show-all-warnings is to debug --skip-headers.
// When used together, no warnings should be reported from header files.
// RUN: clang-tidy %s -checks='*' --skip-headers --show-all-warnings -- \
// RUN: 2>&1 | FileCheck %s -check-prefixes WARN,MAIN,NO_HINT
// later:  -implicit-check-not="{{warning|error}}:"
//
// use --skip-headers and --header-filter='header2.h'
// to skip header1.h but not header2.h
// RUN: clang-tidy %s -checks='*' --skip-headers --header-filter='header2.h' \
// RUN: 2>&1 | FileCheck %s -check-prefixes WARN,WARN2,MAIN,HINT
// later:  no_hint

// WARN: {{[0-9]+}} warnings generated.
#include "Inputs/skip-headers/my_header1.h"
// WARN1: my_header1.h:1:1: warning: header is missing header guard
// WARN1-NOT: my_header2.h
// WARN2: my_header2.h:1:1: warning: header is missing header guard
// WARN2-NOT: my_header1.h
// WARN_BOTH: my_header1.h:1:1: warning: header is missing header guard
// WARN_BOTH: my_header2.h:1:1: warning: header is missing header guard

int xyz = 135;
// MAIN: skip-headers.cpp:{{[0-9]+}}:{{[0-9]+}}: warning:

// HINT: Use -header-filter={{.*}} to display errors{{.*}}
// NO_HINT-NOT: Use -header-filter=
