
require 'Coat'

local ipairs = ipairs

singleton 'Smc.Table'
extends 'Smc.Language'

has.id              = { '+', default = 'TABLE' }
has.name            = { '+', default = 'HTML Table' }
has.option          = { '+', default = '-table' }
has.suffix          = { '+', default = '_sm' }
has.generator       = { '+', isa = 'Smc.Table.Generator',
                        default = function () return require 'Smc.Table.Generator' end }


class 'Smc.Table.Generator'
extends 'Smc.Generator'

has.suffix          = { '+', default = 'html' }

function method:visitFSM (fsm)
    self.indent = ""
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

