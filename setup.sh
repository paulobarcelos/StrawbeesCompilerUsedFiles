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
cat "$BASE/rawtrace"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
cat "$BASE/trace"
