BOOST_VERSION="1.65.1"
BOOST_LIBS="date_time chrono filesystem iostreams program_options regex system thread"

if [ -f libs/boost.framework/Headers/version.hpp ]; then
    BOOST_LIB_VERSION=`awk '/#define BOOST_LIB_VERSION/{ print $3 }' < libs/boost.framework/Headers/version.hpp | tr _ . | tr -d '"'`
    if [ $depth -eq $zero ]; then
    	echo "Found Boost library, skipping build."
    	exit
    fi
else
	cd Apple-Boost-BuildScript
	./boost.sh -ios --boost-version "$BOOST_VERSION" --boost-libs "$BOOST_LIBS" --no-clean
	cd ..

	mkdir -p libs
	ln -s ../Apple-Boost-BuildScript/build/boost/1.65.1/ios/release/framework/boost.framework libs/boost.framework
fi


