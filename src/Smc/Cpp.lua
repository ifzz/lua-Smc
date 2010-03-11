
require 'Coat'

local ipairs = ipairs

singleton 'Smc.Cpp'
extends 'Smc.Language'

has.id              = { '+', default = 'C_PLUS_PLUS' }
has.name            = { '+', default = 'C++' }
has.option          = { '+', default = '-c++' }
has.suffix          = { '+', default = '_sm' }
has.generator       = { '+', isa = 'Smc.Cpp.Generator',
                        default = function () return require 'Smc.Cpp.Generator' end }
has.castFlag        = { '+', default = true }
has.headerFlag      = { '+', default = true }
has.noExceptionFlag = { '+', default = true }
has.noStreamFlag    = { '+', default = true }
has.serialFlag      = { '+', default = true }
has.castTypes       = { '+', default = {
                                dynamic_cast = true,
                                static_cast = true,
                                reinterpret_cast = true } }


class 'Smc.Cpp.Generator'
extends 'Smc.Generator'

has.suffix          = { '+', default = 'cpp' }
has.next_generator  = { '+', isa = 'Smc.Cpp.HeaderGenerator',
                        default = function () return require 'Smc.Cpp.HeaderGenerator' end }

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


class 'Smc.Cpp.HeaderGenerator'
extends 'Smc.Generator'

has.suffix          = { '+', default = 'hpp' }

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
