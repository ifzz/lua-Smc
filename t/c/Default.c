
#include <stdlib.h>
#include "Sm/TestClass.h"

int main(int argc, char *argv[])
{
    struct Sm_TestClass thisContext;

    Sm_TestClass_Init(&thisContext);
    if (argc > 1) {
        setDebugFlag(&thisContext._fsm, 1);
    }
    Sm_TestClass_Evt1(&thisContext, 1);
    Sm_TestClass_Evt2(&thisContext, 1);
    Sm_TestClass_Evt1(&thisContext, 0);
    Sm_TestClass_Evt1(&thisContext, 2);
    Sm_TestClass_Evt2(&thisContext, 2);
    Sm_TestClass_Evt3(&thisContext, 0);
    Sm_TestClass_Evt3(&thisContext, 2);
    return EXIT_SUCCESS;
}
