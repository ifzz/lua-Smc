
#include "TestClass.h"

using namespace std;
using namespace statemap;

int main(int argc, char *argv[])
{
    TestClass obj;

    obj.Evt_1();
    obj.Evt_2();
    obj.Evt_3();
    obj.Evt_1();
    obj.Evt_2();
    obj.Evt_3();
}
