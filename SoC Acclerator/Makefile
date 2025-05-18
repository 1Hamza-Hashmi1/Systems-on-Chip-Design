CC = /usr/bin/g++
ARCH := $(shell arch)
SYSTEMC_HOME = /usr/local/SystemC-2.3.0

# 64-bit or 32-bit libraries to link to
LINUXLIB := $(shell if [ ${ARCH} = "i686" ]; \
                then \
                    echo lib-linux; \
                else \
                    echo lib-linux64; \
                fi)

# Compiler flags
CXXFLAGS = -std=c++11 -I$(SYSTEMC_HOME)/include -I"C:/cygwin64/sysclibs/include" -D_GLIBCXX_USE_CXX11_ABI=0
LIBRARIES = -L$(SYSTEMC_HOME)/$(LINUXLIB) -L"C:/cygwin64/sysclibs/lib-cygwin64" -lsystemc -lm
RPATH = -Wl,-rpath=$(SYSTEMC_HOME)/$(LINUXLIB)

# Program details
PROGRAM = arraymult.exe
SRCS = arraymult.cpp sc_main.cpp
OBJS = $(SRCS:.cpp=.o)

# Build targets
all : $(PROGRAM)

%.o : %.cpp
	$(CC) $(CXXFLAGS) -c $< -o $@

$(PROGRAM) : $(OBJS)
	$(CC) $(OBJS) $(CXXFLAGS) $(LIBRARIES) $(RPATH) -o $@

clean:
	@rm -f $(OBJS) $(PROGRAM) *.cpp~ *.h~ *.d
