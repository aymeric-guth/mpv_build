###### pkg-config
```bash
prefix=/opt/x86_64-apple-darwin18
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include

Name: libopenmpt
Description: Tracker module player based on OpenMPT
Version: 0.7.0-pre.9+r17576
Requires.private:
Libs: -L${libdir} -lopenmpt
Libs.private:
Cflags: -I${includedir}
```


`-L/opt/osxcross/macports/pkgs/opt/local/libexec/llvm-14/lib -llibc++`
