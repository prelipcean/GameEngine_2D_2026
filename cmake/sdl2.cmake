#[[
================================================================================
  SDL2 Core Library Configuration
================================================================================

  Purpose:
    Configures SDL2 (Simple DirectMedia Layer) - a cross-platform library for
    low-level access to audio, keyboard, mouse, joystick, and graphics hardware.

  Build Type:
    Shared library (.so on Linux, .dll on Windows)

  Targets Created:
    SDL2::SDL2      - Main SDL2 library
    SDL2::SDL2main  - Platform-specific main() entry point wrapper

  Variables Set:
    SDL2_LIBRARIES     - Libraries to link against
    SDL2_INCLUDE_DIRS  - Include directories

  Source:
    Built from: ${CMAKE_SOURCE_DIR}/external/SDL2

================================================================================
]]

#-------------------------------------------------------------------------------
# Configuration
#-------------------------------------------------------------------------------
set(SDL2_SOURCE_DIR ${CMAKE_SOURCE_DIR}/external/SDL2)

# Verify source directory exists
if(NOT EXISTS ${SDL2_SOURCE_DIR}/CMakeLists.txt)
    message(FATAL_ERROR 
        "[SDL2] Source directory not found: ${SDL2_SOURCE_DIR}\n"
        "Please ensure SDL2 sources are in external/SDL2/")
endif()

#-------------------------------------------------------------------------------
# Build Options
#-------------------------------------------------------------------------------
# Build as shared library (DLL/SO)
set(SDL_SHARED ON  CACHE BOOL "Build SDL2 as a shared library" FORCE)
set(SDL_STATIC OFF CACHE BOOL "Do not build SDL2 as a static library" FORCE)

#-------------------------------------------------------------------------------
# Add SDL2 Subdirectory
#-------------------------------------------------------------------------------
add_subdirectory(
    ${SDL2_SOURCE_DIR} 
    ${CMAKE_BINARY_DIR}/SDL2-build
)

#-------------------------------------------------------------------------------
# Export Variables
#-------------------------------------------------------------------------------
set(SDL2_LIBRARIES SDL2::SDL2main SDL2::SDL2) 
set(SDL2_INCLUDE_DIRS ${SDL2_SOURCE_DIR}/include)

# Make headers available globally
include_directories(${SDL2_INCLUDE_DIRS})

message(STATUS "[SDL2] Configured as shared library (built from source)")
