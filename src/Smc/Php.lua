
require 'Coat'

singleton 'Smc.Php'
extends 'Smc.Language'

has.id              = { '+', default = 'PHP' }
has.name            = { '+', default = 'PHP' }
has.option          = { '+', default = '-php' }
has.suffix          = { '+', default = '_sm' }
has.generator       = { '+', isa = 'Smc.Php.Generator',
                        default = function () return require 'Smc.Php.Generator' end }
has.reflectFlag     = { '+', default = true }


class 'Smc.Php.Generator'
extends 'Smc.Generator'

has.suffix          = { '+', default = 'php' }

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

