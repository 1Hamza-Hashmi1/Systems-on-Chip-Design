# Compiler and SystemC configuration
CC = g++
SYSTEMC_HOME = /usr/local/SystemC-2.3.0
ARCH := $(shell arch)

# Determine appropriate library path for 64-bit or 32-bit systems
LINUXLIB := $(shell if [ $(ARCH) = "i686" ]; then echo lib-linux; else echo lib-linux64; fi)

# Include and library paths
INCLUDES = -I$(SYSTEMC_HOME)/include -I. -D_GLIBCXX_USE_CXX11_ABI=0
LIBRARIES = -L$(SYSTEMC_HOME)/$(LINUXLIB) -lsystemc -lm
RPATH = -Wl,-rpath=$(SYSTEMC_HOME)/$(LINUXLIB)

# Program details
PROGRAM = alu.x
SRCS = alu.cpp barrelshift.cpp sc_main.cpp
OBJS = alu.o barrelshift.o sc_main.o

# Targets
all: $(PROGRAM)

$(OBJS): %.o: %.cpp
	$(CC) $(INCLUDES) -c $< -o $@

$(PROGRAM): $(OBJS)
	$(CC) $(INCLUDES) $(LIBRARIES) $(RPATH) -o $@ $^

clean:
	rm -f $(OBJS) $(PROGRAM) *.d *.cpp~ *.h~
