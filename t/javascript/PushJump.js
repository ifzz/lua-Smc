
require('./Sm/TestClass.js');

var obj = new TestClass();
obj.fsm.setDebugStream(process.stdout);
obj.fsm.setDebugFlag(process.argv.length > 2);
obj.Evt_1();
obj.Evt_2(); // push
obj.Evt_2(); // pop
obj.Evt_2(); // push
obj.Evt3(1); // pop
obj.Evt_1();
obj.Evt3(1); // jump
obj.Evt_1(); // jump
obj.Evt_1();
