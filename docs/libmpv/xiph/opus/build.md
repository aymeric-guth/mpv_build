###### pkg-config
`opus.pc`
```bash
# Opus codec reference implementation pkg-config file

prefix=/opt/x86_64-apple-darwin18
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include

Name: Opus
Description: Opus IETF audio codec (floating-point build)
URL: https://opus-codec.org/
Version: unknown
Requires:
Conflicts:
Libs: -L${libdir} -lopus
Libs.private:
Cflags: -I${includedir}/opus
```