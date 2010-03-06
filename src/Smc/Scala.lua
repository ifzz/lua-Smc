
require 'Coat'

local ipairs = ipairs

singleton 'Smc.Scala'
extends 'Smc.Language'

has.id              = { '+', default = 'SCALA' }
has.name            = { '+', default = 'Scala' }
has.option          = { '+', default = '-scala' }
has.suffix          = { '+', default = 'Context' }
has.generator       = { '+', isa = 'Smc.Scala.Generator',
                        default = function () return require 'Smc.Scala.Generator' end }
has.reflectFlag     = { '+', default = true }
has.serialFlag      = { '+', default = true }
has.syncFlag        = { '+', default = true }


class 'Smc.Scala.Generator'
extends 'Smc.Generator'

has.suffix          = { '+', default = 'scala' }

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

