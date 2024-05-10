// ailia Audio Utility Class

import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:ffi/ffi.dart';
import 'ailia_audio.dart' as ailia_audio_dart;

class AiliaAudioModel {
  dynamic ailiaAudio;
  bool available = false;
  final int ailiaStatusSuccess = 0;
  bool debug = false;

  String ailiaCommonGetAudioPath() {
    if (Platform.isAndroid || Platform.isLinux) {
      return 'libailia_audio.so';
    }
    if (Platform.isMacOS) {
      return 'libailia_audio.dylib';
    }
    if (Platform.isWindows) {
      return 'ailia_audio.dll';
    }
    return 'internal';
  }

  DynamicLibrary ailiaCommonGetLibrary(String path) {
    final DynamicLibrary library;
    if (Platform.isIOS) {
      library = DynamicLibrary.process();
    } else {
      library = DynamicLibrary.open(path);
    }
    return library;
  }

  void open() {
    close();

    ailiaAudio = ailia_audio_dart
        .ailiaAudioFFI(ailiaCommonGetLibrary(ailiaCommonGetAudioPath()));

    available = true;
  }

  Float32List resample(Float32List src, int origSr, int targetSr) {
    Pointer<Float>? srcBufferOut;
    final Pointer<Uint32> dstSample = malloc<Uint32>();
    dstSample.value = 0;
    int status = ailiaAudio!.ailiaAudioGetResampleLen(
      dstSample,
      targetSr,
      src.length,
      origSr,
    );
    if (status != ailiaStatusSuccess) {
      throw Exception("ailiaAudioGetResampleLen error $status");
    }
    if (debug) {
      print(
          "convert sample rate $origSr to $targetSr, length ${src.length} to ${dstSample.value}");
    }
    // to be float
    final srcBufferIn = malloc<Float>(src.length);
    srcBufferOut = malloc<Float>(dstSample.value);
    for (int i = 0; i < src.length; i++) {
      srcBufferIn[i] = src[i];
    }
    status = ailiaAudio!.ailiaAudioResample(
      srcBufferOut,
      srcBufferIn,
      targetSr,
      dstSample.value,
      origSr,
      src.length,
    );
    if (status != ailiaStatusSuccess) {
      throw Exception("ailiaAudioResample error $status");
    }
    Float32List newSrcData = Float32List(dstSample.value);
    for (int i = 0; i < dstSample.value; i++) {
      newSrcData[i] = srcBufferOut[i].toDouble();
    }
    malloc.free(dstSample);
    malloc.free(srcBufferIn);
    malloc.free(srcBufferOut);
    return newSrcData;
  }

  Float32List melspectrogram(
    Float32List audioData,
    int windowSize,
    int hopSize,
    int sampleRate,
    double fmin,
    double fmax,
    double power,
    int nMel,
    int center,
  ) {
    int nFrame = 0;
    Pointer<Float>? mel;

    Pointer<Uint32> frameLength = malloc<Uint32>();
    frameLength.value = 0;
    int status = ailiaAudio!.ailiaAudioGetFrameLen(
      frameLength,
      audioData.length,
      windowSize,
      hopSize,
      center,
    );
    if (status != ailiaStatusSuccess) {
      throw Exception("ailiaAudioGetFrameLen error $status");
    }
    if (debug) {
      print(
          "audio frameLen=${frameLength.value}, audioDataLen=${audioData.length}, win=$windowSize, hop=$hopSize");
    }
    nFrame = frameLength.value;

    mel = malloc<Float>(nMel * nFrame);
    Pointer<Float> audioDataNative = malloc<Float>(audioData.length);
    for (int i = 0; i < audioData.length; i++) {
      audioDataNative[i] = audioData[i];
    }
    status = ailiaAudio!.ailiaAudioGetMelSpectrogram(
      mel,
      audioDataNative,
      audioData.length,
      sampleRate,
      windowSize,
      hopSize,
      windowSize,
      ailia_audio_dart.AILIA_AUDIO_WIN_TYPE_HANN,
      nFrame,
      center,
      power,
      ailia_audio_dart.AILIA_AUDIO_FFT_NORMALIZE_NONE,
      fmin,
      fmax,
      nMel,
      ailia_audio_dart.AILIA_AUDIO_MEL_NORMALIZE_NONE,
      ailia_audio_dart.AILIA_AUDIO_MEL_SCALE_FORMULA_HTK,
    );
    malloc.free(audioDataNative);
    if (status != ailiaStatusSuccess) {
      throw Exception("ailiaAudioGetMelSpectrogram error $status");
    }

    // amplitude_to_db
    const ref = 1.0;
    const amin = 1e-10;
    for (int i = 0; i < (nMel * nFrame); i++) {
      var s = mel[i] * mel[i];
      if (s >= 0 && s < amin) s = amin;
      if (s < 0 && s > -amin) s = -amin;
      mel[i] = 10 * (log(s / ref) / ln10); // = 10 * log10(s/ref)
    }

    // transpose(1, 0):  [mel_n][frame_n] to [frame_n][mel_n]
    Float32List melT = Float32List(nMel * nFrame);
    for (int j = 0; j < nFrame; j++) {
      for (int i = 0; i < nMel; i++) {
        melT[j * nMel + i] = mel[i * nFrame + j];
      }
    }

    malloc.free(frameLength);
    malloc.free(mel);
    return melT;
  }

  void close() {
    if (!available) {
      return;
    }
    available = false;
  }
}
