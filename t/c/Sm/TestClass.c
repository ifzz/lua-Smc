
#include <stdio.h>
#define NDEBUG
#include "TestClass.h"

const struct Sm_TestClassState *stack[4];

void Sm_TestClass_Init(struct Sm_TestClass *this)
{
    Sm_TestClassContext_Init(&this->_fsm, this);
    FSM_STACK(&this->_fsm, stack);

    /* Uncomment to see debug output. */
    /* setDebugFlag(&this->_fsm, 1); */
}

void Sm_TestClass_NoArg(struct Sm_TestClass *this)
{
    printf("No arg\n");
}

void Sm_TestClass_Output(struct Sm_TestClass *this, const char *str)
{
    printf("%s\n", str);
}

void Sm_TestClass_Output_n(struct Sm_TestClass *this, const char *str1, int n, const char *str2)
{
    printf("%s%d%s\n", str1, n, str2);
}

int Sm_TestClass_isOk(struct Sm_TestClass *this)
{
    return 1;
}

int Sm_TestClass_isNok(struct Sm_TestClass *this)
{
    return 0;
}

void Sm_TestClass_Evt_1(struct Sm_TestClass *this)
{
    Sm_TestClassContext_Evt_1(&this->_fsm);
}

void Sm_TestClass_Evt_2(struct Sm_TestClass *this)
{
    Sm_TestClassContext_Evt_2(&this->_fsm);
}

void Sm_TestClass_Evt_3(struct Sm_TestClass *this)
{
    Sm_TestClassContext_Evt_3(&this->_fsm);
}

void Sm_TestClass_Evt1(struct Sm_TestClass *this, int n)
{
    Sm_TestClassContext_Evt1(&this->_fsm, n);
}

void Sm_TestClass_Evt2(struct Sm_TestClass *this, int n)
{
    Sm_TestClassContext_Evt2(&this->_fsm, n);
}

void Sm_TestClass_Evt3(struct Sm_TestClass *this, int n)
{
    Sm_TestClassContext_Evt3(&this->_fsm, n);
}
