---
tags: [openmpt, libopenmpt, configure]
---
```
`configure' configures libopenmpt 0.6.3+release.autotools to adapt to many kinds of systems.

Usage: ./configure [OPTION]... [VAR=VALUE]...

To assign environment variables (e.g., CC, CFLAGS...), specify them as
VAR=VALUE.  See below for descriptions of some of the useful variables.

Defaults for the options are specified in brackets.

Configuration:
  -h, --help              display this help and exit
      --help=short        display options specific to this package
      --help=recursive    display the short help of all the included packages
  -V, --version           display version information and exit
  -q, --quiet, --silent   do not print `checking ...' messages
      --cache-file=FILE   cache test results in FILE [disabled]
  -C, --config-cache      alias for `--cache-file=config.cache'
  -n, --no-create         do not create output files
      --srcdir=DIR        find the sources in DIR [configure dir or `..']

Installation directories:
  --prefix=PREFIX         install architecture-independent files in PREFIX
                          [/usr/local]
  --exec-prefix=EPREFIX   install architecture-dependent files in EPREFIX
                          [PREFIX]

By default, `make install' will install all the files in
`/usr/local/bin', `/usr/local/lib' etc.  You can specify
an installation prefix other than `/usr/local' using `--prefix',
for instance `--prefix=$HOME'.

For better control, use the options below.

Fine tuning of the installation directories:
  --bindir=DIR            user executables [EPREFIX/bin]
  --sbindir=DIR           system admin executables [EPREFIX/sbin]
  --libexecdir=DIR        program executables [EPREFIX/libexec]
  --sysconfdir=DIR        read-only single-machine data [PREFIX/etc]
  --sharedstatedir=DIR    modifiable architecture-independent data [PREFIX/com]
  --localstatedir=DIR     modifiable single-machine data [PREFIX/var]
  --runstatedir=DIR       modifiable per-process data [LOCALSTATEDIR/run]
  --libdir=DIR            object code libraries [EPREFIX/lib]
  --includedir=DIR        C header files [PREFIX/include]
  --oldincludedir=DIR     C header files for non-gcc [/usr/include]
  --datarootdir=DIR       read-only arch.-independent data root [PREFIX/share]
  --datadir=DIR           read-only architecture-independent data [DATAROOTDIR]
  --infodir=DIR           info documentation [DATAROOTDIR/info]
  --localedir=DIR         locale-dependent data [DATAROOTDIR/locale]
  --mandir=DIR            man documentation [DATAROOTDIR/man]
  --docdir=DIR            documentation root [DATAROOTDIR/doc/libopenmpt]
  --htmldir=DIR           html documentation [DOCDIR]
  --dvidir=DIR            dvi documentation [DOCDIR]
  --pdfdir=DIR            pdf documentation [DOCDIR]
  --psdir=DIR             ps documentation [DOCDIR]

Program names:
  --program-prefix=PREFIX            prepend PREFIX to installed program names
  --program-suffix=SUFFIX            append SUFFIX to installed program names
  --program-transform-name=PROGRAM   run sed PROGRAM on installed program names

System types:
  --build=BUILD     configure for building on BUILD [guessed]
  --host=HOST       cross-compile to build programs to run on HOST [BUILD]

Optional Features:
  --disable-option-checking  ignore unrecognized --enable/--with options
  --disable-FEATURE       do not include FEATURE (same as --enable-FEATURE=no)
  --enable-FEATURE[=ARG]  include FEATURE [ARG=yes]
  --enable-silent-rules   less verbose build output (undo: "make V=1")
  --disable-silent-rules  verbose build output (undo: "make V=0")
  --enable-dependency-tracking
                          do not reject slow dependency extractors
  --disable-dependency-tracking
                          speeds up one-time build
  --enable-shared[=PKGS]  build shared libraries [default=yes]
  --enable-static[=PKGS]  build static libraries [default=yes]
  --enable-fast-install[=PKGS]
                          optimize for fast installation [default=yes]
  --disable-libtool-lock  avoid locking (might break parallel builds)
  --disable-largefile     omit support for large files
  --disable-openmpt123    Disable the openmpt123 command line player.
  --disable-examples      Disable the example programs.
  --disable-tests         Disable the test suite.
  --disable-doxygen-doc   don't generate any doxygen documentation
  --enable-doxygen-dot    generate graphics for doxygen documentation
  --enable-doxygen-man    generate doxygen manual pages
  --enable-doxygen-rtf    generate doxygen RTF documentation
  --enable-doxygen-xml    generate doxygen XML documentation
  --enable-doxygen-chm    generate doxygen compressed HTML help documentation
  --enable-doxygen-chi    generate doxygen separate compressed HTML help index
                          file
  --disable-doxygen-html  don't generate doxygen plain HTML documentation
  --enable-doxygen-ps     generate doxygen PostScript documentation
  --enable-doxygen-pdf    generate doxygen PDF documentation

Optional Packages:
  --with-PACKAGE[=ARG]    use PACKAGE [ARG=yes]
  --without-PACKAGE       do not use PACKAGE (same as --with-PACKAGE=no)
  --with-pic[=PKGS]       try to use only PIC/non-PIC objects [default=use
                          both]
  --with-aix-soname=aix|svr4|both
                          shared library versioning (aka "SONAME") variant to
                          provide on AIX, [default=aix].
  --with-gnu-ld           assume the C compiler uses GNU ld [default=no]
  --with-sysroot[=DIR]    Search for dependent libraries within DIR (or the
                          compiler's sysroot if not specified).
  --without-zlib          Disable use of zlib.
  --without-mpg123        Disable use of libmpg123.
  --without-ogg           Disable use of libogg.
  --without-vorbis        Disable use of libvorbis.
  --without-vorbisfile    Disable use of libvorbisfile.
  --with-pulseaudio       Enable use of libpulse and libpulse-simple (enabled
                          by default on Linux).
  --without-portaudio     Disable use of libportaudio.
  --without-portaudiocpp  Disable use of libportaudiocpp.
  --with-sdl2             Enable use of libsdl2.
  --without-sndfile       Disable use of libsndfile.
  --without-flac          Disable use of libflac.

Some influential environment variables:
  CC          C compiler command
  CFLAGS      C compiler flags
  LDFLAGS     linker flags, e.g. -L<lib dir> if you have libraries in a
              nonstandard directory <lib dir>
  LIBS        libraries to pass to the linker, e.g. -l<library>
  CPPFLAGS    (Objective) C/C++ preprocessor flags, e.g. -I<include dir> if
              you have headers in a nonstandard directory <include dir>
  LT_SYS_LIBRARY_PATH
              User-defined run-time library search path.
  CPP         C preprocessor
  PKG_CONFIG  path to pkg-config utility
  PKG_CONFIG_PATH
              directories to add to pkg-config's search path
  PKG_CONFIG_LIBDIR
              path overriding pkg-config's built-in search path
  CXX         C++ compiler command
  CXXFLAGS    C++ compiler flags
  CXXCPP      C++ preprocessor
  CXXSTDLIB_PCLIBSPRIVATE
              C++ standard library (or libraries) required for static linking.
              This will be put in the pkg-config file libopenmpt.pc
              Libs.private field and used for nothing else.
  ZLIB_CFLAGS C compiler flags for ZLIB, overriding pkg-config
  ZLIB_LIBS   linker flags for ZLIB, overriding pkg-config
  MPG123_CFLAGS
              C compiler flags for MPG123, overriding pkg-config
  MPG123_LIBS linker flags for MPG123, overriding pkg-config
  OGG_CFLAGS  C compiler flags for OGG, overriding pkg-config
  OGG_LIBS    linker flags for OGG, overriding pkg-config
  VORBIS_CFLAGS
              C compiler flags for VORBIS, overriding pkg-config
  VORBIS_LIBS linker flags for VORBIS, overriding pkg-config
  VORBISFILE_CFLAGS
              C compiler flags for VORBISFILE, overriding pkg-config
  VORBISFILE_LIBS
              linker flags for VORBISFILE, overriding pkg-config
  PULSEAUDIO_CFLAGS
              C compiler flags for PULSEAUDIO, overriding pkg-config
  PULSEAUDIO_LIBS
              linker flags for PULSEAUDIO, overriding pkg-config
  PORTAUDIO_CFLAGS
              C compiler flags for PORTAUDIO, overriding pkg-config
  PORTAUDIO_LIBS
              linker flags for PORTAUDIO, overriding pkg-config
  PORTAUDIOCPP_CFLAGS
              C compiler flags for PORTAUDIOCPP, overriding pkg-config
  PORTAUDIOCPP_LIBS
              linker flags for PORTAUDIOCPP, overriding pkg-config
  SDL2_CFLAGS C compiler flags for SDL2, overriding pkg-config
  SDL2_LIBS   linker flags for SDL2, overriding pkg-config
  SNDFILE_CFLAGS
              C compiler flags for SNDFILE, overriding pkg-config
  SNDFILE_LIBS
              linker flags for SNDFILE, overriding pkg-config
  FLAC_CFLAGS C compiler flags for FLAC, overriding pkg-config
  FLAC_LIBS   linker flags for FLAC, overriding pkg-config
  DOXYGEN_PAPER_SIZE
              a4wide (default), a4, letter, legal or executive

Use these variables to override the choices made by `configure' or to help
it to find libraries and programs with nonstandard names/locations.

Report bugs to <https://bugs.openmpt.org/>.
libopenmpt home page: <https://lib.openmpt.org/>.
```