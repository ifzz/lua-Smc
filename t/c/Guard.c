
#include "TestClass.h"

int main(int argc, char *argv[])
{
    struct TestClass thisContext;

    TestClass_Init(&thisContext);
    TestClass_Evt1(&thisContext, 1);
    TestClass_Evt1(&thisContext, 2);
    TestClass_Evt1(&thisContext, 3);
    TestClass_Evt_3(&thisContext);
    TestClass_Evt_2(&thisContext);
    TestClass_Evt1(&thisContext, 1);
}
