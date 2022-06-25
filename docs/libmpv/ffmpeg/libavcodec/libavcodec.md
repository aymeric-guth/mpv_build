---
tags: [ffmpeg, libavcodec, avcodec]
aliases: [libavcodec, avcodec]
---
# libavcodec
## Description
The libavcodec library provides a generic encoding/decoding framework and contains multiple decoders and encoders for audio, video and subtitle streams, and several bitstream filters.
The shared architecture provides various services ranging from bit stream I/O to DSP optimizations, and makes it suitable for implementing robust and fast codecs as well as for experimentation.

## Decoders
Decoders are configured elements in FFmpeg which allow the decoding of multimedia streams.
When you configure your FFmpeg build, all the supported native decoders are enabled by default. Decoders requiring an external library must be enabled manually via the corresponding `--enable-lib` option. You can list all available decoders using the configure option `--list-decoders`.
You can disable all the decoders with the configure option `--disable-decoders` and selectively enable / disable single decoders with the options `--enable-decoder=DECODER` / `--disable-decoder=DECODER`.
The option `-decoders` of the ff* tools will display the list of enabled decoders.

## Encoders
Encoders are configured elements in FFmpeg which allow the encoding of multimedia streams.
When you configure your FFmpeg build, all the supported native encoders are enabled by default. Encoders requiring an external library must be enabled manually via the corresponding `--enable-lib` option. You can list all available encoders using the configure option `--list-encoders`.
You can disable all the encoders with the configure option `--disable-encoders` and selectively enable / disable single encoders with the options `--enable-encoder=ENCODER` / `--disable-encoder=ENCODER`.
The option `-encoders` of the ff* tools will display the list of enabled encoders.

## Refs
https://ffmpeg.org/ffmpeg-codecs.html
