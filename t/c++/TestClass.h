
#include "TestClassContext.h"

class TestClass
{
private:
    TestClassContext _fsm;

public:
    TestClass();

    ~TestClass() {};

    void Output(const char* str);
    void Output_n(const char* str1, int n, const char *str2);
    bool isOk();
    bool isNok();
    void Evt_1();
    void Evt_2();
    void Evt_3();
    void Evt1(int n);
    void Evt2(int n);
    void Evt3(int n);
};