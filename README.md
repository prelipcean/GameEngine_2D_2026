# Spark2D Engine

A lightweight, cross-platform 2D game engine built with modern C++ and Lua scripting.

---

## Features

- **Cross-Platform** - Runs on Linux, macOS, Windows, and FreeBSD
- **Lua Scripting** - Game logic with Sol2 C++ bindings for seamless integration
- **Real-Time Rendering** - Smooth, immediate visual updates via SDL2
- **ImGui Integration** - Built-in debugging tools and editor interface
- **Modular Architecture** - Clean separation of engine components
- **Easy Build System** - Simple build script with CMake backend

---

## Libraries & Dependencies

| Library | Purpose |
|---------|---------|
| [SDL2](https://www.libsdl.org/) | Windowing, input, and audio |
| [SDL2_image](https://github.com/libsdl-org/SDL_image) | Image loading (PNG, JPG, etc.) |
| [SDL2_ttf](https://github.com/libsdl-org/SDL_ttf) | TrueType font rendering |
| [SDL2_mixer](https://github.com/libsdl-org/SDL_mixer) | Audio mixing and playback |
| [Lua](https://www.lua.org/) | Scripting language |
| [Sol2](https://github.com/ThePhD/sol2) | Modern C++ Lua bindings |
| [ImGui](https://github.com/ocornut/imgui) | Immediate mode GUI |
| [GLM](https://github.com/g-truc/glm) | OpenGL Mathematics library |

---

## Quick Start

### 1. Clone the Repository

```bash
git clone --recursive https://github.com/yourusername/Spark2D_Engine.git
cd Spark2D_Engine
```

If you already cloned without `--recursive`:
```bash
git submodule update --init --recursive
```

### 2. Build the Engine

```bash
./build.sh build
```

### 3. Run the Engine

```bash
./build.sh run
```

---

## Build Script Usage

The project includes a convenient build script with multiple options:

```bash
./build.sh [command] [options]
```

### Commands

| Command | Description |
|---------|-------------|
| `configure` | Configure the project with CMake |
| `build` | Build the project (configures if needed) |
| `quick` | Quick build (engine sources only, skips library rebuilds) |
| `rebuild` | Clean and rebuild from scratch |
| `clean` | Remove the build directory and compiled libraries |
| `run` | Build (if needed) and run the executable |
| `help` | Show help with system information |

### Options

| Option | Description |
|--------|-------------|
| `--release` | Build in Release mode (optimized) |
| `--debug` | Build in Debug mode (default) |
| `--verbose` | Show detailed build output |

### Examples

```bash
./build.sh                      # Build in debug mode
./build.sh quick                # Quick rebuild (engine only)
./build.sh build --release      # Build in release mode
./build.sh rebuild --release    # Clean rebuild for release
./build.sh run                  # Build and run
./build.sh help                 # Show help and system info
```

### Development Workflow

For faster iteration during development:

```bash
# First time: full build (compiles all libraries ~5-10 min)
./build.sh build

# During development: quick builds (engine only, ~seconds)
./build.sh quick

# After changing CMake files or external libraries
./build.sh rebuild
```

---

## Manual CMake Build

If you prefer to use CMake directly:

```bash
mkdir build && cd build
cmake ..
make -j$(nproc)
./Spark2D_Engine
```

### CMake Options

You can use system-installed libraries instead of building from source:

```bash
cmake -DUSE_SYSTEM_SDL2=ON \
      -DUSE_SYSTEM_SDL2_IMAGE=ON \
      -DUSE_SYSTEM_SDL2_MIXER=ON \
      -DUSE_SYSTEM_SDL2_TTF=ON \
      ..
```

---

## Installing System Dependencies (Optional)

The engine can build all dependencies from source (via git submodules), but you can optionally install system libraries for faster builds.

### Debian / Ubuntu

```bash
sudo apt install build-essential cmake
sudo apt install libsdl2-dev libsdl2-image-dev libsdl2-ttf-dev libsdl2-mixer-dev
sudo apt install liblua5.4-dev
```

### Arch Linux

```bash
sudo pacman -S base-devel cmake sdl2 sdl2_image sdl2_ttf sdl2_mixer lua
```

### Fedora

```bash
sudo dnf install gcc-c++ cmake
sudo dnf install SDL2-devel SDL2_image-devel SDL2_ttf-devel SDL2_mixer-devel lua-devel
```

### FreeBSD

```bash
sudo pkg install cmake sdl2 sdl2_image sdl2_ttf sdl2_mixer lua54
```

### macOS

```bash
brew install cmake sdl2 sdl2_image sdl2_ttf sdl2_mixer lua
```

### Windows (MSYS2)

```bash
pacman -S mingw-w64-ucrt-x86_64-cmake
pacman -S mingw-w64-ucrt-x86_64-SDL2 mingw-w64-ucrt-x86_64-SDL2_image
pacman -S mingw-w64-ucrt-x86_64-SDL2_ttf mingw-w64-ucrt-x86_64-SDL2_mixer
pacman -S mingw-w64-ucrt-x86_64-lua
```

### Windows (vcpkg)

```bash
vcpkg install sdl2 sdl2-image sdl2-ttf sdl2-mixer lua
```

---

## Project Structure

```
Spark2D_Engine/
├── CMakeLists.txt          # Main CMake configuration
├── build.sh                # Build script
├── src/                    # Engine source code
│   └── Main.cpp
├── assets/                 # Game assets
│   ├── fonts/
│   └── images/
├── cmake/                  # CMake library configurations
│   ├── sdl2.cmake
│   ├── sdl2_image.cmake
│   ├── sdl2_mixer.cmake
│   ├── sdl2_ttf.cmake
│   ├── lua.cmake
│   ├── sol2.cmake
│   ├── imgui.cmake
│   ├── glm.cmake
│   └── libraries.cmake
├── external/               # Git submodules (dependencies)
│   ├── SDL2/
│   ├── SDL2_image/
│   ├── SDL2_ttf/
│   ├── SDL2_mixer/
│   ├── lua/
│   ├── sol2/
│   ├── imgui/
│   └── glm/
├── libs/                   # Compiled libraries output
│   └── compiled/
└── build/                  # Build output (generated)
```

---

## Setting Up Git Submodules

If you need to add the submodules manually:

```bash
# Add submodules
git submodule add https://github.com/libsdl-org/SDL.git external/SDL2
git submodule add https://github.com/libsdl-org/SDL_image.git external/SDL2_image
git submodule add https://github.com/libsdl-org/SDL_ttf.git external/SDL2_ttf
git submodule add https://github.com/libsdl-org/SDL_mixer.git external/SDL2_mixer
git submodule add https://github.com/lua/lua.git external/lua
git submodule add https://github.com/ThePhD/sol2.git external/sol2
git submodule add https://github.com/ocornut/imgui.git external/imgui
git submodule add https://github.com/g-truc/glm.git external/glm

# Checkout specific versions (recommended for stability)
cd external/SDL2 && git checkout release-2.32.6 && cd ../..
cd external/SDL2_image && git checkout release-2.8.8 && cd ../..
cd external/SDL2_ttf && git checkout release-2.24.0 && cd ../..
cd external/SDL2_mixer && git checkout release-2.8.1 && cd ../..

# Commit the submodule configuration
git add .gitmodules external/
git commit -m "Add external library submodules"
```

---

## Troubleshooting

### Build fails with missing dependencies

The engine builds all dependencies from source by default. If CMake can't find something, ensure submodules are initialized:

```bash
git submodule update --init --recursive
```

### Lua linking issues on macOS

On macOS, Lua is typically installed as `lua` rather than `lua5.4`. The build system handles this automatically when building from source.

### Windows DLL errors

When running on Windows, ensure the SDL2 DLLs are in the same directory as the executable. The build system copies them automatically for builds from source.

### Download libraries manually

If package managers fail, download directly from official sources:

- [SDL2 Releases](https://github.com/libsdl-org/SDL/releases)
- [SDL2_image Releases](https://github.com/libsdl-org/SDL_image/releases)
- [SDL2_ttf Releases](https://github.com/libsdl-org/SDL_ttf/releases)
- [SDL2_mixer Releases](https://github.com/libsdl-org/SDL_mixer/releases)
- [Lua Downloads](https://www.lua.org/ftp/)
- [Sol2 Releases](https://github.com/ThePhD/sol2/releases)
- [ImGui Releases](https://github.com/ocornut/imgui/releases)
- [GLM Releases](https://github.com/g-truc/glm/releases)

---

## License

MIT License - See [LICENSE](LICENSE) for details.
