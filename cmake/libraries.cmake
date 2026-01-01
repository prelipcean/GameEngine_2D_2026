#[[
================================================================================
  External Libraries Master Configuration
================================================================================

  Purpose:
    This is the master configuration file that includes all external library
    configurations in the correct order. Include this file in the main 
    CMakeLists.txt instead of including each library file individually.

  Usage:
    In your main CMakeLists.txt, simply add:
      include(${CMAKE_SOURCE_DIR}/cmake/libraries.cmake)

  Library Load Order:
    The order matters! Dependencies must be loaded before dependents.
    
    1. SDL2 Core        - Base multimedia library
    2. SDL2 Extensions  - Image, Mixer, TTF (depend on SDL2)
    3. GLM              - Math library (header-only, no dependencies)
    4. Lua              - Scripting language
    5. Sol2             - C++ Lua bindings (depends on Lua)
    6. ImGui            - GUI library (depends on SDL2)

  Options (set before including this file):
    USE_SYSTEM_SDL2       - Use system SDL2 instead of building
    USE_SYSTEM_SDL2_IMAGE - Use system SDL2_image
    USE_SYSTEM_SDL2_MIXER - Use system SDL2_mixer
    USE_SYSTEM_SDL2_TTF   - Use system SDL2_ttf

================================================================================
]]

message(STATUS "")
message(STATUS "========== Configuring External Libraries ==========")

#-------------------------------------------------------------------------------
# Step 1: SDL2 Core (must be first - other SDL libs depend on it)
#-------------------------------------------------------------------------------
if(USE_SYSTEM_SDL2)
    find_package(SDL2 REQUIRED)
    message(STATUS "[SDL2] Using system-installed library")
else()
    include(${CMAKE_SOURCE_DIR}/cmake/sdl2.cmake)
endif()

#-------------------------------------------------------------------------------
# Step 2: SDL2 Extension Libraries
#-------------------------------------------------------------------------------
# SDL2_image - Image loading (PNG, JPG, etc.)
if(USE_SYSTEM_SDL2_IMAGE)
    find_package(SDL2_image REQUIRED)
    message(STATUS "[SDL2_image] Using system-installed library")
else()
    include(${CMAKE_SOURCE_DIR}/cmake/sdl2_image.cmake)
endif()

# SDL2_mixer - Audio mixing
if(USE_SYSTEM_SDL2_MIXER)
    find_package(SDL2_mixer REQUIRED)
    message(STATUS "[SDL2_mixer] Using system-installed library")
else()
    include(${CMAKE_SOURCE_DIR}/cmake/sdl2_mixer.cmake)
endif()

# SDL2_ttf - TrueType font rendering
if(USE_SYSTEM_SDL2_TTF)
    find_package(SDL2_ttf REQUIRED)
    message(STATUS "[SDL2_ttf] Using system-installed library")
else()
    include(${CMAKE_SOURCE_DIR}/cmake/sdl2_ttf.cmake)
endif()

#-------------------------------------------------------------------------------
# Step 3: Mathematics Library (header-only)
#-------------------------------------------------------------------------------
include(${CMAKE_SOURCE_DIR}/cmake/glm.cmake)

#-------------------------------------------------------------------------------
# Step 4: Scripting Support
#-------------------------------------------------------------------------------
# Lua scripting language
include(${CMAKE_SOURCE_DIR}/cmake/lua.cmake)

# Sol2 - Modern C++ bindings for Lua (depends on Lua)
include(${CMAKE_SOURCE_DIR}/cmake/sol2.cmake)

#-------------------------------------------------------------------------------
# Step 5: GUI Library (depends on SDL2)
#-------------------------------------------------------------------------------
include(${CMAKE_SOURCE_DIR}/cmake/imgui.cmake)

message(STATUS "========== All Libraries Configured ==========")
message(STATUS "")
