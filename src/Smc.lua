
require 'Coat'
require 'Coat.Types'

local io = require 'io'
local os = require 'os'
local table = require 'table'
local string = require 'string'
local error = error
local ipairs = ipairs
local pairs = pairs
local pcall = pcall
local print = print
local require = require
local tonumber = tonumber

singleton 'Smc'

_VERSION = "0.0.1"
_DESCRIPTION = "lua-Smc : the State Machine Compiler in lua-Coat"
_COPYRIGHT = "Copyright (c) 2010 Francois Perrad"

require 'Smc.Parser'
require 'Smc.Checker'

has.languages       = { is = 'ro', lazy_build = true }
has.verbose         = { is = 'rw', isa = 'boolean', default = false }
has.fsmVerbose      = { is = 'rw', isa = 'boolean', default = false }
has._return         = { is = 'rw', isa = 'boolean', default = false }
has._dump           = { is = 'rw', isa = 'boolean', default = false }
has.targetLanguage  = { is = 'rw', isa = 'Smc.Language' }
has.option          = { is = 'rw', isa = 'table' }
has.sourceFileList  = { is = 'rw', isa = 'table<string>' }

function method:_build_languages ()
    return {
        require('Smc.C').instance(),
        require('Smc.Cpp').instance(),
        require('Smc.Csharp').instance(),
        require('Smc.Graphviz').instance(),
        require('Smc.Groovy').instance(),
        require('Smc.Java').instance(),
        require('Smc.Lua').instance(),
        require('Smc.ObjC').instance(),
        require('Smc.Perl').instance(),
        require('Smc.Php').instance(),
        require('Smc.Python').instance(),
        require('Smc.Ruby').instance(),
        require('Smc.Scala').instance(),
        require('Smc.Table').instance(),
        require('Smc.Tcl').instance(),
        require('Smc.Vb').instance(),
    }
end

function method:usage ()
    local langs = {}
    local gen = ''
    for _, v in ipairs(self.languages) do
        table.insert(langs, v.option)
        gen = gen .. string.format("\t%-8s  Generate %s code\n", v.option, v.name)
    end
    print(string.format("usage: %s [%s] {%s} statemap_file",
        _NAME,
        table.concat({
            '-access level',
            '-suffix suffix',
            '-g | -g0 | -g1',
            '-nostreams',
            '-version',
            '-verbose',
            '-help',
            '-sync',
            '-noex',
            '-nocatch',
            '-serial',
            '-return',
            '-reflect',
            '-generic',
            '-cast cast_type',
            '-d directory',
            '-headerd directory',
            '-glevel int',
            '-load mod',
            '-dump',
        }, '] ['),
        table.concat(langs, ' | ')
    ))
    print(string.format([===[
    where:
	-access   Use this access keyword for the generated classes
	          (use with -java only)
	-suffix   Add this suffix to output file
	-g, -g0   Add level 0 debugging output to generated code
	          (output for entering, exiting states and transitions)
	-g1       Add level 1 debugging output to generated code
	          (level 0 output plus state Entry and Exit actions)
	-nostreams Do not use C++ iostreams
	          (use with -c++ only)
	-version  Print smc version information to standard out and exit
	-verbose  Output more compiler messages.
	-help     Print this message to standard out and exit
	-sync     Synchronize access to transition methods
	          (use with -csharep, -java, -groovy, -scala and -vb only)
	-noex     Do not generate C++ exception throws
	          (use with -c++ only)
	-nocatch  Do not generate try/catch/rethrow code (not recommended)
	-serial   Generate serialization code
	-return   Smc.main() returns, not exits
	          (use this option with ANT)
	-reflect  Generate reflection code
	          (use with -csharp, -groovy, -java, -lua, -perl, -php, -python, -ruby, -scala, -tcl and -vb only)
	-generic  Use generic collections
	          (use with -csharp, -java or -vb and -reflect only)
	-cast     Use this C++ cast type
	          (use with -c++ only)
	-d        Place generated files in directory
	-headerd  Place generated header files in directory
	          (use with -c, -c++ only)
	-glevel   Detail level from 0 (least) to 2 (greatest)
	          (use with -graph only)
	-load     Use a language for a plugin
	-dump     Ascii output
%s
    Note: statemap_file must end in ".sm"
    Note: must select one of %s.
]===],
    gen,
    table.concat(langs, ', ')))
