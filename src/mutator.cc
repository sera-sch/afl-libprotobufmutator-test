#include "google/protobuf/message.h"
#ifdef MUTATE_DIRECTLY
#include "libprotobuf-mutator/src/libfuzzer/libfuzzer_macro.h"
#else
#include "libprotobuf-mutator/src/mutator.h"
#endif
#include "msg.pb.h"

#ifdef MUTATE_DIRECTLY
DEFINE_BINARY_PROTO_FUZZER(const Msg &msg) {
    return;
}
#endif

// https://github.com/thebabush/afl-libprotobuf-mutator/blob/master/src/mutator.cc
// The api has changed as https://github.com/vanhauser-thc/AFLplusplus/blob/master/docs/custom_mutators.md

extern "C" {
    size_t mutator(uint8_t **data, size_t size, size_t max_size, unsigned int seed) {
        assert(size <= max_size);
        uint8_t *mutated_out = *data;
#ifdef MUTATE_DIRECTLY
        size_t new_size = LLVMFuzzerCustomMutator(
            mutated_out,
            size,
            max_size,
            seed
        );
        return new_size;
#else
        Msg msg;
        msg.ParsePartialFromArray(mutated_out, size);
        protobuf_mutator::Mutator pbm;
        pbm.Seed(seed);
        pbm.Mutate(&msg, 200);
        size = msg.ByteSizeLong();
        assert(size <= max_size);
        msg.SerializePartialToArray(mutated_out, size);
        return size;
#endif
    }
    
}
