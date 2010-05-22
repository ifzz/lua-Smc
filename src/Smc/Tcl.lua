
require 'Coat'

singleton 'Smc.Tcl'
extends 'Smc.Language'

has.id              = { '+', default = 'TCL' }
has.name            = { '+', default = '[incr Tcl]' }
has.option          = { '+', default = '-tcl' }
has.suffix          = { '+', default = '_sm' }
has.generator       = { '+', isa = 'Smc.Tcl.Generator',
                        default = function () return require 'Smc.Tcl.Generator' end }
has.serialFlag      = { '+', default = true }


class 'Smc.Tcl.Generator'
extends 'Smc.Generator'

has.suffix          = { '+', default = 'tcl' }

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

