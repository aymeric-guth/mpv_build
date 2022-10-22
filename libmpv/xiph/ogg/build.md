###### pkg-config
`ogg.pc`
```bash
# ogg pkg-config file

prefix=/opt/x86_64-apple-darwin18
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include

Name: ogg
Description: ogg is a library for manipulating ogg bitstreams
Version: 1.3.5
Requires:
Conflicts:
Libs: -L${libdir} -logg
Cflags: -I${includedir}
```