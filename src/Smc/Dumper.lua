
require 'Coat'
local CodeGen = require 'CodeGen'

class 'Smc.Dumper'
extends 'Smc.Generator'

function method:_build_template ()
    return CodeGen{
        TOP = [[
Start State: ${fsm.startState}
    Context: ${fsm.context}
       Maps:
${fsm.maps/_map()}
]],
        _map = [[
%map ${name}
${defaultState?_state()}
${states/_state()}
]],
        _state = [[
${entryActions?_entry()}
${exitActions?_exit()}
${transitions/_transition()}
]],
            _entry = [[
	Entry {
${entryActions/_action()}
	}
]],
            _exit = [[
	Exit {
${exitActions/_action()}
	}
]],
        _transition = [[
${name}(${parameters/_param(); separator=", "})
${guards/_guard()}
]],
            _param = "${name}",
        _guard = [[
${name}${condition; format=f_cond} ${transType; format=f_type} ${endState}${pushState?_push()} {
    ${actions/_action(); separator=",\n"}
}
]],
            _push = "/ push(${pushState})",
            f_cond = function (s)
                if s == '' then
                    return s
                else
                    return " [" .. s .. "]"
                end
            end,
            f_type = function (s)
                if s == 'TRANS_SET' or s == 'TRANS_PUSH' then
                    return "set"
                else
                    return "pop"
                end
            end,
        _action = "${propertyFlag?_action_prop()!_action_no_prop()}\n",
            _action_prop = "${name} = ${arguments}",
            _action_no_prop = "${name}(${arguments; separator=', '})",
    }
end

