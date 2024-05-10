import 'package:ailia_audio/ailia_audio_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

import 'package:ailia_audio/ailia_audio.dart';
import 'package:ailia_audio/ailia_audio_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final AiliaAudioModel ailiaAudio = AiliaAudioModel();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion = "ailiaAudio";

    ailiaAudio.open();
    Float32List src = Float32List(4);
    src[0] = 0;
    src[1] = 1;
    src[2] = 2;
    src[3] = 3;
    Float32List dst = ailiaAudio.resample(src, 44100, 48000);
    platformVersion = "ailiaAudio resample src : $src dst : $dst";
    ailiaAudio.close();

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
