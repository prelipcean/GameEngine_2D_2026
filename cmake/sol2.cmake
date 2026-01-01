#[[
================================================================================
  Sol2 C++ Lua Bindings Library Configuration
================================================================================

  Purpose:
    Configures Sol2 - a fast, simple C++ and Lua binding library. Sol2 
    provides a clean, modern C++ interface to Lua with minimal overhead.

  Build Type:
    Header-only (no compilation required)

  Features:
    - Modern C++ (C++17) interface to Lua
    - Automatic type conversion
    - Table and usertype support
    - Exception safety options
    - STL container support
    - Lambda and function binding

  Dependencies:
    - Lua (must be configured before this file via lua.cmake)

  Targets Created:
    sol2  - Interface library (header-only, links to lua)

  Usage in Code:
    #include <sol/sol.hpp>
    
    sol::state lua;
    lua.open_libraries(sol::lib::base);
    lua.script("print('Hello from Lua!')");
    
    // Bind C++ function
    lua.set_function("cpp_add", [](int a, int b) { return a + b; });

  Source:
    Located at: ${CMAKE_SOURCE_DIR}/external/sol2

  Documentation:
    https://sol2.readthedocs.io/

================================================================================
]]

#-------------------------------------------------------------------------------
# Configuration
#-------------------------------------------------------------------------------
set(SOL2_SOURCE_DIR ${CMAKE_SOURCE_DIR}/external/sol2)

# Verify source directory exists
if(NOT EXISTS ${SOL2_SOURCE_DIR}/include/sol/sol.hpp)
    # Try alternative location (some distributions use different structure)
    if(NOT EXISTS ${SOL2_SOURCE_DIR}/sol.hpp)
        message(FATAL_ERROR 
            "[Sol2] Headers not found in: ${SOL2_SOURCE_DIR}\n"
            "Please ensure Sol2 sources are in external/sol2/")
    endif()
endif()

#-------------------------------------------------------------------------------
# Create Interface Library
#-------------------------------------------------------------------------------
# Sol2 is header-only, so we create an INTERFACE library
add_library(sol2 INTERFACE)

# Add include directories (support both standard and single-header layouts)
if(EXISTS ${SOL2_SOURCE_DIR}/include)
    target_include_directories(sol2 INTERFACE ${SOL2_SOURCE_DIR}/include)
else()
    target_include_directories(sol2 INTERFACE ${SOL2_SOURCE_DIR})
endif()

#-------------------------------------------------------------------------------
# Dependencies
#-------------------------------------------------------------------------------
# Sol2 requires Lua - link it as an interface dependency
# This ensures any target linking sol2 also gets lua
target_link_libraries(sol2 INTERFACE lua)

message(STATUS "[Sol2] Configured as header-only library (depends on Lua)")
