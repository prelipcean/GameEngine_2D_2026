#[[
================================================================================
  Dear ImGui Library Configuration
================================================================================

  Purpose:
    Configures Dear ImGui - a bloat-free graphical user interface library for 
    C++. ImGui is designed for creating fast debug tools, in-game menus, and
    editor interfaces.

  Build Type:
    Static library (.a on Linux, .lib on Windows)

  Features:
    - Immediate mode GUI (no state management needed)
    - Minimal dependencies
    - Highly portable
    - Built-in widgets (buttons, sliders, input fields, etc.)
    - Docking and multi-viewport support (optional)
    - Customizable styling

  Backend:
    This configuration uses SDL2 + SDL_Renderer backend:
    - imgui_impl_sdl2.cpp       : SDL2 platform backend
    - imgui_impl_sdlrenderer2.cpp : SDL2 Renderer backend

  Dependencies:
    - SDL2 (must be configured before this file)

  Targets Created:
    imgui  - Static ImGui library with SDL2 backend

  Usage in Code:
    #include "imgui.h"
    #include "imgui_impl_sdl2.h"
    #include "imgui_impl_sdlrenderer2.h"

    // In your initialization:
    ImGui::CreateContext();
    ImGui_ImplSDL2_InitForSDLRenderer(window, renderer);
    ImGui_ImplSDLRenderer2_Init(renderer);

    // In your render loop:
    ImGui_ImplSDLRenderer2_NewFrame();
    ImGui_ImplSDL2_NewFrame();
    ImGui::NewFrame();
    
    ImGui::Begin("Debug Window");
    ImGui::Text("Hello, ImGui!");
    ImGui::End();
    
    ImGui::Render();
    ImGui_ImplSDLRenderer2_RenderDrawData(ImGui::GetDrawData());

  Source:
    Built from: ${CMAKE_SOURCE_DIR}/external/imgui

  Documentation:
    https://github.com/ocornut/imgui

================================================================================
]]

#-------------------------------------------------------------------------------
# Configuration
#-------------------------------------------------------------------------------
set(IMGUI_SOURCE_DIR ${CMAKE_SOURCE_DIR}/external/imgui)

# Verify source directory exists
if(NOT EXISTS ${IMGUI_SOURCE_DIR}/imgui.h)
    message(FATAL_ERROR 
        "[ImGui] Source not found: ${IMGUI_SOURCE_DIR}/imgui.h\n"
        "Please ensure ImGui sources are in external/imgui/")
endif()

#-------------------------------------------------------------------------------
# Source Files
#-------------------------------------------------------------------------------
# Core ImGui sources
set(IMGUI_CORE_SOURCES
    ${IMGUI_SOURCE_DIR}/imgui.cpp           # Core ImGui functionality
    ${IMGUI_SOURCE_DIR}/imgui_demo.cpp      # Demo window (useful for learning)
    ${IMGUI_SOURCE_DIR}/imgui_draw.cpp      # Drawing/rendering
    ${IMGUI_SOURCE_DIR}/imgui_tables.cpp    # Table widget
    ${IMGUI_SOURCE_DIR}/imgui_widgets.cpp   # Standard widgets
)

# SDL2 Backend sources (platform + renderer)
set(IMGUI_BACKEND_SOURCES
    ${IMGUI_SOURCE_DIR}/backends/imgui_impl_sdl2.cpp         # SDL2 platform
    ${IMGUI_SOURCE_DIR}/backends/imgui_impl_sdlrenderer2.cpp # SDL2 Renderer
)

# Combined source list
set(IMGUI_SOURCES ${IMGUI_CORE_SOURCES} ${IMGUI_BACKEND_SOURCES})

#-------------------------------------------------------------------------------
# Create Static Library
#-------------------------------------------------------------------------------
add_library(imgui STATIC ${IMGUI_SOURCES})

# Include directories for ImGui headers
target_include_directories(imgui PUBLIC 
    ${IMGUI_SOURCE_DIR}           # Core headers (imgui.h, etc.)
    ${IMGUI_SOURCE_DIR}/backends  # Backend headers (imgui_impl_*.h)
)

#-------------------------------------------------------------------------------
# Dependencies
#-------------------------------------------------------------------------------
# ImGui SDL2 backend needs SDL2 headers
# Note: SDL2_INCLUDE_DIRS should be set by sdl2.cmake before this file runs
if(DEFINED SDL2_INCLUDE_DIRS)
    target_include_directories(imgui PUBLIC ${SDL2_INCLUDE_DIRS})
else()
    message(WARNING 
        "[ImGui] SDL2_INCLUDE_DIRS not defined. "
        "Ensure sdl2.cmake is included before imgui.cmake")
endif()

message(STATUS "[ImGui] Configured as static library (SDL2 + SDL_Renderer backend)")
