#[[
================================================================================
  Lua Scripting Language Library Configuration
================================================================================

  Purpose:
    Configures Lua - a powerful, efficient, lightweight, embeddable scripting 
    language. Lua is commonly used for game scripting, configuration, and
    extending applications.

  Build Type:
    Static library (.a on Linux, .lib on Windows)

  Features:
    - Lightweight and fast
    - Easy C/C++ integration
    - Garbage collected
    - Dynamic typing
    - First-class functions and closures

  Targets Created:
    lua  - Static Lua library

  Dependencies:
    - Math library (m) on Unix systems

  Usage:
    Use with Sol2 for modern C++ bindings, or use the C API directly.

  Source:
    Built from: ${CMAKE_SOURCE_DIR}/external/lua

  Version:
    Lua 5.4.x (check external/lua for exact version)

================================================================================
]]

#-------------------------------------------------------------------------------
# Configuration
#-------------------------------------------------------------------------------
set(LUA_SOURCE_DIR ${CMAKE_SOURCE_DIR}/external/lua)

# Verify source directory exists
if(NOT EXISTS ${LUA_SOURCE_DIR}/lua.h)
    message(FATAL_ERROR 
        "[Lua] Source not found: ${LUA_SOURCE_DIR}/lua.h\n"
        "Please ensure Lua sources are in external/lua/")
endif()

#-------------------------------------------------------------------------------
# Source Files
#-------------------------------------------------------------------------------
# Core Lua source files organized by category

# Core Language Implementation
set(LUA_CORE_SOURCES
    ${LUA_SOURCE_DIR}/lapi.c        # C API
    ${LUA_SOURCE_DIR}/lcode.c       # Code generator
    ${LUA_SOURCE_DIR}/lctype.c      # Character type functions
    ${LUA_SOURCE_DIR}/ldebug.c      # Debug interface
    ${LUA_SOURCE_DIR}/ldo.c         # Stack and call structure
    ${LUA_SOURCE_DIR}/ldump.c       # Save precompiled chunks
    ${LUA_SOURCE_DIR}/lfunc.c       # Function prototypes
    ${LUA_SOURCE_DIR}/lgc.c         # Garbage collector
    ${LUA_SOURCE_DIR}/llex.c        # Lexical analyzer
    ${LUA_SOURCE_DIR}/lmem.c        # Memory manager
    ${LUA_SOURCE_DIR}/lobject.c     # Object manipulation
    ${LUA_SOURCE_DIR}/lopcodes.c    # Opcodes for VM
    ${LUA_SOURCE_DIR}/lparser.c     # Parser
    ${LUA_SOURCE_DIR}/lstate.c      # Global state
    ${LUA_SOURCE_DIR}/lstring.c     # String table
    ${LUA_SOURCE_DIR}/ltable.c      # Tables (associative arrays)
    ${LUA_SOURCE_DIR}/ltm.c         # Tag methods
    ${LUA_SOURCE_DIR}/lundump.c     # Load precompiled chunks
    ${LUA_SOURCE_DIR}/lvm.c         # Virtual machine
    ${LUA_SOURCE_DIR}/lzio.c        # Buffered streams
)

# Standard Libraries
set(LUA_LIB_SOURCES
    ${LUA_SOURCE_DIR}/lauxlib.c     # Auxiliary library
    ${LUA_SOURCE_DIR}/lbaselib.c    # Basic library
    ${LUA_SOURCE_DIR}/lcorolib.c    # Coroutine library
    ${LUA_SOURCE_DIR}/ldblib.c      # Debug library
    ${LUA_SOURCE_DIR}/linit.c       # Library initialization
    ${LUA_SOURCE_DIR}/liolib.c      # I/O library
    ${LUA_SOURCE_DIR}/lmathlib.c    # Math library
    ${LUA_SOURCE_DIR}/loadlib.c     # Package/module loader
    ${LUA_SOURCE_DIR}/loslib.c      # OS library
    ${LUA_SOURCE_DIR}/lstrlib.c     # String library
    ${LUA_SOURCE_DIR}/ltablib.c     # Table library
    ${LUA_SOURCE_DIR}/lutf8lib.c    # UTF-8 library
)

# Combined source list
set(LUA_SOURCES ${LUA_CORE_SOURCES} ${LUA_LIB_SOURCES})

#-------------------------------------------------------------------------------
# Create Static Library
#-------------------------------------------------------------------------------
add_library(lua STATIC ${LUA_SOURCES})

target_include_directories(lua PUBLIC ${LUA_SOURCE_DIR})

#-------------------------------------------------------------------------------
# Platform-Specific Configuration
#-------------------------------------------------------------------------------
# Lua needs the math library on Unix systems
if(UNIX)
    target_link_libraries(lua PUBLIC m)
endif()

message(STATUS "[Lua] Configured as static library")
