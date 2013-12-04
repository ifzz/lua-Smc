
require 'Coat'

local string = require 'string'

abstract 'Smc.Generator'

has.suffix          = { is = 'ro', isa = 'string', required = true }
has.srcfileBase     = { is = 'ro', isa = 'string', required = true }
has.targetfileBase  = { is = 'ro', isa = 'string', required = true }
has.scopeSep        = { is = 'ro', isa = 'string', default = '.' }
has.next_generator  = { is = 'ro', isa = 'Smc.Generator' }

has.castType        = { is = 'rw', isa = 'string', default = 'dynamic_cast' }
has.accessLevel     = { is = 'rw', isa = 'string', default = 'public' }
has.srcDirectory    = { is = 'rw', isa = 'string', default = '' }
has.headerDirectory = { is = 'rw', isa = 'string' }
has.graphLevel      = { is = 'rw', isa = 'number', default = 0 }
has.debugLevel      = { is = 'rw', isa = 'number', default = -1 }
has.serialFlag      = { is = 'rw', isa = 'boolean', default = false }
has.noExceptionFlag = { is = 'rw', isa = 'boolean', default = false }
has.noCatchFlag     = { is = 'rw', isa = 'boolean', default = false }
has.noStreamsFlag   = { is = 'rw', isa = 'boolean', default = false }
has.reflectFlag     = { is = 'rw', isa = 'boolean', default = false }
has.syncFlag        = { is = 'rw', isa = 'boolean', default = false }
has.genericFlag     = { is = 'rw', isa = 'boolean', default = false }
has.java7Flag       = { is = 'rw', isa = 'boolean', default = false }

has.stream          = { is = 'rw', isa = 'file' }
has.guardCount      = { is = 'rw', isa = 'number' }
has.guardIndex      = { is = 'rw', isa = 'number' }

has.debugLevel0     = { is = 'ro', lazy_build = true }
has.debugLevel1     = { is = 'ro', lazy_build = true }
has.graphLevel1     = { is = 'ro', lazy_build = true }
has.graphLevel2     = { is = 'ro', lazy_build = true }
has.catchFlag       = { is = 'ro', lazy_build = true }
has.template        = { is = 'ro', lazy_build = true }

function method:_build_debugLevel0 ()
    return self.debugLevel >= 0
end

function method:_build_debugLevel1 ()
    return self.debugLevel >= 1
end

function method:_build_graphLevel1 ()
    return self.graphLevel >= 1
end

function method:_build_graphLevel2 ()
    return self.graphLevel >= 2
end

function method:_build_catchFlag ()
    return not self.noCatchFlag
end

function method:generate(fsm, stream)
    local tmpl = self.template
    tmpl.fsm = fsm
    tmpl.generator = self
    local output, msg = tmpl 'TOP'
    stream:write(output)
    if msg then error(msg) end
end

function method:sourceFile(path, basename, suffix)
    suffix = suffix or self.suffix
    return path .. basename .. "." .. suffix
end
