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
RUN echo "alias install_name_tool=${OSXCROSS_TARGET_DIR}/bin/${OSXCROSS_HOST}-install_name_tool" >> ~/.bashrc
RUN echo "alias otool=${OSXCROSS_TARGET_DIR}/bin/${OSXCROSS_HOST}-otool" >> ~/.bashrc
RUN echo "alias vtool=${OSXCROSS_TARGET_DIR}/bin/${OSXCROSS_HOST}-vtool" >> ~/.bashrc

FROM stagging AS stage-libmodplug
RUN git clone https://github.com/Konstanty/libmodplug
WORKDIR /libmodplug/build


FROM stage-libmodplug AS build-libmodplug
RUN cmake .. \
  -DCMAKE_TOOLCHAIN_FILE="${OSXCROSS_TARGET_DIR}/toolchain.cmake" \
  -DBUILD_SHARED_LIBS="ON" \
  -DCMAKE_INSTALL_PREFIX="${PREFIX}"
RUN make -j4 && make install
RUN ${OSXCROSS_TARGET_DIR}/bin/${OSXCROSS_HOST}-install_name_tool -id "${PREFIX}/lib/libmodplug.dylib" "${PREFIX}/lib/libmodplug.dylib"


FROM build-libmodplug
CMD \
  rm -rf "${PREFIX}_/*" && \
  cp -a "${PREFIX}/lib" "${PREFIX}_" && \
  cp -a "${PREFIX}/include" "${PREFIX}_/include" && \
  chown -R 1000:1000 "${PREFIX}_"
