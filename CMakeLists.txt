#[[
================================================================================
  Spark2D Engine - Lightweight 2D Game Engine
================================================================================

  A lightweight 2D game engine built with:
    - SDL2        : Cross-platform multimedia library (windowing, input, audio)
    - SDL2_image  : Image loading (PNG, JPG, etc.)
    - SDL2_mixer  : Audio mixing and playback
    - SDL2_ttf    : TrueType font rendering
    - Lua + Sol2  : Scripting support
    - ImGui       : Immediate mode GUI for debugging/tools
    - GLM         : OpenGL Mathematics library

  Build Instructions:
    mkdir build && cd build
    cmake ..
    make

  Options:
    -DUSE_SYSTEM_SDL2=ON       Use system-installed SDL2 instead of building
    -DUSE_SYSTEM_SDL2_IMAGE=ON Use system-installed SDL2_image
    -DUSE_SYSTEM_SDL2_MIXER=ON Use system-installed SDL2_mixer
    -DUSE_SYSTEM_SDL2_TTF=ON   Use system-installed SDL2_ttf

================================================================================
]]

cmake_minimum_required(VERSION 3.21)

#===============================================================================
# CMake Policies
#===============================================================================
# Set policy version to match minimum required
cmake_policy(VERSION 3.21)

# CMP0077: option() honors normal variables (if defined earlier in CMakeLists)
# This allows us to set cache variables before add_subdirectory() calls
set(CMAKE_POLICY_DEFAULT_CMP0077 NEW)

#===============================================================================
# Project Definition
#===============================================================================
project(Spark2D_Engine 
    VERSION 1.0.0
    DESCRIPTION "Spark2D Engine - A lightweight 2D game engine with Lua scripting"
    LANGUAGES CXX C
)

#===============================================================================
# C++ Standard Configuration
#===============================================================================
set(CMAKE_CXX_STANDARD 17)          # Use C++17 (change to 20 for C++20)
set(CMAKE_CXX_STANDARD_REQUIRED ON) # Enforce the standard
set(CMAKE_CXX_EXTENSIONS OFF)       # Disable compiler-specific extensions

# Generate compile_commands.json for LSP support (clangd, ccls, etc.)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

#===============================================================================
# Platform Detection & Configuration
#===============================================================================
if(UNIX AND NOT APPLE)
    message(STATUS "[Platform] Linux or FreeBSD detected")
elseif(APPLE)
    message(STATUS "[Platform] macOS detected")
elseif(WIN32)
    message(STATUS "[Platform] Windows detected")
    # Set MSYS2 UCRT64 compilers if environment variables are not set
    if(NOT DEFINED ENV{CC})
        set(CMAKE_C_COMPILER "C:/msys64/ucrt64/bin/gcc.exe" 
            CACHE FILEPATH "C Compiler" FORCE)
    endif()
    if(NOT DEFINED ENV{CXX})
        set(CMAKE_CXX_COMPILER "C:/msys64/ucrt64/bin/g++.exe" 
            CACHE FILEPATH "C++ Compiler" FORCE)
    endif()
else()
    message(WARNING "[Platform] Unknown or unsupported operating system")
endif()

#===============================================================================
# Build Configuration
#===============================================================================
# Output directories
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/libs/compiled)

# Verbose output (useful for debugging build issues)
set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--verbose")

# Compiler warnings
# -Wall              : Enable all common warnings
# -Wfatal-errors     : Stop on first error (makes debugging easier)
# -Wno-template-body : Ignore template body warnings (sol2 has known issues) - C++ only
add_compile_options(-Wall -Wfatal-errors)
add_compile_options($<$<COMPILE_LANGUAGE:CXX>:-Wno-template-body>)
# Uncomment to treat warnings as errors:
# add_compile_options(-Werror)

#===============================================================================
# SDL2 Library Options
#===============================================================================
# These options allow using system-installed libraries instead of building from
# source. This can speed up builds if the libraries are already installed.
# Usage: cmake -DUSE_SYSTEM_SDL2=ON ..

option(USE_SYSTEM_SDL2       "Use system SDL2 (find_package) instead of building"       OFF)
option(USE_SYSTEM_SDL2_IMAGE "Use system SDL2_image instead of building"                OFF)
option(USE_SYSTEM_SDL2_MIXER "Use system SDL2_mixer instead of building"                OFF)
option(USE_SYSTEM_SDL2_TTF   "Use system SDL2_ttf instead of building"                  OFF)

#===============================================================================
# External Libraries Configuration
#===============================================================================
# Each library is configured in its own cmake file for better organization.
# Libraries are built as shared (.so/.dll) or static (.a/.lib) as configured.

message(STATUS "")
message(STATUS "========== Configuring External Libraries ==========")

#-------------------------------------------------------------------------------
# Step 1: SDL2 Core Library (must be first - other SDL libs depend on it)
#-------------------------------------------------------------------------------
if(USE_SYSTEM_SDL2)
    find_package(SDL2 REQUIRED)
    message(STATUS "[SDL2] Using system-installed library")
else()
    include(${CMAKE_SOURCE_DIR}/cmake/sdl2.cmake)
endif()
set(SDL2_LIBRARIES SDL2::SDL2)

#-------------------------------------------------------------------------------
# Step 2: SDL2 Extension Libraries (depend on SDL2 core)
#-------------------------------------------------------------------------------
# SDL2_image - Image file loading
if(USE_SYSTEM_SDL2_IMAGE)
    find_package(SDL2_image REQUIRED)
    message(STATUS "[SDL2_image] Using system-installed library")
