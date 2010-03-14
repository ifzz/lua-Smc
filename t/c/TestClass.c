
#include <stdio.h>
#include "TestClass.h"

void TestClass_Init(struct TestClass *this)
{
    const struct TestClassState* stack[4];

    TestClassContext_Init(&this->_fsm, this);
    FSM_STACK(&this->_fsm, stack);

    /* Uncomment to see debug output. */
    /* setDebugFlag(&this->_fsm, 1); */
}

void TestClass_Output(struct TestClass *this, const char* str)
{
    printf("%s\n", str);
}

void TestClass_Output_n(struct TestClass *this, const char* str1, int n, const char *str2)
{
    printf("%s%d%s\n", str1, n , str2);
}

int TestClass_isOk(struct TestClass *this)
{
    return 1;
}

int TestClass_isNok(struct TestClass *this)
{
    return 0;
}

void TestClass_Evt_1(struct TestClass *this)
{
    TestClassContext_Evt_1(&this->_fsm);
}

void TestClass_Evt_2(struct TestClass *this)
{
    TestClassContext_Evt_2(&this->_fsm);
}

void TestClass_Evt_3(struct TestClass *this)
{
    TestClassContext_Evt_3(&this->_fsm);
}

void TestClass_Evt1(struct TestClass *this, int n)
{
    TestClassContext_Evt1(&this->_fsm, n);
}

void TestClass_Evt2(struct TestClass *this, int n)
{
    TestClassContext_Evt2(&this->_fsm, n);
}

void TestClass_Evt3(struct TestClass *this, int n)
{
    TestClassContext_Evt3(&this->_fsm, n);
}
