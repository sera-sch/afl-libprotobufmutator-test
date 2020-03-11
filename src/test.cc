#include <iostream>
#include <fstream>

#include "google/protobuf/message.h"
// #include "libprotobuf-mutator/src/libfuzzer/libfuzzer_macro.h"
#include "msg.pb.h"

int main(int argc, char *argv[]) {
    Msg msg;
    std::ifstream file;
    file.open(argv[1]);
//    protobuf_mutator::libfuzzer::LoadProtoInput(true, (const uint8_t *)data.c_str(), data.size(), &msg);
    
    bool ok = msg.ParseFromIstream(&file);
    
    if(msg.id() == 1) __builtin_trap();
    puts(msg.blah().c_str());
}
