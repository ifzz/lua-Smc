
require('./Sm/TestClass.js');

var obj = new TestClass();
obj.fsm.setDebugStream(process.stdout);
obj.fsm.setDebugFlag(process.argv.length > 2);
obj.Evt_1();
