#!/bin/bash

#===============================================================================
# Spark2D Engine - Build Script
#===============================================================================
#
# A convenient build script for configuring, building, and running the engine.
#
# Usage: ./build.sh [command] [options]
#
# Commands:
#   configure  - Configure the project with CMake
#   build      - Build the project (configures if needed)
#   quick      - Quick build (engine only, skip library rebuilds)
#   rebuild    - Clean and rebuild the project
#   clean      - Remove the build directory
#   run        - Run the executable (builds if needed)
#   help       - Show this help message
#
# Options:
#   --release  - Build in Release mode (optimized)
#   --debug    - Build in Debug mode (default)
#   --verbose  - Show detailed build output
#
#===============================================================================

#-------------------------------------------------------------------------------
# Configuration
#-------------------------------------------------------------------------------
BUILD_DIR="build"
PROJECT_NAME="Spark2D_Engine"
BUILD_TYPE="Debug"
VERBOSE=""
NUM_CORES=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)

#-------------------------------------------------------------------------------
# Colors for output (disabled if not a terminal)
#-------------------------------------------------------------------------------
if [ -t 1 ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    CYAN='\033[0;36m'
    NC='\033[0m' # No Color
else
    RED='' GREEN='' YELLOW='' BLUE='' CYAN='' NC=''
fi

#-------------------------------------------------------------------------------
# Helper Functions
#-------------------------------------------------------------------------------
info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if a command exists
check_command() {
    if ! command -v "$1" &> /dev/null; then
        error "$1 is not installed or not in PATH"
        exit 1
    fi
}

#-------------------------------------------------------------------------------
# Build Commands
#-------------------------------------------------------------------------------
configure() {
    info "Configuring project (${BUILD_TYPE} mode)..."
    
    check_command cmake
    mkdir -p "$BUILD_DIR"
    
    # Detect platform and set appropriate generator
    case "$(uname -s)" in
        MINGW*|MSYS*|CYGWIN*)
            info "Platform: Windows (MSYS2/MinGW)"
            cmake -G "MinGW Makefiles" \
                  -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
                  -B "$BUILD_DIR" \
                  ${VERBOSE:+-DCMAKE_VERBOSE_MAKEFILE=ON}
            ;;
        Darwin*)
            info "Platform: macOS"
            cmake -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
                  -B "$BUILD_DIR" \
                  ${VERBOSE:+-DCMAKE_VERBOSE_MAKEFILE=ON}
            ;;
        Linux*)
            info "Platform: Linux"
            cmake -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
                  -B "$BUILD_DIR" \
                  ${VERBOSE:+-DCMAKE_VERBOSE_MAKEFILE=ON}
            ;;
        *)
            warning "Unknown platform: $(uname -s)"
            cmake -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
                  -B "$BUILD_DIR"
            ;;
    esac
    
    if [ $? -eq 0 ]; then
        success "Configuration complete!"
    else
        error "Configuration failed!"
        exit 1
    fi
}

build() {
    info "Building project with $NUM_CORES cores..."
    
    # Configure if build directory doesn't exist
    if [ ! -f "$BUILD_DIR/Makefile" ] && [ ! -f "$BUILD_DIR/build.ninja" ]; then
        configure
    fi
    
    cmake --build "$BUILD_DIR" --parallel "$NUM_CORES"
    
    if [ $? -eq 0 ]; then
        success "Build complete! Executable: $BUILD_DIR/$PROJECT_NAME"
    else
        error "Build failed!"
        exit 1
    fi
}

quick() {
    info "Quick build (engine sources only)..."
    
    # Check if project has been configured
    if [ ! -f "$BUILD_DIR/Makefile" ] && [ ! -f "$BUILD_DIR/build.ninja" ]; then
        error "Project not configured. Run './build.sh build' first."
        exit 1
    fi
    
    # Check if libraries have been built
    if [ ! -f "libs/compiled/liblua.a" ] && [ ! -f "libs/compiled/lua.lib" ]; then
        warning "Libraries not built. Running full build instead..."
        build
        return
    fi
    
    # Touch main source files to force recompilation (optional, CMake handles this)
    # Only build the main executable target, not all targets
    cmake --build "$BUILD_DIR" --target "$PROJECT_NAME" --parallel "$NUM_CORES"
    
    if [ $? -eq 0 ]; then
        success "Quick build complete! Executable: $BUILD_DIR/$PROJECT_NAME"
    else
        error "Quick build failed!"
        exit 1
    fi
}

