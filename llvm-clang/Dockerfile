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
