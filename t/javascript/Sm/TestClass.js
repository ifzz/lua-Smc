
require('./../../../runtime/javascript/statemap.js');
require('./TestClassContext.js');

function TestClass () {
    this.fsm = new TestClassContext(this);

    // Uncomment to see debug output.
    //this.fsm.setDebugFlag(true);
}
global.TestClass = TestClass;

TestClass.prototype.NoArg = function () {
    process.stdout.write("No arg\n");
}

TestClass.prototype.Output = function (str) {
    process.stdout.write(str + "\n");
}

TestClass.prototype.Output_n = function (str1, n, str2) {
    process.stdout.write(str1);
    process.stdout.write(n.toString());
    process.stdout.write(str2);
    process.stdout.write("\n");
}

TestClass.prototype.isOk = function () {
    return true;
}

TestClass.prototype.isNok = function () {
    return false;
}

TestClass.prototype.Evt_1 = function () {
    this.fsm.Evt_1();
}

TestClass.prototype.Evt_2 = function () {
    this.fsm.Evt_2();
}

TestClass.prototype.Evt_3 = function () {
    this.fsm.Evt_3();
}

TestClass.prototype.Evt1 = function (n) {
    this.fsm.Evt1(n);
}

TestClass.prototype.Evt2 = function (n) {
    this.fsm.Evt2(n);
}

TestClass.prototype.Evt3 = function (n) {
    this.fsm.Evt3(n);
}

