GMP_Version = 6.1.2
NTL_Version = 11.3.2
COMPILER = g++

FLAGS = -std=c++17 -O2 -pedantic -Wall -pthread -m64 -g
LIBDIR = -lntl -lgmp -lm -lboost_system
HELIBSRC = HElib/src

install-armadillo :
	$(info Installing Armadillo 9.300.2...)
	wget https://sourceforge.net/projects/arma/files/armadillo-9.300.2.tar.xz
	tar -xf armadillo-9.300.2.tar.xz
	cd armadillo-9.300.2
	cmake .
	make
	sudo make install
	cd ..
	rm -rf armadillo-9.300.2
	rm armadillo-9.300.2.tar.xz
	
install-boost :
	$(info Installing C++ Boost 1.69...)
	wget https://dl.bintray.com/boostorg/release/1.69.0/source/boost_1_69_0.tar.gz
	tar -xzf boost_1_69_0.tar.gz
	cd boost_1_69_0/tools/build/
	sh bootstrap.sh
	sudo ./b2 install
	cd ../../..
	rm -rf boost_1_69_0
	rm boost_1_69_0.tar.gz
	

install-gmp :
	$(info Installing GMP...)
	sudo apt-get install -y m4 perl
	sudo apt-get install -y m4 perl
	wget https://gmplib.org/download/gmp/gmp-$(GMP_Version).tar.bz2
	tar -xvjf gmp-$(GMP_Version).tar.bz2
	
	cd gmp-$(GMP_Version) && ./configure
	cd gmp-$(GMP_Version) && make
	cd gmp-$(GMP_Version) && sudo make install
	cd gmp-$(GMP_Version) && make check
	rm -rf gmp-$(GMP_Version)*	

install-ntl :
	$(info Installing NTL...)
	wget http://www.shoup.net/ntl/ntl-$(NTL_Version).tar.gz
	tar -xvf ntl-$(NTL_Version).tar.gz
	cd ntl-$(NTL_Version)/src && ./configure NTL_GMP_LIP=on NTL_THREADS=on
	cd ntl-$(NTL_Version)/src && make
	cd ntl-$(NTL_Version)/src && sudo make install
	rm -rf ntl-$(NTL_Version)*
	
install-helib :
	$(info Installing HELib...)
	if [ ! -d "HElib" ]; then git clone https://github.com/homenc/HElib.git; fi
	cd HElib/src && make
	cd HElib/src && make test
	
cleanalllibs :
	$(info Cleaning GMP, NTL, HElib dependencies!)
	rm -rf /usr/local/include/NTL
	rm -f /usr/local/include/gmp.h
	rm -f /usr/local/lib/libgmp.*
	rm -f /usr/local/lib/libntl.*
	rm -rf HElib

help : 
	@echo make install-armadillo - Download and install armadillo
	@echo make install-boost - Installs libboost-all-dev
	@echo make install-gmp - Downloads and compiles GMP
	@echo make install-ntl - Downloads and compiles NTL
	@echo make install-helib - Downloads and compiles HElib
	@echo make cleanalllibs - Removes the libraries
