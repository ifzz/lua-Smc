
#include "TestClass.h"

int main(int argc, char *argv[])
{
    struct TestClass thisContext;

    TestClass_Init(&thisContext);
    TestClass_Evt_1(&thisContext);
    TestClass_Evt2(&thisContext, 1);
    TestClass_Evt_3(&thisContext);
    TestClass_Evt2(&thisContext, 2);
}
