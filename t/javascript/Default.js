
require('./Sm/TestClass.js');

var obj = new TestClass();
obj.fsm.setDebugStream(process.stdout);
obj.fsm.setDebugFlag(process.argv.length > 2);
obj.Evt1(1);
obj.Evt2(1);
obj.Evt1(0);
obj.Evt1(2);
obj.Evt2(2);
obj.Evt3(0);
obj.Evt3(2);
