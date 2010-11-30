
module Sm

require 'TestClassContext'

class TestClass
    attr_accessor :myProp

    def initialize()
        @_fsm = TestClass_sm::new(self)

        # Uncomment to see debug output.
        #@_fsm.setDebugFlag(true)
    end

    def getFSM()
        return @_fsm
    end

    def NoArg()
        printf "No arg\n"
    end

    def Output(str)
        printf "%s\n", str
    end

    def Output_n(str1, n, str2)
        printf "%s%d%s\n", str1, n, str2
    end

    def isOk()
        return true
    end

    def isNok()
        return false
    end

    def Evt_1()
        @_fsm.Evt_1
    end

    def Evt_2()
        @_fsm.Evt_2
    end

    def Evt_3()
        @_fsm.Evt_3
    end

    def Evt1(n)
        @_fsm.Evt1(n)
    end

    def Evt2(n)
        @_fsm.Evt2(n)
    end

    def Evt3(n)
        @_fsm.Evt3(n)
    end

end

end
