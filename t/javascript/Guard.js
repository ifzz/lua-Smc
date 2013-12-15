
require('./Sm/TestClass.js');

var obj = new TestClass();
obj.fsm.setDebugStream(process.stdout);
obj.fsm.setDebugFlag(process.argv.length > 2);
obj.Evt1(1);
obj.Evt1(2);
obj.Evt1(3);
obj.Evt_3();
obj.Evt_2();
obj.Evt1(1);
