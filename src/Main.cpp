#include <iostream>
#include <SDL.h>
#include <SDL_image.h>
#include <SDL_mixer.h>
#include <SDL_ttf.h>
#include <glm/glm.hpp>
#include <imgui.h>
// #include <sol/sol.hpp>



int main(int argc, char* argv[])
{
  // Print SDL version
  SDL_version compiled;
  SDL_VERSION(&compiled);
  std::cout << "SDL version: "
            << static_cast<int>(compiled.major) << "."
            << static_cast<int>(compiled.minor) << "."
            << static_cast<int>(compiled.patch) << std::endl;

  // Print SDL_image version
  const SDL_version* img_ver = IMG_Linked_Version();
  std::cout << "SDL_image version: "
            << static_cast<int>(img_ver->major) << "."
            << static_cast<int>(img_ver->minor) << "."
            << static_cast<int>(img_ver->patch) << std::endl;

  // Print SDL_mixer version
  const SDL_version* mix_ver = Mix_Linked_Version();
  std::cout << "SDL_mixer version: "
            << static_cast<int>(mix_ver->major) << "."
            << static_cast<int>(mix_ver->minor) << "."
            << static_cast<int>(mix_ver->patch) << std::endl;

  // Print SDL_ttf version
  const SDL_version* ttf_ver = TTF_Linked_Version();
  std::cout << "SDL_ttf version: "
            << static_cast<int>(ttf_ver->major) << "."
            << static_cast<int>(ttf_ver->minor) << "."
            << static_cast<int>(ttf_ver->patch) << std::endl;

  // Print GLM version
  std::cout << "GLM version: "
            << GLM_VERSION_MAJOR << "."
            << GLM_VERSION_MINOR << "."
            << GLM_VERSION_PATCH << std::endl;

  // Print ImGui version
  std::cout << "ImGui version: " << IMGUI_VERSION << std::endl;

  // Print Sol2 version
// #ifdef SOL_VERSION
//   std::cout << "Sol2 version: " << SOL_VERSION << std::endl;
// #else
//   std::cout << "Sol2 version: (macro SOL_VERSION not defined)" << std::endl;
// #endif

  SDL_Init(SDL_INIT_EVERYTHING);
  SDL_Quit();
  return 0;
}

