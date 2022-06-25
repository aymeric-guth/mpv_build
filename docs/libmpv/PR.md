Jun 20, 2022
ERROR: 6c3a82f0433de8ff9c35def971a736056cc8ff38
OK:        a5b3b65dc067b900be55d7edcea3cecd65a133f0


FFmpeg/libavfilter/colorspace.h
`#include "libavutil/colorspace.h"`

```bash
Undefined symbols for architecture x86_64:
  "_ff_fill_rgb2yuv_table", referenced from:
      _ff_draw_init2 in drawutils.o
  "_ff_matrix_mul_3x3_vec", referenced from:
      _ff_draw_color in drawutils.o
ld: symbol(s) not found for architecture x86_64
clang: error: linker command failed with exit code 1 (use -v to see invocation)
make: *** [ffbuild/library.mak:119: libavfilter/libavfilter.8.dylib] Error 1
```

drawutils.c
```C
void ff_draw_color(FFDrawContext *draw, FFDrawColor *color, const uint8_t rgba[4])
```
```c
ff_matrix_mul_3x3_vec(yuvad, rgbad, draw->rgb2yuv);
```

```c
int ff_draw_init2(FFDrawContext *draw, enum AVPixelFormat format, enum AVColorSpace csp, enum AVColorRange range, unsigned flags)
```
```c
ff_fill_rgb2yuv_table(luma, draw->rgb2yuv);
```
drawutils.d
drawutils.h

colorspace.c
```c
void ff_matrix_mul_3x3_vec(double dst[3], const double vec[3], const double mat[3][3])
```

```c
void ff_fill_rgb2yuv_table(const AVLumaCoefficients *coeffs, double rgb2yuv[3][3])
```
colorspace.h

###### Proposition
ajout `colorspace.o` dans libavfilter/Makefile:16
