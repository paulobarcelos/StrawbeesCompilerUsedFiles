SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
cd $SCRIPTPATH

# store the root dir
ROOT=$(pwd)

# create temp dir and setup files
echo "#########################################################################"
echo "creating directories"
rm -rf "$ROOT/build"
rm -rf "$ROOT/firmware"
mkdir "$ROOT/build"
mkdir "$ROOT/firmware"

# do a first build and capture the output, so we can extract some info from it
echo "#########################################################################"
echo "doing first build"
#perl "$ROOT/tracefile.perl" -uef \
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
"$ROOT/firmware/firmware.ino"
#| grep "$ROOT/node_modules" >> "$ROOT/rawtrace"
#cat "$ROOT/rawtrace" | xargs -n1 realpath >> "$ROOT/trace"
#cat "$ROOT/rawtrace"
#echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
#cat "$ROOT/trace"
