
require 'Coat'
require 'Coat.Role'

role 'Smc.Visitor'

requires('visitFSM',
         'visitMap',
         'visitState',
         'visitTransition',
         'visitGuard',
         'visitAction',
         'visitParameter')


abstract 'Smc.Generator'
with 'Smc.Visitor'

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

has.stream          = { is = 'rw', isa = 'file' }
has.guardCount      = { is = 'rw', isa = 'number' }
has.guardIndex      = { is = 'rw', isa = 'number' }

function method:sourceFile(path, basename, suffix)
    suffix = suffix or self.suffix
    return path .. basename .. "." .. suffix
end

function method:isLoopback(transType, endState)
    return (transType == 'TRANS_SET' or transType == 'TRANS_PUSH') and endState == 'nil'
end

function method:scopeStateName(stateName, mapName)
    local idx = stateName:find "::"
    if idx then
        return stateName:sub(1, idx-1) .. self.scopeSep .. stateName:sub(idx+2)
    else
        return mapName .. self.scopeSep .. stateName
    end
end

