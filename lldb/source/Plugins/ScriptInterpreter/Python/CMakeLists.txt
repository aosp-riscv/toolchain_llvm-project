if(NOT LLDB_PYTHON_RELATIVE_PATH)
  message(FATAL_ERROR "LLDB_PYTHON_RELATIVE_PATH is not set.")
endif()
add_definitions(-DLLDB_PYTHON_RELATIVE_LIBDIR="${LLDB_PYTHON_RELATIVE_PATH}")

# Newer llvm/lldb configuration rules add -std=c++14 by default
# and it implies __STRICT_ANSI__. When cross compile with sysroot
# with x86_64 mingw32 math.h file, it defines global hypot and other
# functions only when __STRICT_ANSI__ is not defined.
# But some python header files still depend on those global hypot
# functions available only in non-STRICT_ANSI mode.
if(LLDB_PYTHON_UNDEF_STRICT_ANSI)
  add_definitions(-U__STRICT_ANSI__)
endif()

add_lldb_library(lldbPluginScriptInterpreterPython PLUGIN
  PythonDataObjects.cpp
  PythonReadline.cpp
  ScriptInterpreterPython.cpp

  LINK_LIBS
    lldbBreakpoint
    lldbCore
    lldbDataFormatters
    lldbHost
    lldbInterpreter
    lldbTarget
    ${PYTHON_LIBRARY}

  LINK_COMPONENTS
    Support
  )
