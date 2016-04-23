
require 'Coat'

abstract 'Smc.Language'

has.id              = { is = 'ro', isa = 'string', required = true }
has.name            = { is = 'ro', isa = 'string', required = true }
has.option          = { is = 'ro', isa = 'string', required = true }
has.suffix          = { is = 'ro', isa = 'string', required = true }
has.generator       = { is = 'ro', isa = 'Smc.Generator', required = true }

-- flags supported by all languages
has.directoryFlag   = { is = 'ro', isa = 'boolean', default = true }
has.debugFlag       = { is = 'ro', isa = 'boolean', default = true }
has.debugLevel0Flag = { is = 'ro', isa = 'boolean', default = true }
has.debugLevel1Flag = { is = 'ro', isa = 'boolean', default = true }
has.noCatchFlag     = { is = 'ro', isa = 'boolean', default = true }
has.suffixFlag      = { is = 'ro', isa = 'boolean', default = true }
has.dumpFlag        = { is = 'ro', isa = 'boolean', default = true }

-- flags not supported by all languages
has.accessFlag      = { is = 'ro', isa = 'boolean' }
has.castFlag        = { is = 'ro', isa = 'boolean' }
has.crtpFlag        = { is = 'ro', isa = 'boolean' }
has.genericFlag     = { is = 'ro', isa = 'boolean' }
has.java7Flag       = { is = 'ro', isa = 'boolean' }
has.glevelFlag      = { is = 'ro', isa = 'boolean' }
has.headerFlag      = { is = 'ro', isa = 'boolean' }
has.noExceptionFlag = { is = 'ro', isa = 'boolean' }
has.noStreamFlag    = { is = 'ro', isa = 'boolean' }
has.protocolFlag    = { is = 'ro', isa = 'boolean' }
has.reflectFlag     = { is = 'ro', isa = 'boolean' }
has.stackFlag       = { is = 'ro', isa = 'boolean' }
has.serialFlag      = { is = 'ro', isa = 'boolean' }
has.syncFlag        = { is = 'ro', isa = 'boolean' }

has.accessLevels    = { is = 'ro', isa = 'table<string,string>' }
has.castTypes       = { is = 'ro', isa = 'table<string,boolean>' }