end


function method:parseArgs (args)
    local function needHelp ()
        local retval
        if #args == 0 then
            self:usage()
            retval = true
        else
            for _, v in ipairs(args) do
                if v:match'-hel' then
                    self:usage()
                    retval = true
                elseif v:match'-vers' then
                    print(_NAME .. ' ' .. _VERSION)
                    retval = true
                end
            end
        end
        return retval
    end -- needHelp

    local function findLanguage (option)
        for _, v in ipairs(self.languages) do
            if option == v.option then
                return v
            end
        end
    end -- findLanguage

    local function findTargetLanguage ()
        local retval
        for i, v in ipairs(args) do
            local lang
            if v == '-load' then
                local m = require(args[i+1])
                lang = m.instance()
            else
                lang = findLanguage(v)
            end
            if lang then
                if retval then
                    error "Only one target language may be specified"
                else
                    retval = lang
                end
            end
        end
        return retval
    end -- findTargetLanguage

    if not needHelp() then
        targetLanguage = findTargetLanguage()
        if not targetLanguage then
            error "Target language was not specified."
        end
        self.targetLanguage = targetLanguage

        local suffix
        local opt = {}
        local i = 1
        while i <= #args do
            local v = args[i]
            if not v:match'^-' then break end
            local consumed = 0
            if findLanguage(v) then
                consumed = 1
            elseif v:match'-ac' then
                local vv = args[i+1]
                if vv:match'^-' then
                    error "-access not followed by an access keyword"
                end
                if targetLanguage.accessFlag then
                    local lvl = targetLanguage.accessLevels[vv]
                    if not lvl then
                        error( targetLanguage.name .. " does not support access level " .. vv .. ".")
                    end
                    opt.accessLevel = lvl
                    consumed = 2
                else
                    error( targetLanguage.name .. " does not support -access.")
                end
            elseif v:match'-ca' then
                local vv = args[i+1]
                if vv:match'^-' then
                    error "-cast not followed by a value"
                end
                if targetLanguage.castFlag then
                    if not targetLanguage.castTypes[vv] then
                        error("\"" .. vv ..  "\" is an invalid C++ cast type.")
                    end
                    opt.castType = vv
                    consumed = 2
                else
                    error( targetLanguage.name .. " does not support -cast.")
                end
            elseif v == '-d' then
                local vv = args[i+1]
                if vv:match'^-' then
                    error "-d followed by directory"
                end
                if targetLanguage.directoryFlag then
                    vv = vv:gsub("\\", "/")
                    if not vv:match"/$" then
                        vv = vv .. "/"
                    end
                    opt.srcDirectory = vv
                    consumed = 2
                else
                    error( targetLanguage.name .. " does not support -d.")
                end
            elseif v:match'-du' then
                self._dump = true
                consumed = 1
            elseif v:match'-hea' then
                local vv = args[i+1]
                if vv:match'^-' then
                    error "-header followed by directory"
                end
                if targetLanguage.headerFlag then
                    vv = vv:gsub("\\", "/")
                    if not vv:match"/$" then
                        vv = vv .. "/"
                    end
                    opt.headerDirectory = vv
                    consumed = 2
                else
                    error( targetLanguage.name .. " does not support -header.")
                end
            elseif v:match'-ge' then
                if targetLanguage.genericFlag then
                    opt.genericFlag = true
                    consumed = 1
                else
                    error( targetLanguage.name .. " does not support -generic.")
                end
            elseif v:match'-gl' then
                local lvl = tonumber(args[i+1])
                if lvl == nil then
                    error "-glevel not followed by integer"
                end
                if targetLanguage.glevelFlag then
                    if lvl ~= 0 and lvl ~= 1 and lvl ~= 2 then
                        error "-glevel must be 0, 1 or 2"
                    end
                    opt.graphLevel = lvl
                    consumed = 2
                else
                    error( targetLanguage.name .. " does not support -glevel.")
                end
            elseif v == '-g' then
                if targetLanguage.debugFlag then
                    opt.debugLevel = 0
                    consumed = 1
                else
                    error( targetLanguage.name .. " does not support -g.")
                end
            elseif v == '-g0' then
                if targetLanguage.debugLevel0Flag then
                    opt.debugLevel = 0
                    consumed = 1
                else
                    error( targetLanguage.name .. " does not support -g0.")
                end
            elseif v == '-g1' then
                if targetLanguage.debugLevel1Flag then
                    opt.debugLevel = 1
                    consumed = 1
                else
                    error( targetLanguage.name .. " does not support -g1.")
                end
            elseif v == '-load' then
                consumed = 2
            elseif v:match'-noc' then
                if targetLanguage.noCatchFlag then
                    opt.noCatchFlag = true
                    consumed = 1
                else
                    error( targetLanguage.name .. " does not support -nocatch.")
                end
            elseif v:match'-noe' then
                if targetLanguage.noExceptionFlag then
                    opt.noExceptionFlag = true
                    consumed = 1
                else
                    error( targetLanguage.name .. " does not support -noexception.")
                end
            elseif v:match'-nos' then
                if targetLanguage.noStreamFlag then
                    opt.noStreamFlag = true
                    consumed = 1
                else
                    error( targetLanguage.name .. " does not support -nostream.")
                end
            elseif v:match'-ret' then
                self._return = true
                consumed = 1
            elseif v:match'-ref' then
                if targetLanguage.reflectFlag then
                    opt.reflectFlag = true
                    consumed = 1
                else
                    error( targetLanguage.name .. " does not support -reflect.")
                end
            elseif v:match'-se' then
                if targetLanguage.serialFlag then
                    opt.serialFlag = true
                    consumed = 1
                else
                    error( targetLanguage.name .. " does not support -serial.")
                end
            elseif v:match'-su' then
                local vv = args[i+1]
                if vv:match'^-' then
                    error "-suffix not followed by a value"
                end
                if targetLanguage.suffixFlag then
                    opt.suffix = vv
                    consumed = 2
                else
                    error( targetLanguage.name .. " does not support -suffix.")
                end
            elseif v:match'-sy' then
                if targetLanguage.syncFlag then
                    opt.syncFlag = true
                    consumed = 1
                else
                    error( targetLanguage.name .. " does not support -sync.")
                end
            elseif v:match'-verb' then
                self.verbose = true
                consumed = 1
            elseif v:match'-vverb' then
                self.fsmVerbose = true
                consumed = 1
            else
                error( "Unknown option (" .. v .. ").")
            end
            i = i + consumed
        end
        self.option = opt

        if i > #args then
            error "Missing source file"
        end
        local files = {}
        while i <= #args do
            local v = args[i]
            v = v:gsub('\\', '/')
            local f = io.open(v, 'r')
            if not f then
                error( "Source file \"" .. v .. "\" is not readable" )
            end
            f:close()
            table.insert(files, v)
            i = i + 1
        end
        self.sourceFileList = files
    end
