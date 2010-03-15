
#include "TestClass.h"

using namespace std;
using namespace statemap;

int main(int argc, char *argv[])
{
    TestClass obj;

    obj.Evt1(1);
    obj.Evt1(2);
    obj.Evt1(3);
    obj.Evt_3();
    obj.Evt_2();
    obj.Evt1(1);
}
