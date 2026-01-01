#[[
================================================================================
  SDL2_ttf Library Configuration
================================================================================

  Purpose:
    Configures SDL2_ttf - a TrueType font rendering library that allows 
    rendering high-quality text using TTF/OTF fonts.

  Build Type:
    Shared library (.so on Linux, .dll on Windows)

  Dependencies:
    - SDL2 (must be configured before this file)
    - FreeType (bundled/vendored version is used)

  Targets Created:
    SDL2_ttf::SDL2_ttf  - Main SDL2_ttf library
    freetype            - FreeType font engine (vendored)

  Variables Set:
    SDL2_TTF_LIBRARIES     - Libraries to link against
    SDL2_TTF_INCLUDE_DIRS  - Include directories

  Note:
    Uses vendored FreeType to avoid system dependency issues.
    This ensures consistent behavior across different systems.

  Source:
    Built from: ${CMAKE_SOURCE_DIR}/external/SDL2_ttf

================================================================================
]]

#-------------------------------------------------------------------------------
# Configuration
#-------------------------------------------------------------------------------
set(SDL2_TTF_SOURCE_DIR ${CMAKE_SOURCE_DIR}/external/SDL2_ttf)

# Verify source directory exists
if(NOT EXISTS ${SDL2_TTF_SOURCE_DIR}/CMakeLists.txt)
    message(FATAL_ERROR 
        "[SDL2_ttf] Source directory not found: ${SDL2_TTF_SOURCE_DIR}\n"
        "Please ensure SDL2_ttf sources are in external/SDL2_ttf/")
endif()

#-------------------------------------------------------------------------------
# Build Options
#-------------------------------------------------------------------------------
# Build as shared library (DLL/SO)
set(SDL2TTF_SHARED ON  CACHE BOOL "Build SDL2_ttf as a shared library" FORCE)
set(SDL2TTF_STATIC OFF CACHE BOOL "Do not build SDL2_ttf as a static library" FORCE)

# Use the bundled FreeType library instead of system FreeType
# This ensures consistent behavior and avoids missing dependency errors
set(SDL2TTF_VENDORED ON CACHE BOOL "Use vendored Freetype library" FORCE)

# Workaround: Force minimum CMake version for vendored FreeType
# Some older FreeType CMake configs require CMake >= 3.5
set(CMAKE_POLICY_VERSION_MINIMUM 3.5 CACHE STRING 
    "Force minimum CMake version for vendored FreeType" FORCE)

#-------------------------------------------------------------------------------
# Add SDL2_ttf Subdirectory
#-------------------------------------------------------------------------------
add_subdirectory(
    ${SDL2_TTF_SOURCE_DIR} 
    ${CMAKE_BINARY_DIR}/SDL2_ttf-build
)

#-------------------------------------------------------------------------------
# Export Variables
#-------------------------------------------------------------------------------
set(SDL2_TTF_LIBRARIES SDL2_ttf::SDL2_ttf)
set(SDL2_TTF_INCLUDE_DIRS ${SDL2_TTF_SOURCE_DIR}/include)

# Make headers available globally
include_directories(${SDL2_TTF_INCLUDE_DIRS})

message(STATUS "[SDL2_ttf] Configured as shared library (vendored FreeType)")
