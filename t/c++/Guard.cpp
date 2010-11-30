
#include "Sm/TestClass.h"

using namespace std;
using namespace statemap;
using namespace Sm;

int main(int argc, char *argv[])
{
    TestClass obj;

    if (argc > 1) {
        obj._fsm.setDebugFlag(true);
#ifdef SMC_USES_IOSTREAMS
        obj._fsm.setDebugStream(std::cout);
#endif
    }
    obj.Evt1(1);
    obj.Evt1(2);
    obj.Evt1(3);
    obj.Evt_3();
    obj.Evt_2();
    obj.Evt1(1);
}
