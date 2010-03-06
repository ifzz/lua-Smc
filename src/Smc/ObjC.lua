
require 'Coat'

local ipairs = ipairs

singleton 'Smc.ObjC'
extends 'Smc.Language'

has.id              = { '+', default = 'OBJECTIVE_C' }
has.name            = { '+', default = 'Objective-C' }
has.option          = { '+', default = '-objc' }
has.suffix          = { '+', default = '_sm' }
has.generator       = { '+', isa = 'Smc.ObjC.Generator',
                        default = function () return require 'Smc.ObjC.Generator' end }
has.headerFlag      = { '+', default = true }

class 'Smc.ObjC.Generator'
extends 'Smc.Generator'

has.suffix          = { '+', default = 'm' }
has.next_generator  = { '+', isa = 'Smc.ObjC.HeaderGenerator',
                        default = function () return require 'Smc.ObjC.HeaderGenerator' end }

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


class 'Smc.ObjC.HeaderGenerator'
extends 'Smc.Generator'

has.suffix          = { '+', default = 'h' }

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
