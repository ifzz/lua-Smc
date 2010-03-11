
require 'Coat'

local ipairs = ipairs

singleton 'Smc.Groovy'
extends 'Smc.Language'

has.id              = { '+', default = 'GROOVY' }
has.name            = { '+', default = 'Groovy' }
has.option          = { '+', default = '-groovy' }
has.suffix          = { '+', default = 'Context' }
has.generator       = { '+', isa = 'Smc.Groovy.Generator',
                        default = function () return require 'Smc.Groovy.Generator' end }
has.reflectFlag     = { '+', default = true }
has.serialFlag      = { '+', default = true }
has.syncFlag        = { '+', default = true }


class 'Smc.Groovy.Generator'
extends 'Smc.Generator'

has.suffix          = { '+', default = 'groovy' }

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

