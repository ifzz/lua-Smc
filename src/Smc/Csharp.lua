
require 'Coat'

singleton 'Smc.Csharp'
extends 'Smc.Language'

has.id              = { '+', default = 'C_SHARP' }
has.name            = { '+', default = 'C#' }
has.option          = { '+', default = '-csharp' }
has.suffix          = { '+', default = '_sm' }
has.generator       = { '+', isa = 'Smc.Csharp.Generator',
                        default = function () return require 'Smc.Csharp.Generator' end }
has.genericFlag     = { '+', default = true }
has.reflectFlag     = { '+', default = true }
has.serialFlag      = { '+', default = true }
has.syncFlag        = { '+', default = true }


class 'Smc.Csharp.Generator'
extends 'Smc.Generator'

has.suffix          = { '+', default = 'cs' }

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

