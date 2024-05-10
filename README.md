# ailia Audio Flutter Package

!! CAUTION !!
“ailia” IS NOT OPEN SOURCE SOFTWARE (OSS).
As long as user complies with the conditions stated in [License Document](https://ailia.ai/license/), user may use the Software for free of charge, but the Software is basically paid software.

## About ailia Audio

ailia Audio is a library for preprocessing and postprocessing of audio included in the ailia SDK.

In recent years, the use of AI in the field of audio has been increasing. Specifically, in tasks such as speech recognition, speech synthesis, pitch estimation, noise removal, and others.

However, when dealing with audio, it is common to apply Mel-spectrogram transformation to the input audio waveform, and this processing was previously done using external libraries such as torch.audio and librosa, rather than within the AI models.

As a result, while AI models can be converted to ONNX, if one attempts to run them on iOS or Android, they needed to implement the preprocessing for Mel-spectrogram transformation separately. This involves implementing functions like FFT, requiring significant effort.

ailia Audio is a library designed to solve this issue. By providing various APIs such as Mel-spectrogram transformation compatible with torch.audio and librosa, it allows for easy implementation of AI models for audio processing in Python on iOS and Android.

## API specification

https://github.com/axinc-ai/ailia-sdk

