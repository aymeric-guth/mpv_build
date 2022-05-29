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
  && rm -rf /var/lib/apt/lists/*
RUN python3 -m pip install waftools


FROM builder AS stagging
ENV MACOSX_DEPLOYMENT_TARGET="10.14"
ENV OSXCROSS_MP_INC="1"
ENV OSXCROSS_GCC_NO_STATIC_RUNTIME="1"
ENV OSXCROSS_HOST="x86_64-apple-darwin18"
ENV OSXCROSS_TARGET_DIR="/opt/osxcross"
ENV OSXCROSS_TARGET="x86_64-apple-darwin18-mach"
ENV OSXCROSS_SDK="/opt/osxcross/SDK/MacOSX10.14.sdk"
ENV PREFIX="/opt/${OSXCROSS_HOST}"
RUN printf '1\n' | osxcross-macports; exit 0;


FROM stagging AS stage-libgme
RUN git clone https://bitbucket.org/mpyne/game-music-emu
RUN osxcross-macports install \
  libsdl2_mixer \
  zlib \
  libunrar; \
  exit 0;
WORKDIR /game-music-emu/build


FROM stage-libgme AS build-libgme
RUN cmake .. \
  -DCMAKE_TOOLCHAIN_FILE="${OSXCROSS_TARGET_DIR}/toolchain.cmake" \
  -DBUILD_SHARED_LIBS="ON" \
  # -DBUILD_SHARED_LIBS="OFF" \
  -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
  -DENABLE_UBSAN="0" \
  -DGME_SPC_ISOLATED_ECHO_BUFFER="ON"
RUN make -j4 && make install


FROM stagging AS stage-libmodplug
RUN git clone https://github.com/Konstanty/libmodplug
WORKDIR /libmodplug/build


FROM stage-libmodplug AS build-libmodplug
RUN cmake .. \
  -DCMAKE_TOOLCHAIN_FILE="${OSXCROSS_TARGET_DIR}/toolchain.cmake" \
  -DBUILD_SHARED_LIBS="ON" \
  # -DBUILD_SHARED_LIBS="OFF" \
  -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
  -DCMAKE_INSTALL_LIBDIR="${PREFIX}/lib"
RUN make -j4 && make install


FROM stagging AS stage-libopus
RUN git clone https://github.com/xiph/opus
WORKDIR /opus
RUN ./autogen.sh


FROM stage-libopus AS build-libopus
RUN \
  PATH=/opt/osxcross/bin:$PATH \
  CC="o64-clang" \
  CXX="o64-clang++" \
#   CFLAGS="-I${PREFIX}/include -I${OSXCROSS_TARGET_DIR}/macports/pkgs/opt/local/include" \
#   LDFLAGS="-L${PREFIX}/lib" \
  ./configure \
    --enable-shared=yes \
    --enable-static=no \
    --prefix=${PREFIX} \
    # --exec-prefix=${PREFIX} \
    # --program-prefix=
    --host="x86_64-apple-darwin18"
RUN make -j4 && make install


FROM stagging AS stage-ffmpeg
RUN osxcross-macports install \
  ffmpeg-devel \
  libass \
  libbluray \
  openssl11; \
  exit 0;
RUN git clone https://github.com/FFmpeg/FFmpeg
ENV OSXCROSS_PKG_CONFIG_LIBDIR="/${PREFIX}/lib/pkgconfig:${OSXCROSS_TARGET_DIR}/macports/pkgs/opt/local/lib/pkgconfig:${OSXCROSS_TARGET_DIR}/macports/pkgs/opt/local/libexec/openssl3/lib/pkgconfig"
COPY --from=build-libgme ${PREFIX} ${PREFIX}
COPY --from=build-libmodplug ${PREFIX} ${PREFIX}
COPY --from=build-libopus ${PREFIX} ${PREFIX}
WORKDIR /FFmpeg


FROM stage-ffmpeg AS build-ffmpeg
RUN \
  ./configure \
    ### Standard options
    --prefix=${PREFIX} \
    ### Licensing options
    --enable-gpl \
    --enable-version3 \
    --enable-nonfree \
    ### Configuration options
    --disable-static \
    --enable-shared \
    --disable-gray \
    --disable-swscale-alpha \
    ### Program options
    --disable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    ### Documentation options
    --disable-doc \
    --disable-htmlpages \
    --disable-manpages \
    --disable-podpages \
    --disable-txtpages \
    ### Component options
    --disable-avdevice \
    --disable-w32threads \
    # --disable-network \
    --disable-pixelutils \
    ### Protocols
    # --disable-protocols \
    --enable-protocol=tcp \
    ### Individual component options
    ### External library support
    --disable-alsa \
    --disable-avfoundation \
    --disable-bzlib \
    --disable-iconv \
    --disable-libass \
    --disable-lzma \
    --disable-mediafoundation \
    --disable-sndio \
    --disable-schannel \
    --disable-sdl2 \
    --disable-securetransport \
    --disable-vulkan \
    --disable-xlib \
    --disable-zlib \
    --enable-libgme \
    --enable-libmodplug \
    --enable-libopus \
    ### Toolchain options
    --enable-cross-compile \
    --arch=x86_64 \
    --target-os=darwin \
    --cross-prefix=x86_64-apple-darwin18- \
    --cc=o64-clang \
    --cxx=o64-clang++ \
    --extra-cflags="-I${PREFIX}/include" \
    # --extra-cflags="-I${PREFIX}/include/libmodplug -I${PREFIX}/include/gme" \
    --extra-ldflags="-L${PREFIX}/lib -lgme -lmodplug -lopus" \
    # --extra-ldflags="-L${PREFIX}/lib -static -l:libgme.a -l:libmodplug.a" \
    ### Current
    --disable-decoders \
    --disable-demuxers \
    --disable-parsers \
    --disable-filters \
    --disable-bsfs \
    --disable-indevs \
    --disable-outdevs \
    --disable-hwaccels \
    --disable-muxers \
    --disable-encoders \
    ### Custom formats
    --enable-demuxer=libgme \
    --enable-demuxer=libmodplug \
    --enable-decoder=mp3 \
    --enable-decoder=mp3_at \
    --enable-decoder=mp3adu \
    --enable-decoder=mp3adufloat \
    --enable-decoder=mp3float \
    --enable-decoder=mp3on4 \
    --enable-decoder=mp3on4float \
    --enable-demuxer=mp3 \
    --enable-decoder=flac \
    --enable-demuxer=flac \
    # --enable-decoder=opus \
    --enable-decoder=vorbis \
    --enable-demuxer=ogg \
    --enable-decoder=pcm_s16be \
    --enable-decoder=pcm_s16le \
    --enable-demuxer=pcm_s16be \
    --enable-demuxer=pcm_s16le \
    --enable-demuxer=wav \
    --enable-decoder=aac \
    --enable-decoder=aac_at \
    --enable-decoder=aac_fixed \
    --enable-demuxer=aac \
    # --enable-decoder=aac_latm \
    # --enable-decoder=aasc \
    # --enable-decoder=ac3 \
    # --enable-decoder=ac3_at \
    # --enable-decoder=ac3_fixed \
    # --enable-demuxer=ac3 \
    # --enable-demuxer=aa \
    --enable-decoder=alac \
    --enable-decoder=alac_at \
    --enable-demuxer=aax \
    --enable-demuxer=aiff \
    --enable-decoder=mpeg4 \
    --enable-demuxer=mov \
    --enable-decoder=ape \
    --enable-demuxer=ape \
    --enable-decoder=libopus \
    # --enable-decoder=opus \
    --enable-encoder=libopus
    # --enable-encoder=opus
RUN make -j4 && make install


FROM stagging AS stage-libmpv
RUN osxcross-macports install \
  libiconv \
  fribidi \
  freetype \
  fontconfig \
  harfbuzz \
  libass \
  uchardet \
  jpeg \
  libbluray \
  rubberband \
  zimg \
  lcms2 \
  libarchive \
  zlib; \
  exit 0;
COPY --from=build-ffmpeg ${PREFIX} ${PREFIX}
RUN git clone https://github.com/mpv-player/mpv
ENV OSXCROSS_PKG_CONFIG_LIBDIR="/${PREFIX}/lib/pkgconfig:${OSXCROSS_TARGET_DIR}/macports/pkgs/opt/local/lib/pkgconfig:${OSXCROSS_TARGET_DIR}/macports/pkgs/opt/local/libexec/openssl3/lib/pkgconfig"
WORKDIR /mpv
RUN ./bootstrap.py


FROM stage-libmpv AS build-libmpv
RUN \
  CC="o64-clang" \
  DEST_OS="darwin" \
  TARGET="${OSXCROSS_HOST}" \
  CFLAGS="-I${PREFIX}/include -I${OSXCROSS_TARGET_DIR}/macports/pkgs/opt/local/include" \
  LDFLAGS="-L${PREFIX}/lib" \
  ./waf configure \
    ### Build and installation options
    --prefix=${PREFIX} \
    --enable-lgpl \
    --enable-cplayer \
    --enable-libmpv-shared \
    --disable-libmpv-static \
    --disable-static-build \
    --disable-debug-build \
    --disable-manpage-build \
    --enable-stdatomic \
    ### optional features
    --disable-android \
    --disable-tvos \
    --disable-egl-android \
    --disable-swift \
    --disable-uwp \
    --disable-win32-internal-pthreads \
    --disable-pthread-debug \
    # --disable-stdatomic \
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
    ### video outputs
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
    ### hwaccels
    --disable-videotoolbox-gl \
    --disable-d3d-hwaccel \
    --disable-d3d9-hwaccel \
    --disable-gl-dxinterop-d3d9 \
    --disable-cuda-hwaccel \
    --disable-cuda-interop \
    --disable-rpi-mmal \
    ### standalone app
    --disable-macos-touchbar \
    --disable-macos-10-11-features \
    --disable-macos-10-12-2-features \
    --disable-macos-10-14-features \
    --disable-macos-media-player \
    --disable-macos-cocoa-cb
RUN ./waf build -j4 && ./waf install


FROM stagging AS stage-packaging
RUN exit 0;


FROM stage-packaging AS packaging
ENV OSXCROSS_MACPORTS_PREFIX="/opt/osxcross/macports/pkgs/opt/local"
ENV TEMP="/opt/temp"
ENV DEST="/opt/libmpv"
COPY --from=build-libmpv ${PREFIX}/include ${TEMP}/include
COPY --from=build-libmpv ${PREFIX}/lib ${TEMP}/lib
COPY --from=build-libmpv ${PREFIX}/bin ${TEMP}/bin


FROM packaging AS cleanup
COPY ./src /src
RUN ["python3", "-u", "-m", "src"]
CMD \
  cd ${DEST} && rm -rf * && cd / && \
  cp -a ${TEMP}/lib ${DEST} && \
  cp -a ${TEMP}/include ${DEST} && \
  cp -a ${TEMP}/bin ${DEST} && \
  chown -R 1000:1000 ${DEST}
