#
# Compiler and SystemC configuration
#
CC=/usr/bin/g++
ARCH := $(shell arch)
SYSTEMC_HOME=/usr/local/SystemC-2.3.0

# 64bit or 32bit libraries to link to
LINUXLIB := $(shell if [ ${ARCH} = "i686" ]; then echo lib-linux; else echo lib-linux64; fi)

INCLUDES = -I$(SYSTEMC_HOME)/include -I"C:/cygwin64/sysclibs/include" -D_GLIBCXX_USE_CXX11_ABI=0
LIBRARIES = -L$(SYSTEMC_HOME)/$(LINUXLIB) -L"C:/cygwin64/sysclibs/lib-cygwin64" -lsystemc -lm
RPATH = -Wl,-rpath=$(SYSTEMC_HOME)/$(LINUXLIB)

PROGRAM = sc_jpeg.exe
SRCS = functions.cpp fdct.cpp idct.cpp sc_main.cpp
OBJS = functions.o fdct.o idct.o sc_main.o

all : $(PROGRAM)

$(OBJS) : $(SRCS)
	$(CC) $(INCLUDES) -c $(SRCS)

$(PROGRAM) : $(OBJS)
	$(CC) $(INCLUDES) $(LIBRARIES) $(RPATH) -o $(PROGRAM) $(OBJS)

clean:
	@rm -f $(OBJS) $(PROGRAM) *.cpp~ *.h~ *.d

