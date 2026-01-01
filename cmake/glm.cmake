#[[
================================================================================
  GLM (OpenGL Mathematics) Library Configuration
================================================================================

  Purpose:
    Configures GLM - a header-only C++ mathematics library for graphics 
    software based on the OpenGL Shading Language (GLSL) specification.

  Build Type:
    Header-only (no compilation required)

  Features:
    - Vector and matrix types (vec2, vec3, vec4, mat3, mat4, etc.)
    - Transformations (translate, rotate, scale)
    - Quaternions for rotation
    - Trigonometric functions
    - Geometric functions (normalize, dot, cross, etc.)

  Targets Created:
    glm  - Interface library (header-only)

  Usage in Code:
    #include <glm/glm.hpp>
    #include <glm/gtc/matrix_transform.hpp>
    
    glm::vec3 position(1.0f, 2.0f, 3.0f);
    glm::mat4 model = glm::translate(glm::mat4(1.0f), position);

  Source:
    Located at: ${CMAKE_SOURCE_DIR}/external/glm

================================================================================
]]

#-------------------------------------------------------------------------------
# Configuration
#-------------------------------------------------------------------------------
set(GLM_SOURCE_DIR ${CMAKE_SOURCE_DIR}/external/glm)

# Verify source directory exists
if(NOT EXISTS ${GLM_SOURCE_DIR}/glm/glm.hpp)
    message(FATAL_ERROR 
        "[GLM] Header not found: ${GLM_SOURCE_DIR}/glm/glm.hpp\n"
        "Please ensure GLM sources are in external/glm/")
endif()

#-------------------------------------------------------------------------------
# Create Interface Library
#-------------------------------------------------------------------------------
# GLM is header-only, so we create an INTERFACE library
# This means no compilation, just include directories
add_library(glm INTERFACE)

target_include_directories(glm INTERFACE ${GLM_SOURCE_DIR})

message(STATUS "[GLM] Configured as header-only library")
