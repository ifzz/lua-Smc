
#include "TestClassContext.h"

struct Sm_TestClass
{
    struct TestClassContext _fsm;
};

extern void Sm_TestClass_Init(struct Sm_TestClass *);
extern void Sm_TestClass_NoArg(struct Sm_TestClass *this);
extern void Sm_TestClass_Output(struct Sm_TestClass *this, const char* str);
extern void Sm_TestClass_Output_n(struct Sm_TestClass *this, const char* str1, int n, const char *str2);
extern int  Sm_TestClass_isOk(struct Sm_TestClass *this);
extern int  Sm_TestClass_isNok(struct Sm_TestClass *this);
extern void Sm_TestClass_Evt_1(struct Sm_TestClass *this);
extern void Sm_TestClass_Evt_2(struct Sm_TestClass *this);
extern void Sm_TestClass_Evt_3(struct Sm_TestClass *this);
extern void Sm_TestClass_Evt1(struct Sm_TestClass *this, int n);
extern void Sm_TestClass_Evt2(struct Sm_TestClass *this, int n);
extern void Sm_TestClass_Evt3(struct Sm_TestClass *this, int n);
