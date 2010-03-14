
#include "TestClass.h"

int main(int argc, char *argv[])
{
    struct TestClass thisContext;

    TestClass_Init(&thisContext);
    TestClass_Evt_1(&thisContext);
    TestClass_Evt_1(&thisContext);
}

