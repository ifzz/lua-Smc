
require 'Coat'

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


class 'Smc.ObjC.HeaderGenerator'
extends 'Smc.Generator'

has.suffix          = { '+', default = 'h' }

