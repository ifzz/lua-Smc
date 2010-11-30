
#include "Sm/TestClass.h"

int main(int argc, char *argv[])
{
    struct Sm_TestClass thisContext;

    Sm_TestClass_Init(&thisContext);
    if (argc > 1) {
        setDebugFlag(&thisContext._fsm, 1);
    }
    Sm_TestClass_Evt_1(&thisContext);
    Sm_TestClass_Evt_2(&thisContext);      /* push */
    Sm_TestClass_Evt_2(&thisContext);      /* pop */
    Sm_TestClass_Evt_2(&thisContext);      /* push */
    Sm_TestClass_Evt3(&thisContext, 1);    /* pop */
    Sm_TestClass_Evt_1(&thisContext);
    Sm_TestClass_Evt3(&thisContext, 1);    /* jump */
    Sm_TestClass_Evt_1(&thisContext);      /* jump */
    Sm_TestClass_Evt_1(&thisContext);
}

