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
  -DBUILD_FRAMEWORK="ON" \
  -DBUILD_SHARED_LIBS="ON" \
  -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
  -DENABLE_UBSAN="0" \
  -DGME_SPC_ISOLATED_ECHO_BUFFER="ON"
#RUN make -j4 && make install


#FROM build-libgme
#CMD \
#  cp -a "${PREFIX}/lib" "${PREFIX}_" && \
#  cp -a "${PREFIX}/include" "${PREFIX}_/include" && \
#  chown -R 1000:1000 "${PREFIX}_"
