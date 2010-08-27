
require 'Coat'

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

function method:_build_template ()
    return CodeGen{
        TOP = [[
<html>
</html>
]],
    }
end
