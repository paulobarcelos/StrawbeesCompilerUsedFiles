SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
cd $SCRIPTPATH

# store the root dir
ROOT=$(pwd)

# do a first build and capture the output, so we can extract some info from it
rm -rf "$ROOT/build"
mkdir "$ROOT/build"

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
"$ROOT/firmware/firmware.ino" \
>> "$ROOT/output.txt"

# capture the compilation part
cat "$ROOT/output.txt"| grep "firmware.ino.cpp.o" | head -n 1 >> "$ROOT/build.sh"

# capture the "link and copy" part
cat "$ROOT/output.txt"| grep "firmware.ino.elf" | grep -v "firmware.ino.eep" >> "$ROOT/build.sh"

rm -rf "$ROOT/build"
mkdir "$ROOT/build"
perl "$ROOT/tracefile.perl" -uef sh "$ROOT/build.sh" | grep $ROOT >> "$ROOT/rawtrace"
cat "$ROOT/rawtrace" | xargs -n1 realpath >> "$ROOT/trace"
echo "#########################################################################"
cat "$ROOT/trace"
