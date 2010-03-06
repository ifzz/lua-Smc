
require 'Coat'

local ipairs = ipairs

singleton 'Smc.Ruby'
extends 'Smc.Language'

has.id              = { '+', default = 'RUBY' }
has.name            = { '+', default = 'Ruby' }
has.option          = { '+', default = '-ruby' }
has.suffix          = { '+', default = '_sm' }
has.generator       = { '+', isa = 'Smc.Ruby.Generator',
                        default = function () return require 'Smc.Ruby.Generator' end }
has.reflectFlag     = { '+', default = true }


class 'Smc.Ruby.Generator'
extends 'Smc.Generator'

has.suffix          = { '+', default = 'rb' }

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

