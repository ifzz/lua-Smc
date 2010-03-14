
#include "TestClassContext.h"

struct TestClass
{
    struct TestClassContext _fsm;
};

extern void TestClass_Init(struct TestClass *);
extern void TestClass_Output(struct TestClass *this, const char* str);
extern void TestClass_Output_n(struct TestClass *this, const char* str1, int n, const char *str2);
extern int  TestClass_isOk(struct TestClass *this);
extern int  TestClass_isNok(struct TestClass *this);
extern void TestClass_Evt_1(struct TestClass *this);
extern void TestClass_Evt_2(struct TestClass *this);
extern void TestClass_Evt_3(struct TestClass *this);
extern void TestClass_Evt1(struct TestClass *this, int n);
extern void TestClass_Evt2(struct TestClass *this, int n);
extern void TestClass_Evt3(struct TestClass *this, int n);
