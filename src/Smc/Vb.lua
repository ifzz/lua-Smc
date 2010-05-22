
require 'Coat'

singleton 'Smc.Vb'
extends 'Smc.Language'

has.id              = { '+', default = 'VB' }
has.name            = { '+', default = 'VB.Net' }
has.option          = { '+', default = '-vb' }
has.suffix          = { '+', default = '_sm' }
has.generator       = { '+', isa = 'Smc.Vb.Generator',
                        default = function () return require 'Smc.Vb.Generator' end }
has.genericFlag     = { '+', default = true }
has.reflectFlag     = { '+', default = true }
has.serialFlag      = { '+', default = true }
has.syncFlag        = { '+', default = true }


class 'Smc.Vb.Generator'
extends 'Smc.Generator'

has.suffix          = { '+', default = 'vb' }

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

