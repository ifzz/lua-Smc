
#include "TestClass.h"

using namespace std;
using namespace statemap;

int main(int argc, char *argv[])
{
    TestClass obj;

    if (argc > 1) {
        obj._fsm.setDebugFlag(true);
#ifdef SMC_USES_IOSTREAMS
        obj._fsm.setDebugStream(std::cout);
#endif
    }
    obj.Evt_1();
    obj.Evt_2(); // push
    obj.Evt_2(); // pop
    obj.Evt_2(); // push
    obj.Evt3(1); // pop
    obj.Evt_1();
    obj.Evt3(1); // jump
    obj.Evt_1(); // jump
    obj.Evt_1();
}
