set -e

cd tbb

make target="ios" arch="arm64" extra_inc="big_iron.inc" 2> /dev/null
make target="ios" arch="armv7" extra_inc="big_iron.inc" 2> /dev/null
make target="ios" arch="intel64" extra_inc="big_iron.inc" 2> /dev/null

mkdir -p ../libs

pattern="_release"
xcrun --sdk iphoneos lipo -create build/*"${pattern}"/libtbb.a -output ../libs/libtbb.a
xcrun --sdk iphoneos lipo -create build/*"${pattern}"/libtbbmalloc.a -output ../libs/libtbbmalloc.a
