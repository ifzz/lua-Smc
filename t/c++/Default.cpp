
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
    obj.Evt2(1);
    obj.Evt1(0);
    obj.Evt1(2);
    obj.Evt2(2);
    obj.Evt3(0);
    obj.Evt3(2);
}
