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



FROM stagging AS ogg-stagging
RUN git clone --depth 1 https://github.com/xiph/ogg
WORKDIR /ogg


FROM ogg-stagging AS ogg-configure
RUN ./autogen.sh
RUN \
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
WORKDIR /vorbis


FROM vorbis-stagging AS vorbis-configure
COPY --from=ogg-build $PREFIX $PREFIX
RUN ./autogen.sh
RUN \
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


# CC=o64-clang CFLAGS="-I$PREFIX/include" LDFLAGS="-L$PREFIX/lib" ./configure --prefix=$PREFIX --host=$OSXCROSS_HOST --enable-shared --disable-static --disable-docs --disable-examples --disable-oggtest