else()
    include(${CMAKE_SOURCE_DIR}/cmake/sdl2_image.cmake)
endif()
set(SDL2_IMAGE_LIBRARIES SDL2_image::SDL2_image)

# SDL2_mixer - Audio mixing
if(USE_SYSTEM_SDL2_MIXER)
    find_package(SDL2_mixer REQUIRED)
    message(STATUS "[SDL2_mixer] Using system-installed library")
else()
    include(${CMAKE_SOURCE_DIR}/cmake/sdl2_mixer.cmake)
endif()
set(SDL2_MIXER_LIBRARIES SDL2_mixer::SDL2_mixer)

# SDL2_ttf - TrueType font rendering
if(USE_SYSTEM_SDL2_TTF)
    find_package(SDL2_ttf REQUIRED)
    message(STATUS "[SDL2_ttf] Using system-installed library")
else()
    include(${CMAKE_SOURCE_DIR}/cmake/sdl2_ttf.cmake)
endif()
set(SDL2_TTF_LIBRARIES SDL2_ttf::SDL2_ttf)

#-------------------------------------------------------------------------------
# Step 3: Mathematics Library (header-only)
#-------------------------------------------------------------------------------
include(${CMAKE_SOURCE_DIR}/cmake/glm.cmake)

#-------------------------------------------------------------------------------
# Step 4: Scripting Support (Lua + Sol2 bindings)
#-------------------------------------------------------------------------------
include(${CMAKE_SOURCE_DIR}/cmake/lua.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/sol2.cmake)

#-------------------------------------------------------------------------------
# Step 5: GUI Library (requires SDL2)
#-------------------------------------------------------------------------------
include(${CMAKE_SOURCE_DIR}/cmake/imgui.cmake)

message(STATUS "========== All Libraries Configured ==========")
message(STATUS "")

#===============================================================================
# Main Executable
#===============================================================================
message(STATUS "Configuring main executable: ${PROJECT_NAME}")

# Source files for the main executable
# Organized by module for easy navigation
set(SOURCES
    # Entry point
    src/Main.cpp
    
    # Core engine systems
    # src/Core/Window.cpp
    # src/Core/Engine.cpp
    
    # Game framework
    src/Game/Game.cpp
    
    # Graphics subsystem
    # src/Graphics/Texture.cpp
    # src/Graphics/Sprite.cpp
    # src/Graphics/Renderer.cpp
    
    # Input handling
    # src/Input/InputManager.cpp
    
    # Audio subsystem
    # src/Audio/AudioManager.cpp
    
    # Scripting (Lua)
    # src/Scripting/ScriptManager.cpp
    
    # Header-only modules (listed for IDE integration):
    # - src/Core/Logger.hpp
    # - src/Scene/Scene.hpp
    # - src/Scene/SceneManager.hpp
    # - src/Utils/Timer.hpp
    # - src/Utils/Math.hpp
    # - src/Utils/ResourceManager.hpp
)

add_executable(${PROJECT_NAME} ${SOURCES})

#-------------------------------------------------------------------------------
# Link Libraries
#-------------------------------------------------------------------------------
# Link order matters! Dependencies should come after dependents.
# Example: imgui uses SDL2, so SDL2 should be listed after imgui.

target_link_libraries(${PROJECT_NAME} PRIVATE
    # Scripting
    sol2                        # C++ Lua bindings (header-only, links lua)
    lua                         # Lua interpreter
    
    # GUI
    imgui                       # Immediate mode GUI
    
    # SDL2 extensions (must come before SDL2 core)
    ${SDL2_IMAGE_LIBRARIES}     # Image loading
    ${SDL2_MIXER_LIBRARIES}     # Audio mixing
    ${SDL2_TTF_LIBRARIES}       # Font rendering
    freetype                    # Font library (required by SDL2_ttf)
    
    # SDL2 core
    SDL2::SDL2main              # Platform-specific main() wrapper
    ${SDL2_LIBRARIES}           # SDL2 core library
    
    # Mathematics
    glm                         # OpenGL Mathematics (header-only)
)

#===============================================================================
# Post-Build Commands
#===============================================================================
# Copy required DLLs to the executable directory (Windows only)
if(WIN32)
    # Use generator expressions to get the actual DLL paths from targets
    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            $<TARGET_FILE:SDL2::SDL2>
            $<TARGET_FILE_DIR:${PROJECT_NAME}>
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            $<TARGET_FILE:SDL2_image::SDL2_image>
            $<TARGET_FILE_DIR:${PROJECT_NAME}>
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            $<TARGET_FILE:SDL2_mixer::SDL2_mixer>
            $<TARGET_FILE_DIR:${PROJECT_NAME}>
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            $<TARGET_FILE:SDL2_ttf::SDL2_ttf>
            $<TARGET_FILE_DIR:${PROJECT_NAME}>
        COMMENT "Copying SDL2 DLLs to output directory..."
    )
endif()

#===============================================================================
# Build Summary
#===============================================================================
message(STATUS "")
message(STATUS "================== Build Configuration ==================")
message(STATUS "  Project:        ${PROJECT_NAME} v${PROJECT_VERSION}")
message(STATUS "  C++ Standard:   ${CMAKE_CXX_STANDARD}")
message(STATUS "  Build Type:     ${CMAKE_BUILD_TYPE}")
message(STATUS "  Install Prefix: ${CMAKE_INSTALL_PREFIX}")
message(STATUS "=========================================================")
message(STATUS "")
