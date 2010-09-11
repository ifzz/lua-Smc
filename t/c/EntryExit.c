
#include "TestClass.h"

int main(int argc, char *argv[])
{
    struct TestClass thisContext;

    TestClass_Init(&thisContext);
    if (argc > 1) {
        setDebugFlag(&thisContext._fsm, 1);
    }
    TestClass_Evt_1(&thisContext);
    TestClass_Evt_2(&thisContext);
    TestClass_Evt_3(&thisContext);
    TestClass_Evt_1(&thisContext);
    TestClass_Evt_2(&thisContext);
    TestClass_Evt_3(&thisContext);
}
