#rocenting@gmail.com
CC = gcc
CXX = g++
CFLAGS = -O0 -Wall
# CXXFLAGS = -O0 -frtti -fexceptions -Wall
CXXFLAGS = -g -O0 -fno-strict-aliasing -Wno-write-strings -frtti -fexceptions -Wall -DDEBUG
INCPATH = -I./libddz -I/opt/local/include

LD = gcc
LFLAGS = #-static
# LIBS = -L. -L./libddz -L/opt/local/lib -lddz -lstdc++ -lev -ljson_linux-gcc-4.4.7_libmt -lhiredis
LIBS = -L. -L./libddz -L/usr/local/lib -lddz -lstdc++ -lev -ljsonlib -lhiredis

DESTDIR_TARGET = landlord
OBJECTS = landlord.o daemonize.o log.o client.o game.o jpacket.o table.o player.o redis_client.o log_agent.o manager.o tasks.o  gifts.o matchInfo.o

all: $(DESTDIR_TARGET)

$(DESTDIR_TARGET): $(OBJECTS)
	$(LD) $(LFLAGS) -o $(DESTDIR_TARGET) $(OBJECTS) $(LIBS)

####### Implicit rules ######

.SUFFIXES: .cpp .cc .cxx .c
.cpp.o:
	$(CXX) -c $(CXXFLAGS) $(INCPATH) -o $@ $<

.cc.o:
	$(CXX) -c $(CXXFLAGS) $(INCPATH) -o $@ $<

.cxx.o:
	$(CXX) -c $(CXXFLAGS) $(INCPATH) -o $@ $<

.c.o:
	$(CC) -c $(CFLAGS) $(INCPATH) -o $@ $<

clean:
	rm -rf $(DESTDIR_TARGET) *.o
