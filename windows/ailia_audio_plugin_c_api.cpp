#include "include/ailia_audio/ailia_audio_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "ailia_audio_plugin.h"

void AiliaAudioPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  ailia_audio::AiliaAudioPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
