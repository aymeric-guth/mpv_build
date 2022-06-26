###### pkg-config
```bash
# libvorbis pkg-config source file

prefix=/opt/x86_64-apple-darwin18
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include

Name: vorbis
Description: vorbis is the primary Ogg Vorbis library
Version: 1.3.7
Requires.private: ogg
Conflicts:
Libs: -L${libdir} -lvorbis
Libs.private: -lm
Cflags: -I${includedir}
```

```shell
# libvorbisenc pkg-config source file

prefix=/opt/x86_64-apple-darwin18
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include

Name: vorbisenc
Description: vorbisenc is a library that provides a convenient API for setting up an encoding environment using libvo>
Version: 1.3.7
Requires.private: vorbis
Conflicts:
Libs: -L${libdir} -lvorbisenc
Cflags: -I${includedir}
```

```bash
# libvorbisfile pkg-config source file

prefix=/opt/x86_64-apple-darwin18
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include

Name: vorbisfile
Description: vorbisfile is a library that provides a convenient high-level API for decoding and basic manipulation of>
Version: 1.3.7
Requires.private: vorbis
Conflicts:
Libs: -L${libdir} -lvorbisfile
Cflags: -I${includedir}
```