end

function method:generateCode (fsm)
    local function dirname (filename)
        filename = filename:reverse()
        local idx = filename:find"/"
        if idx then
            filename = filename:sub(idx+1)
            return filename:reverse()
        else
            return "."
        end
    end -- dirname

    local targetLanguage = self.targetLanguage
    local option = self.option
    local generator = targetLanguage.generator.new{
        srcfileBase     = fsm.name,
        targetfileBase  = fsm.targetFilename,
        castType        = option.castType,
        accessLevel     = option.accessLevel,
        srcDirectory    = option.srcDirectory,
        headerDirectory = option.headerDirectory,
        graphLevel      = option.graphLevel,
        debugLevel      = option.debugLevel,
        serialFlag      = option.serialFlag,
        noExceptionFlag = option.noExceptionFlag,
        noCatchFlag     = option.noCatchFlag,
        noStreamsFlag   = option.noStreamsFlag,
        reflectFlag     = option.reflectFlag,
        syncFlag        = option.syncFlag,
        genericFlag     = option.genericFlag,
    }
    local dir = dirname(fsm.filename) .. "/"
    local filename = generator:sourceFile(option.srcDirectory or dir, fsm.targetFilename, option.suffix)
    local f, msg = io.open(filename, "w")
    if not f then
        error("Cannot open " .. filename .. " (" .. msg .. ")")
    end
    generator:generate(fsm, f)
    f:close()
    if self.verbose then
        print("[wrote " .. filename .. "]")
    end

    while generator.next_generator do
        generator = generator.next_generator.new{
            srcfileBase     = fsm.name,
            targetfileBase  = fsm.targetFilename,
            castType        = option.castType,
            accessLevel     = option.accessLevel,
            srcDirectory    = option.srcDirectory,
            headerDirectory = option.headerDirectory,
            graphLevel      = option.graphLevel,
            debugLevel      = option.debugLevel,
            serialFlag      = option.serialFlag,
            noExceptionFlag = option.noExceptionFlag,
            noCatchFlag     = option.noCatchFlag,
            noStreamsFlag   = option.noStreamsFlag,
            reflectFlag     = option.reflectFlag,
            syncFlag        = option.syncFlag,
            genericFlag     = option.genericFlag,
        }
        filename = generator:sourceFile(option.headerDirectory or dir, fsm.targetFilename)
        f, msg = io.open(filename, "w")
        if not f then
            error("Cannot open " .. filename .. " (" .. msg .. ")")
        end
        generator:generate(fsm, f)
        f:close()
        if self.verbose then
            print("[wrote " .. filename .. "]")
        end
    end
