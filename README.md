# AFL and libprotobuf-mutator test
Use the custom version of AFL.

References:
- [https://github.com/thebabush/afl-libprotobuf-mutator]

```bash
./build.sh
make afl=1 test
rm src/msg.pb.o
make mutator.so
export PATH=/path/to/AFL:$PATH
AFL_SKIP_CPUFREQ=1 afl-fuzz -D -d ./mutator.so -i in -o out -- ./test @@```
