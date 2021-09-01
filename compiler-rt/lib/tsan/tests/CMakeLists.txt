include_directories(../rtl)

add_custom_target(TsanUnitTests)
set_target_properties(TsanUnitTests PROPERTIES
  FOLDER "Compiler-RT Tests")

# ThreadSanitizer unit tests with dynamic runtime (on platforms where it's
# not the default).
add_custom_target(TsanDynamicUnitTests)
set_target_properties(TsanDynamicUnitTests PROPERTIES FOLDER "Compiler-RT Tests")

set(TSAN_UNITTEST_CFLAGS
  ${COMPILER_RT_UNITTEST_CFLAGS}
  ${COMPILER_RT_GTEST_CFLAGS}
  -I${COMPILER_RT_SOURCE_DIR}/include
  -I${COMPILER_RT_SOURCE_DIR}/lib
  -I${COMPILER_RT_SOURCE_DIR}/lib/tsan/rtl
  -DGTEST_HAS_RTTI=0
  -fno-rtti
)

if(COMPILER_RT_TSAN_DEBUG_OUTPUT)
  # Need to match these flags with the runtime.
  list(APPEND TSAN_UNITTEST_CFLAGS -DTSAN_COLLECT_STATS=1
                                   -DTSAN_DEBUG_OUTPUT=2)
endif()

set(TSAN_TEST_ARCH ${TSAN_SUPPORTED_ARCH})

set(LINK_FLAGS ${COMPILER_RT_UNITTEST_LINK_FLAGS})
foreach(lib ${SANITIZER_TEST_CXX_LIBRARIES})
  list(APPEND LINK_FLAGS -l${lib})
endforeach()

if(APPLE)

  # Create a static library for test dependencies.
  set(TSAN_TEST_RUNTIME_OBJECTS
    $<TARGET_OBJECTS:RTTsan_dynamic.osx>
    $<TARGET_OBJECTS:RTInterception.osx>
    $<TARGET_OBJECTS:RTSanitizerCommon.osx>
    $<TARGET_OBJECTS:RTSanitizerCommonLibc.osx>
    $<TARGET_OBJECTS:RTSanitizerCommonCoverage.osx>
    $<TARGET_OBJECTS:RTSanitizerCommonSymbolizer.osx>
    $<TARGET_OBJECTS:RTUbsan.osx>)
  set(TSAN_TEST_RUNTIME RTTsanTest)
  add_library(${TSAN_TEST_RUNTIME} STATIC ${TSAN_TEST_RUNTIME_OBJECTS})
  set_target_properties(${TSAN_TEST_RUNTIME} PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})

  darwin_filter_host_archs(TSAN_SUPPORTED_ARCH TSAN_TEST_ARCH)
  list(APPEND TSAN_UNITTEST_CFLAGS ${DARWIN_osx_CFLAGS})

  list(APPEND LINK_FLAGS ${DARWIN_osx_LINK_FLAGS})
  add_weak_symbols("ubsan" LINK_FLAGS)
  add_weak_symbols("sanitizer_common" LINK_FLAGS)
else()
  list(APPEND LINK_FLAGS -fsanitize=thread)
  list(APPEND LINK_FLAGS -lm)
  list(APPEND LINK_FLAGS ${COMPILER_RT_TEST_LIBDISPATCH_CFLAGS})
endif()

function(add_tsan_tests arch test_runtime)
  cmake_parse_arguments(TEST "" "KIND" "CFLAGS" ${ARGN})

  # Closure to keep the values.
  function(generate_tsan_tests test_objects test_suite testname)
    generate_compiler_rt_tests(${test_objects} ${test_suite} ${testname} ${arch}
      COMPILE_DEPS ${TSAN_UNITTEST_HEADERS} ${TSAN_IGNORELIST_FILE}
      DEPS gtest tsan
      KIND ${TEST_KIND}
      ${ARGN}
      )
    set("${test_objects}" "${${test_objects}}" PARENT_SCOPE)
  endfunction()
  set(TSAN_INST_TEST_OBJECTS)
  generate_tsan_tests(TSAN_INST_TEST_OBJECTS TsanUnitTests
    "Tsan-${arch}${TEST_KIND}-Test"
    SUBDIR "default"
    LINK_FLAGS ${TSAN_UNITTEST_INSTRUMENTED_LINK_FLAGS}
    SOURCES ${TSAN_INST_TEST_SOURCES}
    CFLAGS ${TSAN_UNITTEST_INSTRUMENTED_CFLAGS} ${TEST_CFLAGS})

  if(COMPILER_RT_TSAN_HAS_STATIC_RUNTIME)
    set(dynamic_test_name "Tsan-${arch}${TEST_KIND}-Dynamic-Test")
    add_compiler_rt_test(TsanDynamicUnitTests "${dynamic_test_name}" "${arch}"
        SUBDIR "dynamic"
        OBJECTS ${TSAN_INST_TEST_OBJECTS}
        DEPS tsan ${TSAN_INST_TEST_OBJECTS}
        LINK_FLAGS ${TSAN_DYNAMIC_UNITTEST_INSTRUMENTED_LINK_FLAGS}
        )
  endif()
endfunction()

set(TSAN_RTL_HEADERS)
foreach (header ${TSAN_HEADERS})
  list(APPEND TSAN_RTL_HEADERS ${CMAKE_CURRENT_SOURCE_DIR}/../${header})
endforeach()

set(TSAN_DEPS gtest tsan)
# TSan uses C++ standard library headers.
if (TARGET cxx-headers OR HAVE_LIBCXX)
  set(TSAN_DEPS cxx-headers)
endif()

# add_tsan_unittest(<name>
#                   SOURCES <sources list>
#                   HEADERS <extra headers list>)
macro(add_tsan_unittest testname)
  cmake_parse_arguments(TEST "" "" "SOURCES;HEADERS" ${ARGN})
  if(UNIX)
    foreach(arch ${TSAN_TEST_ARCH})
      set(TsanUnitTestsObjects)
      generate_compiler_rt_tests(TsanUnitTestsObjects TsanUnitTests
        "${testname}-${arch}-Test" ${arch}
        SOURCES ${TEST_SOURCES} ${COMPILER_RT_GTEST_SOURCE}
        RUNTIME ${TSAN_TEST_RUNTIME}
        COMPILE_DEPS ${TEST_HEADERS} ${TSAN_RTL_HEADERS}
        DEPS ${TSAN_DEPS}
        CFLAGS ${TSAN_UNITTEST_CFLAGS}
        LINK_FLAGS ${LINK_FLAGS})
    endforeach()
  endif()
endmacro()

if(COMPILER_RT_CAN_EXECUTE_TESTS AND NOT ANDROID)
  add_subdirectory(rtl)
  add_subdirectory(unit)
endif()
