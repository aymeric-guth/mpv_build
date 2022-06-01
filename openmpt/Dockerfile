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
  build-essential \
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

RUN git clone https://github.com/clangen/musikcube.git --recursive

# FROM stagging AS stage-libopenmpt
# RUN wget https://builds.openmpt.org/builds/auto/libopenmpt/src.autotools/0.7.0-pre.8/libopenmpt-0.7.0-pre.8+r17384.autotools.tar.gz
# RUN tar -xvzf libopenmpt-0.7.0-pre.8+r17384.autotools.tar.gz
# RUN mv libopenmpt-0.7.0-pre.8+r17384.autotools openmpt
# RUN osxcross-macports install \
#   zlib; \
#   boost; \
#   openssl \
#   libogg \
#   libvorbis \
#   ffmpeg \
#   libmicrohttpd \
#   lame \
#   libev \
#   taglib \
#   exit 0;
# WORKDIR /openmpt





# FROM stage-libopenmpt AS build-libopenmpt
# RUN \
#   PATH=/opt/osxcross/bin:$PATH \
#   # CC="o64-clang" \
#   # CXX="o64-clang++" \
#   ./configure \
#     --enable-shared=yes \
#     --enable-static=no \
#     --prefix=${PREFIX} \
#     --host="${OSXCROSS_HOST}" \
#     CC="o64-clang" \
#     CXX="o64-clang++" \
#     --disable-dependency-tracking \
#     --disable-silent-rules \
#     --disable-openmpt123 \
#     --disable-examples \
#     --disable-tests \
#     --disable-doxygen-doc \
#     --without-zlib \
#     --without-mpg123 \
#     --without-ogg \
#     --without-vorbis \
#     --without-vorbisfile \
#     --with-pulseaudio \
#     --without-portaudio \
#     --without-portaudiocpp \
#     --with-sdl2 \
#     --without-sndfile \
#     --without-flac
# RUN make -j4 && make install

# FROM build-libopenmpt
# CMD \
#   cp -a "${PREFIX}/lib" "${PREFIX}_" && \
#   cp -a "${PREFIX}/include" "${PREFIX}_/include" && \
#   chown -R 1000:1000 "${PREFIX}_"


#   ./configure \
#     --enable-shared=yes \
#     --enable-static=no \
#     --prefix=/Users/yul/openmpt \
#     CC=clang \
#     CXX=clang++ \
#     CLANG_CXX_LANGUAGE_STANDARD=c++2a \
#     --disable-dependency-tracking \
#     --disable-silent-rules \
#     --disable-openmpt123 \
#     --disable-examples \
#     --disable-tests \
#     --disable-doxygen-doc \
#     --without-zlib \
#     --without-mpg123 \
#     --without-ogg \
#     --without-vorbis \
#     --without-vorbisfile \
#     --with-pulseaudio \
#     --without-portaudio \
#     --without-portaudiocpp \
#     --with-sdl2 \
#     --without-sndfile \
#     --without-flac


# GNU make
# pkg-config

# pkg-config 0.24 or higher
# zlib
# doxygen