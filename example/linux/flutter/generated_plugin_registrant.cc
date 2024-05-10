//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <ailia_audio/ailia_audio_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) ailia_audio_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "AiliaAudioPlugin");
  ailia_audio_plugin_register_with_registrar(ailia_audio_registrar);
}
