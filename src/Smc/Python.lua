
require 'Coat'

local ipairs = ipairs

singleton 'Smc.Python'
extends 'Smc.Language'

has.id              = { '+', default = 'PYTHON' }
has.name            = { '+', default = 'Python' }
has.option          = { '+', default = '-python' }
has.suffix          = { '+', default = '_sm' }
has.generator       = { '+', isa = 'Smc.Python.Generator',
                        default = function () return require 'Smc.Python.Generator' end }
has.reflectFlag     = { '+', default = true }


class 'Smc.Python.Generator'
extends 'Smc.Generator'

has.suffix          = { '+', default = 'py' }

function method:visitFSM (fsm)
    local stream = self.stream

end

function method:visitMap (map)
    local stream = self.stream
end

function method:visitState (state)
    local stream = self.stream
end

function method:visitTransition (transition)
    local stream = self.stream
end

function method:visitGuard (guard)
    local stream = self.stream
end

function method:visitAction (action)
    local stream = self.stream
end

function method:visitParameter (parameter)
end

