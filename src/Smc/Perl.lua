
require 'Coat'

local ipairs = ipairs

singleton 'Smc.Perl'
extends 'Smc.Language'

has.id              = { '+', default = 'PERL' }
has.name            = { '+', default = 'Perl' }
has.option          = { '+', default = '-perl' }
has.suffix          = { '+', default = '_sm' }
has.generator       = { '+', isa = 'Smc.Perl.Generator',
                        default = function () return require 'Smc.Perl.Generator' end }
has.reflectFlag     = { '+', default = true }


class 'Smc.Perl.Generator'
extends 'Smc.Generator'

has.suffix          = { '+', default = 'pm' }

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

