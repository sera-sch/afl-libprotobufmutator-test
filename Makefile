PROTOC=external/bin/protoc
CXXFLAGS=-O3 -fPIC -std=c++14 -I. -I./external/include -I./external/include/libprotobuf-mutator
CXX=clang++
CXXAFL=afl-clang-fast++
LD=$(CXX)
export AFL_PATH=/home/s/AFLplusplus

all: mutator.so test

mutator.so: src/msg.pb.o src/mutator.o
	$(CXX) -pthread -shared $(CXXFLAGS) -o $@ $^ ./external/lib/libprotobuf-mutator-libfuzzer.a ./external/lib/libprotobuf-mutator.a ./build/external.protobuf/lib/libprotobuf.a

test: src/msg_test.pb.o src/test.o
ifdef afl
	$(CXXAFL) -pthread $(CXXFLAGS) -o $@ $^ ./external/lib/libprotobuf-mutator-libfuzzer.a ./external/lib/libprotobuf-mutator.a ./build/external.protobuf/lib/libprotobuf.a
else
	$(LD) -pthread $(CXXFLAGS) -o $@ $^ ./external/lib/libprotobuf-mutator-libfuzzer.a ./external/lib/libprotobuf-mutator.a ./build/external.protobuf/lib/libprotobuf.a
endif

src/test.o: src/test.cc
ifdef afl
	$(CXXAFL) $(CXXFLAGS) -c -o $@ $<
else
	$(CXX) $(CXXFLAGS) -c -o $@ $<
endif

src/msg_test.pb.o: src/msg.pb.cc
ifdef afl
	$(CXXAFL) $(CXXFLAGS) -c -o $@ $<
else
	$(CXX) $(CXXFLAGS) -c -o $@ $<
endif

src/msg.pb.o: src/msg.pb.cc
	$(CXX) $(CXXFLAGS) -c -o $@ $<

src/msg.pb.cc src/msg.pb.h: msg.proto
	$(PROTOC) --cpp_out=src $<	

%.o: %.cc
	$(CXX) $(CXXFLAGS) -c -o $@ $<

clean:
	rm src/mutator.o src/test.o src/*.pb.*
