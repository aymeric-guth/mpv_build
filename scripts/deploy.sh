source .env
sudo rm -rf $PREFIX
sudo cp -a ./$OSXCROSS_HOST $PREFIX
sudo chown root:wheel $PREFIX
sudo chown -R root:wheel $PREFIX
rm -rf ./$OSXCROSS_HOST
