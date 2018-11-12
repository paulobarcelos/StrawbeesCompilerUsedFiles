SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
cd $SCRIPTPATH

# store the root dir
ROOT=$(pwd)

# install dependencies
echo "#########################################################################"
echo "install dependencies"
sudo apt-get -qq update
sudo apt-get --yes --force-yes install realpath
sudo apt-get --yes --force-yes install tree
sudo apt-get --yes --force-yes install curl
sudo apt-get --yes --force-yes install wget
sudo apt-get --yes --force-yes install strace

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
export NVM_DIR="/root/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install 11.1.0
npm --version
nvm --version

rm -rf node_modules
npm install quirkbot-arduino-builder
npm install quirkbot-arduino-hardware
npm install quirkbot-arduino-library
npm install quirkbot-avr-gcc

# create temp dir and setup files
echo "#########################################################################"
echo "creating directories"
rm -rf "$ROOT/build"
rm -rf "$ROOT/firmware"
mkdir "$ROOT/build"
mkdir "$ROOT/firmware"

# create the base firmware
echo "#########################################################################"
echo "creating base firmware"
echo '#include "Quirkbot.h"
void setup(){}
void loop(){}' > "$ROOT/firmware/firmware.ino"

# do a first build and capture the output, so we can extract some info from it
echo "#########################################################################"
echo "doing first build"
perl "$ROOT/tracefile.perl" -uef \
"$ROOT/node_modules/quirkbot-arduino-builder/tools/arduino-builder" \
-hardware="$ROOT/node_modules" \
-hardware="$ROOT/node_modules/quirkbot-arduino-builder/tools/hardware" \
-libraries="$ROOT/node_modules" \
-tools="$ROOT/node_modules/quirkbot-avr-gcc/tools" \
-tools="$ROOT/node_modules/quirkbot-arduino-builder/tools/tools" \
-build-path="$ROOT/build" \
-fqbn="quirkbot-arduino-hardware:avr:quirkbot" \
-ide-version=10607 \
-verbose \
"$BASE/firmware/firmware.ino" \
| grep "$BASE/node_modules" >> "$BASE/rawtrace"
cat "$BASE/rawtrace" | xargs -n1 realpath >> "$BASE/trace"

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
cat "$BASE/trace"
