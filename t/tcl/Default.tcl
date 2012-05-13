
package require Itcl;
namespace import ::itcl::*;

source ./t/tcl/Sm/TestClass.tcl;

::Sm::TestClass obj;
obj Evt1 1;
obj Evt2 1;
obj Evt1 0;
obj Evt1 2;
obj Evt2 2;
obj Evt3 0;
obj Evt3 2;
