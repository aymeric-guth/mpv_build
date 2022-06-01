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
RUN git clone --recursive https://github.com/losnoco/cog


FROM stagging AS stage-lazyusf2
WORKDIR /cog/Frameworks/lazyusf2


#FROM stage-lazyusf2 AS build-lazyusf2
#RUN xcodebuild -scheme lazyusf2 build


# FROM stagging AS stage-psflib
# WORKDIR /cog/Frameworks/psflib


# FROM stage-psflib AS build-psflib
# RUN xcodebuild -scheme psflib build



DYNLINK=0
SHARED_LIB=1
STATIC_LIB=0
EXAMPLES=0
OPENMPT123=0
IN_OPENMPT=0
XMP_OPENMPT=0
SHARED_SONAME=0
DEBUG=0
OPTIMIZE=vectorize
TEST=0
STRICT=0
MODERN=0
NATIVE=0
STDCXX=c++17
ANALYZE=0
CHECKED=0
CHECKED_ADDRESS=0
CHECKED_UNDEFINED=0



DYNLINK=0 SHARED_LIB=1 STATIC_LIB=0 EXAMPLES=0 OPENMPT123=0 IN_OPENMPT=0 XMP_OPENMPT=0 SHARED_SONAME=0 DEBUG=0 OPTIMIZE=vectorize TEST=0 STRICT=0 MODERN=0 NATIVE=0 STDCXX=c++17 ANALYZE=0 CHECKED=0 CHECKED_ADDRESS=0 CHECKED_UNDEFINED=0


export DYNLINK=0
export SHARED_LIB=1
export STATIC_LIB=0
export EXAMPLES=0
export OPENMPT123=0
export IN_OPENMPT=0
export XMP_OPENMPT=0
export SHARED_SONAME=0
export DEBUG=0
export OPTIMIZE=vectorize
export TEST=0
export STRICT=0
export MODERN=0
export NATIVE=0
export STDCXX=c++17
export ANALYZE=0
export CHECKED=0
export CHECKED_ADDRESS=0
export CHECKED_UNDEFINED=0
