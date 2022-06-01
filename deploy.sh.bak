rm -rf /opt/x86_64-apple-darwin18
cp -a ./x86_64-apple-darwin18 /opt
chown root:wheel /opt/x86_64-apple-darwin18
chown -R root:wheel /opt/x86_64-apple-darwin18

install_name_tool -change libgme.1.dylib /opt/x86_64-apple-darwin18/lib/libgme.1.dylib /opt/x86_64-apple-darwin18/lib/libavutil.57.dylib
install_name_tool -change libmodplug.dylib /opt/x86_64-apple-darwin18/lib/libmodplug.dylib /opt/x86_64-apple-darwin18/lib/libavutil.57.dylib
install_name_tool -change libgme.1.dylib /opt/x86_64-apple-darwin18/lib/libgme.1.dylib /opt/x86_64-apple-darwin18/lib/libavcodec.59.dylib
install_name_tool -change libmodplug.dylib /opt/x86_64-apple-darwin18/lib/libmodplug.dylib /opt/x86_64-apple-darwin18/lib/libavcodec.59.dylib
install_name_tool -change libgme.1.dylib /opt/x86_64-apple-darwin18/lib/libgme.1.dylib /opt/x86_64-apple-darwin18/lib/libswresample.4.dylib
install_name_tool -change libmodplug.dylib /opt/x86_64-apple-darwin18/lib/libmodplug.dylib /opt/x86_64-apple-darwin18/lib/libswresample.4.dylib
install_name_tool -change libgme.1.dylib /opt/x86_64-apple-darwin18/lib/libgme.1.dylib /opt/x86_64-apple-darwin18/lib/libavformat.59.dylib
install_name_tool -change libmodplug.dylib /opt/x86_64-apple-darwin18/lib/libmodplug.dylib /opt/x86_64-apple-darwin18/lib/libavformat.59.dylib
install_name_tool -change libgme.1.dylib /opt/x86_64-apple-darwin18/lib/libgme.1.dylib /opt/x86_64-apple-darwin18/lib/libswscale.6.dylib
install_name_tool -change libmodplug.dylib /opt/x86_64-apple-darwin18/lib/libmodplug.dylib /opt/x86_64-apple-darwin18/lib/libswscale.6.dylib
install_name_tool -change libgme.1.dylib /opt/x86_64-apple-darwin18/lib/libgme.1.dylib /opt/x86_64-apple-darwin18/lib/libavfilter.8.dylib
install_name_tool -change libmodplug.dylib /opt/x86_64-apple-darwin18/lib/libmodplug.dylib /opt/x86_64-apple-darwin18/lib/libavfilter.8.dylib
install_name_tool -change libgme.1.dylib /opt/x86_64-apple-darwin18/lib/libgme.1.dylib /opt/x86_64-apple-darwin18/lib/libpostproc.56.dylib
install_name_tool -change libmodplug.dylib /opt/x86_64-apple-darwin18/lib/libmodplug.dylib /opt/x86_64-apple-darwin18/lib/libpostproc.56.dylib
#install_name_tool -change libgme.1.dylib /opt/x86_64-apple-darwin18/lib/libgme.1.dylib /opt/x86_64-apple-darwin18/lib/libavdevice.59.dylib
#install_name_tool -change libmodplug.dylib /opt/x86_64-apple-darwin18/lib/libmodplug.dylib /opt/x86_64-apple-darwin18/lib/libavdevice.59.dylib

install_name_tool -change libgme.1.dylib /opt/x86_64-apple-darwin18/lib/libgme.1.dylib /opt/x86_64-apple-darwin18/bin/ffmpeg
install_name_tool -change libmodplug.dylib /opt/x86_64-apple-darwin18/lib/libmodplug.dylib /opt/x86_64-apple-darwin18/bin/ffmpeg
