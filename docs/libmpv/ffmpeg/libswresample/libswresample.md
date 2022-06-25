---
tags: [libswresample, swresample]
aliases: [libswresample, swresample]
---
###### libswresample
The libswresample library performs highly optimized audio resampling, rematrixing and sample format conversion operations.
Specifically, this library performs the following conversions:
-   _Resampling_: is the process of changing the audio rate, for example from a high sample rate of 44100Hz to 8000Hz. Audio conversion from high to low sample rate is a lossy process. Several resampling options and algorithms are available.
-   _Format conversion_: is the process of converting the type of samples, for example from 16-bit signed samples to unsigned 8-bit or float samples. It also handles packing conversion, when passing from packed layout (all samples belonging to distinct channels interleaved in the same buffer), to planar layout (all samples belonging to the same channel stored in a dedicated buffer or "plane").
-   _Rematrixing_: is the process of changing the channel layout, for example from stereo to mono. When the input channels cannot be mapped to the output streams, the process is lossy, since it involves different gain factors and mixing.
Various other audio conversions (e.g. stretching and padding) are enabled through dedicated options.
