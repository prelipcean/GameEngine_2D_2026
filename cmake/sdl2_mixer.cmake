#[[
================================================================================
  SDL2_mixer Library Configuration
================================================================================

  Purpose:
    Configures SDL2_mixer - an audio mixing library supporting multiple 
    simultaneous audio channels, music playback, and various audio formats.

  Build Type:
    Shared library (.so on Linux, .dll on Windows)

  Dependencies:
    - SDL2 (must be configured before this file)

  Targets Created:
    SDL2_mixer::SDL2_mixer  - Main SDL2_mixer library

  Variables Set:
    SDL2_MIXER_LIBRARIES     - Libraries to link against
    SDL2_MIXER_INCLUDE_DIRS  - Include directories

  Note:
    Optional audio backends are disabled to avoid missing dependency errors.
    Enable them if you have the required libraries installed.

  Source:
    Built from: ${CMAKE_SOURCE_DIR}/external/SDL2_mixer

================================================================================
]]

#-------------------------------------------------------------------------------
# Configuration
#-------------------------------------------------------------------------------
set(SDL2_MIXER_SOURCE_DIR ${CMAKE_SOURCE_DIR}/external/SDL2_mixer)

# Verify source directory exists
if(NOT EXISTS ${SDL2_MIXER_SOURCE_DIR}/CMakeLists.txt)
    message(FATAL_ERROR 
        "[SDL2_mixer] Source directory not found: ${SDL2_MIXER_SOURCE_DIR}\n"
        "Please ensure SDL2_mixer sources are in external/SDL2_mixer/")
endif()

#-------------------------------------------------------------------------------
# Build Options
#-------------------------------------------------------------------------------
# Build as shared library (DLL/SO)
set(SDL2MIXER_SHARED ON  CACHE BOOL "Build SDL2_mixer as a shared library" FORCE)
set(SDL2MIXER_STATIC OFF CACHE BOOL "Do not build SDL2_mixer as a static library" FORCE)

#-------------------------------------------------------------------------------
# Audio Backend Options
#-------------------------------------------------------------------------------
# Disable optional audio backends to avoid missing dependency errors.
# Enable any of these if you have the required libraries installed:
#   - SDL2MIXER_OPUS=ON     requires: libopusfile
#   - SDL2MIXER_FLAC=ON     requires: libflac
#   - SDL2MIXER_MPG123=ON   requires: libmpg123
#   - SDL2MIXER_MOD=ON      requires: libmodplug or libxmp

set(SDL2MIXER_OPUS       OFF CACHE BOOL "Disable OpusFile support"  FORCE)
set(SDL2MIXER_XMP        OFF CACHE BOOL "Disable libxmp support"    FORCE)
set(SDL2MIXER_MOD        OFF CACHE BOOL "Disable MOD music support" FORCE)
set(SDL2MIXER_MOD_MODPLUG OFF CACHE BOOL "Disable modplug support"  FORCE)
set(SDL2MIXER_GME        OFF CACHE BOOL "Disable GME music support" FORCE)
set(SDL2MIXER_FLAC       OFF CACHE BOOL "Disable FLAC support"      FORCE)
set(SDL2MIXER_MPG123     OFF CACHE BOOL "Disable mpg123 support"    FORCE)
set(SDL2MIXER_MAD        OFF CACHE BOOL "Disable MAD MP3 support"   FORCE)
set(SDL2MIXER_MIDI       OFF CACHE BOOL "Disable MIDI support"      FORCE)
set(SDL2MIXER_WAVPACK    OFF CACHE BOOL "Disable WavPack support"   FORCE)

#-------------------------------------------------------------------------------
# Add SDL2_mixer Subdirectory
#-------------------------------------------------------------------------------
add_subdirectory(
    ${SDL2_MIXER_SOURCE_DIR} 
    ${CMAKE_BINARY_DIR}/SDL2_mixer-build
)

#-------------------------------------------------------------------------------
# Export Variables
#-------------------------------------------------------------------------------
set(SDL2_MIXER_LIBRARIES SDL2_mixer::SDL2_mixer)
set(SDL2_MIXER_INCLUDE_DIRS ${SDL2_MIXER_SOURCE_DIR}/include)

# Make headers available globally
include_directories(${SDL2_MIXER_INCLUDE_DIRS})

message(STATUS "[SDL2_mixer] Configured as shared library (optional backends disabled)")
