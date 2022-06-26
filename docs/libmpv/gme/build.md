###### pkg-config
```bash
# entries grouped with CMake are expanded by CMake
# ${foo} entries are left alone by CMake and much
# later are used by pkg-config.
prefix=/opt/x86_64-apple-darwin18
exec_prefix=${prefix}
lib_suffix=
libdir=${exec_prefix}/lib${lib_suffix}
includedir=${prefix}/include

Name: Game_Music_Emu
Description: A video game emulation library for music.
URL: https://bitbucket.org/mpyne/game-music-emu/wiki/Home
Version: 0.7.0
Cflags: -I${includedir}
Libs: -L${libdir} -lgme
Libs.private: -lstdc++ -lz -lunrar
```