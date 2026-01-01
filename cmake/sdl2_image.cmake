#[[
================================================================================
  SDL2_image Library Configuration
================================================================================

  Purpose:
    Configures SDL2_image - an image loading library that supports formats
    like PNG, JPG, BMP, GIF, TIF, and more.

  Build Type:
    Shared library (.so on Linux, .dll on Windows)

  Dependencies:
    - SDL2 (must be configured before this file)

  Targets Created:
    SDL2_image::SDL2_image  - Main SDL2_image library

  Variables Set:
    SDL2_IMAGE_LIBRARIES     - Libraries to link against
    SDL2_IMAGE_INCLUDE_DIRS  - Include directories

  Source:
    Built from: ${CMAKE_SOURCE_DIR}/external/SDL2_image

================================================================================
]]

#-------------------------------------------------------------------------------
# Configuration
#-------------------------------------------------------------------------------
set(SDL2_IMAGE_SOURCE_DIR ${CMAKE_SOURCE_DIR}/external/SDL2_image)

# Verify source directory exists
if(NOT EXISTS ${SDL2_IMAGE_SOURCE_DIR}/CMakeLists.txt)
    message(FATAL_ERROR 
        "[SDL2_image] Source directory not found: ${SDL2_IMAGE_SOURCE_DIR}\n"
        "Please ensure SDL2_image sources are in external/SDL2_image/")
endif()

#-------------------------------------------------------------------------------
# Build Options
#-------------------------------------------------------------------------------
# Build as shared library (DLL/SO)
set(SDL2IMAGE_SHARED ON  CACHE BOOL "Build SDL2_image as a shared library" FORCE)
set(SDL2IMAGE_STATIC OFF CACHE BOOL "Do not build SDL2_image as a static library" FORCE)

#-------------------------------------------------------------------------------
# Add SDL2_image Subdirectory
#-------------------------------------------------------------------------------
add_subdirectory(
    ${SDL2_IMAGE_SOURCE_DIR} 
    ${CMAKE_BINARY_DIR}/SDL2_image-build
)

#-------------------------------------------------------------------------------
# Export Variables
#-------------------------------------------------------------------------------
set(SDL2_IMAGE_LIBRARIES SDL2_image::SDL2_image)
set(SDL2_IMAGE_INCLUDE_DIRS ${SDL2_IMAGE_SOURCE_DIR}/include)

# Make headers available globally
include_directories(${SDL2_IMAGE_INCLUDE_DIRS})

message(STATUS "[SDL2_image] Configured as shared library (built from source)")