rebuild() {
    info "Performing full rebuild..."
    clean
    configure
    build
}

clean() {
    info "Cleaning build directory..."
    
    if [ -d "$BUILD_DIR" ]; then
        rm -rf "$BUILD_DIR"
        success "Build directory removed"
    else
        warning "Build directory does not exist"
    fi
    
    # Also clean compiled libraries
    if [ -d "libs/compiled" ]; then
        info "Cleaning compiled libraries..."
        rm -rf libs/compiled/*
        success "Compiled libraries removed"
    fi
}

run() {
    local executable="$BUILD_DIR/$PROJECT_NAME"
    
    # On Windows, add .exe extension
    case "$(uname -s)" in
        MINGW*|MSYS*|CYGWIN*)
            executable="$BUILD_DIR/$PROJECT_NAME.exe"
            ;;
    esac
    
    # Build if executable doesn't exist
    if [ ! -f "$executable" ]; then
        warning "Executable not found, building first..."
        build
    fi
    
    info "Running $PROJECT_NAME..."
    echo "----------------------------------------"
    "$executable"
    local exit_code=$?
    echo "----------------------------------------"
    
    if [ $exit_code -eq 0 ]; then
        success "Program exited normally"
    else
        warning "Program exited with code: $exit_code"
    fi
}

help() {
    echo -e "${CYAN}"
    echo "==============================================================================="
    echo "  Spark2D Engine - Build Script"
    echo "==============================================================================="
    echo -e "${NC}"
    echo "Usage: ./build.sh [command] [options]"
    echo ""
    echo -e "${YELLOW}Commands:${NC}"
    echo "  configure  - Configure the project with CMake"
    echo "  build      - Build the project (configures if needed)"
    echo "  quick      - Quick build (engine sources only, skips library rebuilds)"
    echo "  rebuild    - Clean and rebuild the project from scratch"
    echo "  clean      - Remove the build directory and compiled libraries"
    echo "  run        - Run the executable (builds if needed)"
    echo "  help       - Show this help message"
    echo ""
    echo -e "${YELLOW}Options:${NC}"
    echo "  --release  - Build in Release mode (optimized, no debug symbols)"
    echo "  --debug    - Build in Debug mode (default, includes debug symbols)"
    echo "  --verbose  - Show detailed build output"
    echo ""
    echo -e "${YELLOW}Examples:${NC}"
    echo "  ./build.sh                    # Build in debug mode"
    echo "  ./build.sh quick              # Quick rebuild (engine only)"
    echo "  ./build.sh build --release    # Build in release mode"
    echo "  ./build.sh rebuild --release  # Clean rebuild in release mode"
    echo "  ./build.sh run                # Build (if needed) and run"
    echo ""
    echo -e "${YELLOW}Detected Configuration:${NC}"
    echo "  Platform:    $(uname -s)"
    echo "  CPU Cores:   $NUM_CORES"
    echo "  Build Dir:   $BUILD_DIR/"
    echo "  Executable:  $PROJECT_NAME"
    echo ""
}

#-------------------------------------------------------------------------------
# Parse Options
#-------------------------------------------------------------------------------
parse_options() {
    for arg in "$@"; do
        case "$arg" in
            --release)
                BUILD_TYPE="Release"
                ;;
            --debug)
                BUILD_TYPE="Debug"
                ;;
            --verbose)
                VERBOSE="1"
                ;;
        esac
    done
}

#-------------------------------------------------------------------------------
# Main Entry Point
#-------------------------------------------------------------------------------
parse_options "$@"

# Get command (first non-option argument, default to "build")
COMMAND="build"
for arg in "$@"; do
    case "$arg" in
        --*) ;; # Skip options
        *)
            COMMAND="$arg"
            break
            ;;
    esac
done

case "$COMMAND" in
    configure) configure ;;
    build)     build ;;
    quick)     quick ;;
    rebuild)   rebuild ;;
    clean)     clean ;;
    run)       run ;;
    help)      help ;;
    *)
        error "Unknown command: $COMMAND"
        echo ""
        help
        exit 1
        ;;
esac