end

function method:main (args)
    local function die (msg)
        print(_NAME .. " has experienced a fatal error.")
        print(_NAME .. " " .. _VERSION .. " (" .. _G._VERSION
           .. " & lua-Coat " .. Coat._VERSION .. ")")
        print(msg)
        os.exit(1)
    end -- die

    local function exit ()
        if self._return then
            os.exit(0)
        else
            os.exit(1)
        end
    end --exit

    local function basename (filename)
        filename = filename:gsub('[^/]*/', '')
        return filename:gsub('%.%a+$', '')
    end -- basename

--    self:parseArgs(args)
    local r, msg = pcall(self.parseArgs, self, args)
    if not r then
        die(msg)
    elseif self.sourceFileList then
        for _, filename in ipairs(self.sourceFileList) do
            local name = basename(filename)
            if self.verbose then
                print("[parsing started " .. filename .. "]")
            end
            local parser = Smc.Parser.new{
                name = name,
                filename = filename,
                stream = io.open(filename, 'r'),
                targetLanguage = self.targetLanguage.id,
                targetFilename = name .. self.targetLanguage.suffix,
                debugFlag = self.fsmVerbose,
            }
            local fsm = parser:parse()
            if self.verbose then
                print "[parsing completed]"
            end
            for _, msg in ipairs(parser.messages) do
                print(tostring(msg))
            end
            if not fsm then
                exit()
            end
            local checker = Smc.Checker.new{
                name = name,
                targetLanguage = self.targetLanguage.id,
            }
            if self.verbose then
                print("[checking " .. filename .. "]")
            end
            checker:check(fsm)
            for _, msg in ipairs(checker.messages) do
                print(tostring(msg))
            end
            if self._dump then
                require 'Smc.Dumper'
                local generator = Smc.Dumper.new{
                    suffix = 'dummy',
                    srcfileBase = fsm.name,
                    targetfileBase = fsm.targetFilename,
                }
                generator:generate(fsm, io.stdout)
            elseif checker.isValid then
--                self:generateCode(fsm)
                local r, msg = pcall(self.generateCode, self, fsm)
                if not r then
                    die(msg)
                end
            else
                exit()
            end
        end
    end
end
