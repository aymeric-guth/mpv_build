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


FROM stagging AS openmpt-stagging
RUN osxcross-macports install \
  clang-14; \
  exit 0;
RUN git clone --depth 1 https://github.com/OpenMPT/openmpt
WORKDIR /openmpt
COPY Makefile Makefile


FROM openmpt-stagging AS openmpt-build
RUN \
  PATH=/opt/osxcross/bin:$PATH \
  make -j8 && make install


FROM openmpt-build
CMD \
  cp -a "${PREFIX}/lib" "${PREFIX}_" && \
  cp -a "${PREFIX}/include" "${PREFIX}_/include" && \
  chown -R 1000:1000 "${PREFIX}_"
