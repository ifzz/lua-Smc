
#include "TestClass.h"

using namespace std;

namespace Sm
{

TestClass::TestClass(): _fsm(*this)
{
    // Uncomment to see debug output.
    // _fsm.setDebugFlag(true);
}

void TestClass::NoArg()
{
#ifdef SMC_USES_IOSTREAMS
    cout << "No arg" << endl;
#else
    TRACE("No arg\n");
#endif
}

void TestClass::Output(const char* str)
{
#ifdef SMC_USES_IOSTREAMS
    cout << str << endl;
#else
    TRACE("%s\n", str);
#endif
}

void TestClass::Output_n(const char* str1, int n, const char *str2)
{
#ifdef SMC_USES_IOSTREAMS
    cout << str1 << n << str2 << endl;
#else
    TRACE("%s%d%s\n", str1, n, str2);
#endif
}

bool TestClass::isOk()
{
    return true;
}

bool TestClass::isNok()
{
    return false;
}

void TestClass::Evt_1()
{
    _fsm.Evt_1();
}

void TestClass::Evt_2()
{
    _fsm.Evt_2();
}

void TestClass::Evt_3()
{
    _fsm.Evt_3();
}

void TestClass::Evt1(int n)
{
    _fsm.Evt1(n);
}

void TestClass::Evt2(int n)
{
    _fsm.Evt2(n);
}

void TestClass::Evt3(int n)
{
    _fsm.Evt3(n);
}

}
