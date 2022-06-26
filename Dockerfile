FROM liushuyu/osxcross AS builder
RUN apt update && apt upgrade -y && rm -rf /var/lib/apt/lists/*
RUN apt update && apt install -y \
  nano \
  yasm \
  nasm \
  pkg-config \
  autoconf \
  automake \
  python3-pip \
  git \
  libtool \
  gcc \
  make \
  bsdmainutils \
  && rm -rf /var/lib/apt/lists/*
RUN python3 -m pip install waftools


FROM builder AS stagging
ENV MACOSX_DEPLOYMENT_TARGET="10.14"
ENV OSXCROSS_MP_INC="1"
ENV OSXCROSS_GCC_NO_STATIC_RUNTIME="1"
ENV OSXCROSS_TARGET_DIR="/opt/osxcross"
ENV OSXCROSS_TARGET="x86_64-apple-darwin18-mach"
ENV OSXCROSS_SDK="/opt/osxcross/SDK/MacOSX10.14.sdk"
ENV OSXCROSS_HOST="x86_64-apple-darwin18"
ENV PREFIX="/opt/${OSXCROSS_HOST}"
RUN printf '1\n' | osxcross-macports; exit 0;
RUN echo "alias install_name_tool=${OSXCROSS_TARGET_DIR}/bin/${OSXCROSS_HOST}-install_name_tool" >> ~/.bashrc
RUN echo "alias otool=${OSXCROSS_TARGET_DIR}/bin/${OSXCROSS_HOST}-otool" >> ~/.bashrc
RUN echo "alias vtool=${OSXCROSS_TARGET_DIR}/bin/${OSXCROSS_HOST}-vtool" >> ~/.bashrc


FROM stagging AS gme-stagging
RUN git clone --depth 1 https://bitbucket.org/mpyne/game-music-emu
RUN osxcross-macports install \
  libsdl2_mixer \
  zlib \
  libunrar; \
  exit 0;
WORKDIR /game-music-emu/build


FROM gme-stagging AS gme-configure
RUN cmake .. \
  -DCMAKE_TOOLCHAIN_FILE="${OSXCROSS_TARGET_DIR}/toolchain.cmake" \
  -DBUILD_SHARED_LIBS="ON" \
  -DBUILD_FRAMEWORK="OFF" \
  -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
  -DENABLE_UBSAN="0" \
  -DGME_SPC_ISOLATED_ECHO_BUFFER="ON"


FROM gme-configure AS gme-build
RUN make -j8 && make install
RUN ${OSXCROSS_TARGET_DIR}/bin/${OSXCROSS_HOST}-install_name_tool -id "${PREFIX}/lib/libgme.0.7.0.dylib" "${PREFIX}/lib/libgme.0.7.0.dylib"


FROM stagging AS modplug-stagging
RUN git clone --depth 1 https://github.com/Konstanty/libmodplug
WORKDIR /libmodplug/build


FROM modplug-stagging AS modplug-configure
RUN cmake .. \
  -DCMAKE_TOOLCHAIN_FILE="${OSXCROSS_TARGET_DIR}/toolchain.cmake" \
  -DBUILD_SHARED_LIBS="ON" \
  -DCMAKE_INSTALL_PREFIX="${PREFIX}"


FROM modplug-configure AS modplug-build
RUN make -j8 && make install
RUN ${OSXCROSS_TARGET_DIR}/bin/${OSXCROSS_HOST}-install_name_tool -id "${PREFIX}/lib/libmodplug.dylib" "${PREFIX}/lib/libmodplug.dylib"


FROM stagging AS openmpt-stagging
RUN osxcross-macports install \
  clang-14; \
  exit 0;
RUN git clone --depth 1 https://github.com/OpenMPT/openmpt
WORKDIR /openmpt
COPY openmpt.Makefile Makefile


FROM openmpt-stagging AS openmpt-build
RUN \
  PATH=/opt/osxcross/bin:$PATH \
  make -j8 && make install
RUN ${OSXCROSS_TARGET_DIR}/bin/${OSXCROSS_HOST}-install_name_tool -id "${PREFIX}/lib/libopenmpt.dylib" "${PREFIX}/lib/libopenmpt.dylib"


FROM stagging AS ogg-stagging
RUN git clone --depth 1 https://github.com/xiph/ogg
WORKDIR /ogg
RUN ./autogen.sh


FROM ogg-stagging AS ogg-configure
RUN \
  PATH=/opt/osxcross/bin:$PATH \
  CC=o64-clang \
  ./configure \
    --prefix=$PREFIX \
    --host=$OSXCROSS_HOST \
    --enable-shared \
    --disable-static


FROM ogg-configure AS ogg-build
RUN make -j8 && make install


FROM stagging AS vorbis-stagging
RUN git clone --depth 1 https://github.com/xiph/vorbis
COPY --from=ogg-build $PREFIX $PREFIX
WORKDIR /vorbis
RUN ./autogen.sh


FROM vorbis-stagging AS vorbis-configure
RUN \
  PATH=/opt/osxcross/bin:$PATH \
  CC=o64-clang \
  CFLAGS="-I$PREFIX/include" \
  LDFLAGS="-L$PREFIX/lib" \
  ./configure \
    --prefix=$PREFIX \
    --host=$OSXCROSS_HOST \
    --enable-shared \
    --disable-static \
    --disable-docs \
    --disable-examples \
    --disable-oggtest


FROM vorbis-configure AS vorbis-build
RUN make -j8 && make install


FROM stagging AS opus-stagging
RUN git clone --depth 1 https://github.com/xiph/opus
COPY --from=ogg-build $PREFIX $PREFIX
WORKDIR /opus
RUN ./autogen.sh


FROM opus-stagging AS opus-configure
RUN \
  PATH=/opt/osxcross/bin:$PATH \
  CC="o64-clang" \
  CXX="o64-clang++" \
  CFLAGS="-I$PREFIX/include" \
  LDFLAGS="-L$PREFIX/lib" \
  ./configure \
    --enable-shared=yes \
    --enable-static=no \
    --prefix=$PREFIX \
    --host=$OSXCROSS_HOST \
    --disable-doc \
    --disable-extra-programs


FROM opus-configure AS opus-build
RUN make -j8 && make install


FROM stagging AS fdk-aac-stagging
RUN git clone --depth 1 https://github.com/mstorsjo/fdk-aac
WORKDIR /fdk-aac
RUN ./autogen.sh


FROM fdk-aac-stagging AS fdk-aac-configure
RUN \
  CC=o64-clang \
  CXX=o64-clang++ \
  ./configure \
    --prefix=$PREFIX \
    --host=$OSXCROSS_HOST \
    --enable-shared \
    --disable-static


FROM fdk-aac-configure AS fdk-aac-build
RUN make -j8 && make install


FROM stagging AS ffmpeg-stagging
# RUN osxcross-macports fake-install \
#   libedit-20210910 \
#   graphviz; \
#   exit 0;
# RUN osxcross-macports install \
#   ffmpeg-devel \
#   libass \
#   libbluray \
#   openssl11; \
#   exit 0;
RUN git clone --depth 1 https://github.com/FFmpeg/FFmpeg
# ENV OSXCROSS_PKG_CONFIG_LIBDIR="/${PREFIX}/lib/pkgconfig:${OSXCROSS_TARGET_DIR}/macports/pkgs/opt/local/lib/pkgconfig:${OSXCROSS_TARGET_DIR}/macports/pkgs/opt/local/libexec/openssl3/lib/pkgconfig"
ENV OSXCROSS_PKG_CONFIG_LIBDIR="${PREFIX}/lib/pkgconfig"
COPY --from=gme-build $PREFIX $PREFIX
COPY --from=modplug-build $PREFIX $PREFIX
COPY --from=openmpt-build $PREFIX $PREFIX
COPY --from=vorbis-build $PREFIX $PREFIX
COPY --from=opus-build $PREFIX $PREFIX
COPY --from=fdk-aac-build $PREFIX $PREFIX
WORKDIR /FFmpeg
# COPY configure configure
# COPY opus.pc ${PREFIX}/lib/pkgconfig/opus.pc


FROM ffmpeg-stagging AS ffmpeg-configure
RUN \
  ./configure \
    #######################################################################
    ### Standard options:
    #######################################################################
    --prefix=${PREFIX} \
    #######################################################################
    ### Licensing options:
    #######################################################################
    --enable-gpl \
    --enable-version3 \
    --enable-nonfree \
    #######################################################################
    ### Configuration options:
    #######################################################################
    --disable-static \
    --enable-shared \
    --disable-small \
    --enable-runtime-cpudetect \
    --disable-gray \
    --disable-swscale-alpha \
    --enable-autodetect \
    #######################################################################
    ### Program options:
    #######################################################################
    --disable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    #######################################################################
    ### Documentation options:
    #######################################################################
    --disable-doc \
    --disable-htmlpages \
    --disable-manpages \
    --disable-podpages \
    --disable-txtpages \
    #######################################################################
    ### Component options:
    #######################################################################
    --disable-avdevice \
    # --disable-swscale \
    --disable-postproc \
    # --disable-swresample \
    --disable-w32threads \
    --disable-os2threads \
    --disable-network \
    # Discrete Cosine Transform
    # --disable-dct \
    # Discrete Wavelet Transform
    # --disable-dwt \
    # --disable-error-resilience \ disable error resilience code
    # disable LSP code ???
    # --disable-lsp \
    # disable MDCT code ???
    # --disable-mdct \
    # Real Discrete Fourier Transforms
    # --disable-rdft \
    # Fast Fourier Transforms
    # --disable-fft \
    # floating point AAN (I)DCT
    # --disable-faan \
    --disable-pixelutils \
    #######################################################################
    ### Individual component options:
    #######################################################################
    --disable-encoders \
    --disable-decoders \
    --disable-hwaccels \
    --disable-muxers \
    --disable-demuxers \
    --disable-parsers \
    --disable-bsfs \
    --disable-protocols \
    --disable-devices \
    --disable-filters \
    #######################################################################
    ### External library support:
    #######################################################################
    --disable-alsa \
    --disable-appkit \
    --disable-avfoundation \
    --disable-avisynth \
    --disable-bzlib \
    --disable-coreimage \
    --disable-chromaprint \
    --disable-frei0r \
    --disable-gcrypt \
    --disable-gmp \
    --disable-gnutls \
    --disable-iconv \
    --disable-jni \
    --disable-ladspa \
    --disable-lcms2 \
    --disable-libaom \
    --disable-libaribb24 \
    --disable-libass \
    --disable-libbluray \
    --disable-libbs2b \
    --disable-libcaca \
    --disable-libcelt \
    --disable-libcdio \
    --disable-libcodec2 \
    --disable-libdav1d \
    --disable-libdavs2 \
    --disable-libdc1394 \
    --disable-libfdk-aac \
    --disable-libflite \
    --disable-libfontconfig \
    --disable-libfreetype \
    --disable-libfribidi \
    --disable-libglslang \
    --disable-libgme \
    --disable-libgsm \
    --disable-libiec61883 \
    --disable-libilbc \
    --disable-libjack \
    --disable-libjxl \
    --disable-libklvanc \
    --disable-libkvazaar \
    --disable-liblensfun \
    --disable-libmodplug \
    --disable-libmp3lame \
    --disable-libopencore-amrnb \
    --disable-libopencore-amrwb \
    --disable-libopencv \
    --disable-libopenh264 \
    --disable-libopenjpeg \
    --disable-libopenmpt \
    --disable-libopenvino \
    --disable-libopus \
    --disable-libplacebo \
    --disable-libpulse \
    --disable-librabbitmq \
    --disable-librav1e \
    --disable-librist \
    --disable-librsvg \
    --disable-librubberband \
    --disable-librtmp \
    --disable-libshaderc \
    --disable-libshine \
    --disable-libsmbclient \
    --disable-libsnappy \
    --disable-libsoxr \
    --disable-libspeex \
    --disable-libsrt \
    --disable-libssh \
    --disable-libsvtav1 \
    --disable-libtensorflow \
    --disable-libtesseract \
    --disable-libtheora \
    --disable-libtls \
    --disable-libtwolame \
    --disable-libuavs3d \
    --disable-libv4l2 \
    --disable-libvidstab \
    --disable-libvmaf \
    --disable-libvo-amrwbenc \
    --disable-libvorbis \
    --disable-libvpx \
    --disable-libwebp \
    --disable-libx264 \
    --disable-libx265 \
    --disable-libxavs \
    --disable-libxavs2 \
    --disable-libxcb \
    --disable-libxcb-shm \
    --disable-libxcb-xfixes \
    --disable-libxcb-shape \
    --disable-libxvid \
    --disable-libxml2 \
    --disable-libzimg \
    --disable-libzmq \
    --disable-libzvbi \
    --disable-lv2 \
    --disable-lzma \
    --disable-decklink \
    --disable-mbedtls \
    --disable-mediacodec \
    --disable-mediafoundation \
    --disable-metal \
    --disable-libmysofa \
    --disable-openal \
    --disable-opencl \
    --disable-opengl \
    --disable-openssl \
    --disable-pocketsphinx \
    --disable-sndio \
    --disable-schannel \
    --disable-sdl2 \
    --disable-securetransport \
    --disable-vapoursynth \
    --disable-vulkan \
    --disable-xlib \
    --disable-zlib \
    #######################################################################
    ### Hardware acceleration:
    #######################################################################
    --disable-amf \
    --disable-audiotoolbox \
    --disable-cuda-nvcc \
    --disable-cuda-llvm \
    --disable-cuvid \
    --disable-d3d11va \
    --disable-dxva2 \
    --disable-ffnvcodec \
    --disable-libdrm \
    --disable-libmfx \
    --disable-libnpp \
    --disable-mmal \
    --disable-nvdec \
    --disable-nvenc \
    --disable-omx \
    --disable-omx-rpi \
    --disable-rkmpp \
    --disable-v4l2-m2m \
    --disable-vaapi \
    --disable-vdpau \
    --disable-videotoolbox \
    #######################################################################
    ### Toolchain options:
    #######################################################################
    --enable-cross-compile \
    --cross-prefix=/opt/osxcross/bin/x86_64-apple-darwin18- \
    --arch=x86_64 \
    --target-os=darwin \
    # --pkg-config="/opt/osxcross/bin/x86_64-apple-darwin18-pkg-config" \
    # --pkg-config-flags="--silence-errors --errors-to-stdout --prefix-variable=${PREFIX}" \
    --cc=o64-clang \
    --cxx=o64-clang++ \
    --extra-cflags="-I${PREFIX}/include" \
    # --extra-ldflags="-L${PREFIX}/lib -lgme -lmodplug -lopus -lopenmpt -lvorbis -logg -lfdk-aac -lvorbisenc -lvorbisfile" \
    --extra-ldflags="-L${PREFIX}/lib -lgme -lmodplug -lopus -lopenmpt -lfdk-aac" \
    #######################################################################
    ### Advanced options (experts only):
    #######################################################################
    #######################################################################
    ### Optimization options (experts only):
    #######################################################################
    --disable-asm \
    #######################################################################
    ### External Libraries:
    #######################################################################
    --enable-libgme \
    # --enable-libmodplug \
    --enable-libopenmpt \
    --enable-libvorbis \
    # --enable-libopus \
    --enable-libfdk-aac \
    #######################################################################
    ### Parsers:
    #######################################################################
    # --enable-parser=mpegaudio \
    # --enable-parser=flac \
    # --enable-parser=aac \
    # --enable-parser=opus \
    # --enable-parser=vorbis \
    # --enable-parser=dirac \
    #######################################################################
    ### (de)muxers:
    #######################################################################
    --enable-demuxer=libgme \
    # --enable-demuxer=libmodplug \
    --enable-demuxer=libopenmpt \
    --enable-demuxer=mp3 \
    --enable-demuxer=flac \
    --enable-demuxer=ogg \
    --enable-demuxer=opus \
    --enable-demuxer=wav \
    --enable-demuxer=aiff \
    --enable-demuxer=ape \
    --enable-demuxer=mov \
    #######################################################################
    ### Codecs:
    #######################################################################
    --enable-decoder=pcm_s16le \
    --enable-decoder=pcm_s16be \
    --enable-decoder=pcm_s24be \
    --enable-decoder=pcm_f32le \
    --enable-decoder=mp3 \
    --enable-decoder=flac \
    --enable-decoder=libopus \
    --enable-decoder=opus \
    # --enable-decoder=libvorbis \
    --enable-decoder=ape \
    --enable-decoder=libfdk_aac \
    --enable-decoder=alac \
    --enable-decoder=vorbis


FROM ffmpeg-configure as ffmpeg-build
RUN make -j8 && make install


FROM stagging AS mpv-stagging
RUN osxcross-macports fake-install \
  libedit-20210216 \
  libedit-20210910; \
  exit 0;
RUN osxcross-macports install \
  libass; \
  exit 0;
COPY --from=ffmpeg-build ${PREFIX} ${PREFIX}
RUN git clone --depth 1 https://github.com/mpv-player/mpv
ENV OSXCROSS_PKG_CONFIG_LIBDIR="/${PREFIX}/lib/pkgconfig:${OSXCROSS_TARGET_DIR}/macports/pkgs/opt/local/lib/pkgconfig:${OSXCROSS_TARGET_DIR}/macports/pkgs/opt/local/libexec/openssl3/lib/pkgconfig"
WORKDIR /mpv
RUN ./bootstrap.py


FROM mpv-stagging AS mpv-configure
RUN \
  CC="o64-clang" \
  DEST_OS="darwin" \
  TARGET="${OSXCROSS_HOST}" \
  CFLAGS="-I${PREFIX}/include -I${OSXCROSS_TARGET_DIR}/macports/pkgs/opt/local/include" \
  LDFLAGS="-L${PREFIX}/lib" \
  ./waf configure \
    #######################################################################
    ### Build and installation options:
    #######################################################################
    --enable-lgpl \
    --enable-cplayer \
    --enable-libmpv-shared \
    --disable-libmpv-static \
    --disable-static-build \
    --disable-build-date \
    --enable-optimize \
    --disable-debug-build \
    --disable-tests \
    --disable-ta-leak-report \
    --disable-manpage-build \
    --disable-html-build \
    --disable-pdf-build \
    --disable-cplugins \
    --disable-asm \
    --enable-vector \
    --enable-clang-database \
    --disable-swift-static \
    #######################################################################
    ### Installation prefix:
    #######################################################################
    --prefix=$PREFIX \
    #######################################################################
    ### Installation directories:
    #######################################################################
    #######################################################################
    ### optional features:
    #######################################################################
    --disable-android \
    --disable-tvos \
    --disable-egl-android \
    --disable-swift \
    --disable-uwp \
    --disable-win32-internal-pthreads \
    --disable-pthread-debug \
    # --enalbe-stdatomic \
    --disable-iconv \
    --disable-lua \
    --disable-javascript \
    --disable-zlib \
    --disable-libbluray \
    --disable-dvdnav \
    --disable-cdda \
    --disable-uchardet \
    --disable-rubberband \
    --disable-zimg \
    --disable-lcms2 \
    --disable-vapoursynth \
    --disable-libarchive \
    --disable-dvbin \
    --disable-sdl2 \
    --disable-sdl2-gamepad \
    --disable-libavdevice \
    #######################################################################
    ### audio outputs:
    #######################################################################
    --disable-sdl2-audio \
    --disable-oss-audio \
    --disable-pipewire \
    --disable-sndio \
    --disable-pulse \
    --disable-jack \
    --disable-openal \
    --disable-opensles \
    --disable-alsa \
    --enable-coreaudio \
    --disable-audiounit \
    --disable-wasapi \
    #######################################################################
    ### video outputs:
    #######################################################################
    --disable-sdl2-video \
    --disable-cocoa \
    --disable-drm \
    --disable-gbm \
    --disable-wayland-scanner \
    --disable-wayland-protocols \
    --disable-wayland \
    --disable-x11 \
    --disable-xv \
    --disable-gl-cocoa \
    --disable-gl-x11 \
    --disable-rpi \
    --disable-egl \
    --disable-egl-x11 \
    --disable-egl-drm \
    --disable-gl-wayland \
    --disable-gl-win32 \
    --disable-gl-dxinterop \
    --disable-egl-angle \
    --disable-egl-angle-lib \
    --disable-egl-angle-win32 \
    --disable-vdpau \
    --disable-vdpau-gl-x11 \
    --disable-vaapi \
    --disable-vaapi-x11 \
    --disable-vaapi-wayland \
    --disable-vaapi-drm \
    --disable-vaapi-x-egl \
    --disable-caca \
    --disable-jpeg \
    --disable-direct3d \
    --disable-shaderc \
    --disable-spirv-cross \
    --disable-d3d11 \
    --disable-ios-gl \
    --disable-plain-gl \
    --disable-gl \
    --disable-libplacebo \
    --disable-vulkan \
    --disable-sixel \
    #######################################################################
    ### hwaccels:
    #######################################################################
    --disable-videotoolbox-gl \
    --disable-d3d-hwaccel \
    --disable-d3d9-hwaccel \
    --disable-gl-dxinterop-d3d9 \
    --disable-cuda-hwaccel \
    --disable-cuda-interop \
    --disable-rpi-mmal \
    #######################################################################
    ### standalone app:
    #######################################################################
    --disable-macos-touchbar \
    --disable-macos-10-11-features \
    --disable-macos-10-12-2-features \
    --disable-macos-10-14-features \
    --disable-macos-media-player \
    --disable-macos-cocoa-cb


FROM mpv-configure AS mpv-build
RUN ./waf build -j4 && ./waf install


FROM stagging AS packaging
ENV OSXCROSS_MACPORTS_PREFIX="/opt/osxcross/macports/pkgs/opt/local"
ENV TEMP="/opt/temp"
ENV DEST="/opt/libmpv"
COPY --from=mpv-build ${PREFIX}/include ${TEMP}/include
COPY --from=mpv-build ${PREFIX}/lib ${TEMP}/lib
COPY --from=mpv-build ${PREFIX}/bin ${TEMP}/bin


FROM packaging AS cleanup
WORKDIR /
COPY src src
RUN ["python3", "-u", "-m", "src"]
CMD \
  cd ${DEST} && rm -rf * && cd / && \
  cp -a ${TEMP}/lib ${DEST} && \
  cp -a ${TEMP}/include ${DEST} && \
  cp -a ${TEMP}/bin ${DEST} && \
  chown -R 1000:1000 ${DEST}
