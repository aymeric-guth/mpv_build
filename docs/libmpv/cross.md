###### Toolchain
// OSX-Cross
https://github.com/tpoechtrager/osxcross
// OSX-Cross + SDK 10.14.6
https://github.com/liushuyu/osxcross-extras
https://hub.docker.com/r/liushuyu/osxcross

###### Linking
https://wincent.com/wiki/@executable_path,_@load_path_and_@rpath
https://stackoverflow.com/questions/31823999/is-it-possible-to-have-clang-link-dylibs-relatively-and-not-use-install-name

###### Xcode
https://developer.apple.com/library/archive/technotes/tn2339/_index.html

###### Build
// search path for the compiler
``` shell
gcc -Wp,-v -E -
```

```c
char *__builtin_FUNCTION()
```
