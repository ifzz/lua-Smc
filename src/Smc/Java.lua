
require 'Coat'

local ipairs = ipairs

singleton 'Smc.Java'
extends 'Smc.Language'

has.id              = { '+', default = 'JAVA' }
has.name            = { '+', default = 'Java' }
has.option          = { '+', default = '-java' }
has.suffix          = { '+', default = 'Context' }
has.generator       = { '+', isa = 'Smc.Java.Generator',
                        default = function () return require 'Smc.Java.Generator' end }
has.accessFlag      = { '+', default = true }
has.genericFlag     = { '+', default = true }
has.reflectFlag     = { '+', default = true }
has.serialFlag      = { '+', default = true }
has.syncFlag        = { '+', default = true }
has.accessLevels    = { '+', default = {
                                public = 'public',
                                protected = 'protected',
                                package = '/* package */',
                                private = 'private' } }


class 'Smc.Java.Generator'
extends 'Smc.Generator'

has.suffix          = { '+', default = 'java' }

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

