
require 'Coat'

singleton 'Smc.Vb'
extends 'Smc.Language'

has.id              = { '+', default = 'VB' }
has.name            = { '+', default = 'VB.Net' }
has.option          = { '+', default = '-vb' }
has.suffix          = { '+', default = '_sm' }
has.generator       = { '+', isa = 'Smc.Vb.Generator',
                        default = function () return require 'Smc.Vb.Generator' end }
has.genericFlag     = { '+', default = true }
has.reflectFlag     = { '+', default = true }
has.serialFlag      = { '+', default = true }
has.syncFlag        = { '+', default = true }


class 'Smc.Vb.Generator'
extends 'Smc.Generator'

has.suffix          = { '+', default = 'vb' }

