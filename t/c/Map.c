
#include "TestClass.h"

int main(int argc, char *argv[])
{
    struct TestClass thisContext;

    TestClass_Init(&thisContext);
    TestClass_Evt_1(&thisContext);
    TestClass_Evt_2(&thisContext);      /* push */
    TestClass_Evt_2(&thisContext);      /* pop */
    TestClass_Evt_2(&thisContext);      /* push */
    TestClass_Evt3(&thisContext, 1);    /* pop */
    TestClass_Evt_1(&thisContext);
    TestClass_Evt3(&thisContext, 1);    /* jump */
    TestClass_Evt_1(&thisContext);      /* jump */
    TestClass_Evt_1(&thisContext);
}

