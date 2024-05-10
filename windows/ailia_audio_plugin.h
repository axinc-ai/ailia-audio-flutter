#ifndef FLUTTER_PLUGIN_AILIA_AUDIO_PLUGIN_H_
#define FLUTTER_PLUGIN_AILIA_AUDIO_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace ailia_audio {

class AiliaAudioPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  AiliaAudioPlugin();

  virtual ~AiliaAudioPlugin();

  // Disallow copy and assign.
  AiliaAudioPlugin(const AiliaAudioPlugin&) = delete;
  AiliaAudioPlugin& operator=(const AiliaAudioPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace ailia_audio

#endif  // FLUTTER_PLUGIN_AILIA_AUDIO_PLUGIN_H_
