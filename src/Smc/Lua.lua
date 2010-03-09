
require 'Coat'

local table = require 'table'
local ipairs = ipairs

singleton 'Smc.Lua'
extends 'Smc.Language'

has.id              = { '+', default = 'LUA' }
has.name            = { '+', default = 'Lua' }
has.option          = { '+', default = '-lua' }
has.suffix          = { '+', default = '_sm' }
has.generator       = { '+', isa = 'Smc.Lua.Generator',
                        default = function () return require 'Smc.Lua.Generator' end }
has.reflectFlag     = { '+', default = true }


class 'Smc.Lua.Generator'
extends 'Smc.Generator'

has.suffix          = { '+', default = 'lua' }

function method:visitFSM (fsm)
    local stream = self.stream
    stream:write "-- ex: set ro:\n"
    stream:write "-- DO NOT EDIT.\n"
--    stream:write "-- generated by smc (http://smc.sourceforge.net/)\n"
    stream:write("-- from file : ", fsm.filename, "\n")
    stream:write "\n"
    stream:write "module(..., package.seeall)\n"
    stream:write "\n"
    stream:write "require 'statemap'\n"
    if fsm.source then
        stream:write "\n"
        stream:write(fsm.source, "\n")
    end
    for _, imp in ipairs(fsm.importList) do
        stream:write("require '", imp, "'\n")
    end
    local context = fsm.context
    stream:write "\n"
    stream:write("local ", context, "State = statemap.State:class()\n")
    stream:write "\n"
    stream:write("function ", context, "State:Entry (fsm) end\n")
    stream:write "\n"
    stream:write("function ", context, "State:Exit (fsm) end\n")
    stream:write "\n"
    for _, trans in ipairs(fsm.transitions) do
        if trans.name ~= "Default" then
            stream:write("function ", context, "State:", trans.name, " (fsm")
            for _, param in ipairs(trans.parameters) do
                stream:write(", ", param.name)
            end
            stream:write ")\n"
            stream:write "    self:Default(fsm)\n"
            stream:write "end\n"
            stream:write "\n"
        end
    end
    stream:write("function ", context, "State:Default (fsm)\n")
    if self.debugLevel >= 0 then
        stream:write "    if fsm:getDebugFlag() then\n"
        stream:write "        fsm:getDebugStream():write(\"TRANSITION   : Default\\n\")\n"
        stream:write "    end\n"
    end
    stream:write "    local msg = string.format(\"Undefined Transition\\nState: %s\\nTransition: %s\\n\",\n"
    stream:write "                              fsm:getState():getName(),\n"
    stream:write "                              fsm:getTransition())\n"
    stream:write "    error(msg)\n"
    stream:write "end\n"
    stream:write "\n"
    if self.reflectFlag then
        stream:write("function ", context, "State:getTransitions ()\n")
        stream:write "    return self._transitions\n"
        stream:write "end\n"
        stream:write "\n"
    end
    for _, map in ipairs(fsm.maps) do
        stream:write("local ", map.name, " = {}\n")
    end
    for _, map in ipairs(fsm.maps) do
        map:visit(self)
    end
    stream:write "\n"
    local fsmClassname = fsm.fsmClassname
    stream:write(fsmClassname, " = statemap.FSMContext:class()\n")
    stream:write "\n"
    stream:write("function ", fsmClassname, ":_init ()\n")
    local start = self:scopeStateName(fsm.startState)
    stream:write("    self:setState(", start, ")\n")
    stream:write "end\n"
    stream:write "\n"
    for _, trans in ipairs(fsm.transitions) do
        local transName = trans.name
        if transName ~= "Default" then
            stream:write("function ", fsmClassname, ":", transName, " (")
            if #trans.parameters > 0 then
                stream:write("...")
            end
            stream:write(")\n")
            stream:write("    self._transition = '", transName, "'\n")
            stream:write("    self:getState():", transName, "(self")
            if #trans.parameters > 0 then
                stream:write(", ...")
            end
            stream:write(")\n")
            stream:write "    self._transition = nil\n"
            stream:write "end\n"
            stream:write "\n"
        end
    end
    stream:write("function ", fsmClassname, ":enterStartState ()\n")
    stream:write "    self:getState():Entry(self)\n"
    stream:write "end\n"
    stream:write "\n"
    stream:write("function ", fsmClassname, ":getOwner ()\n")
    stream:write "    return self._owner\n"
    stream:write "end\n"
    stream:write "\n"
    if self.reflectFlag then
        stream:write(fsmClassname, "._States = {\n")
        for _, map in ipairs(fsm.maps) do
            for _, state in ipairs(map.states) do
                stream:write("    ", map.name, ".", state.className, ",\n")
            end
        end
        stream:write "}\n"
        stream:write("function ", fsmClassname, ":getStates ()\n")
        stream:write "    return self._States\n"
        stream:write "end\n"
        stream:write "\n"
        stream:write(fsmClassname, "._transitions = {\n")
        for _, trans in ipairs(fsm.transitions) do
            stream:write("    '", trans.name, "',\n")
        end
        stream:write "}\n"
        stream:write("function ", fsmClassname, ":getTransitions ()\n")
        stream:write "    return self._transitions\n"
        stream:write "end\n"
        stream:write "\n"
    end
    stream:write "-- Local variables:\n"
    stream:write "--  buffer-read-only: t\n"
    stream:write "-- End:\n"
end

function method:visitMap (map)
    local stream = self.stream
    local mapName = map.name
    local defaultState = map.defaultState
    local fsm = map.fsm
    local context = fsm.context
    stream:write "\n"
    stream:write(mapName, ".Default = ", context, "State:new('", mapName, ".Default', -1)\n")
    if defaultState then
        for _, trans in ipairs(defaultState.transitions) do
            trans:visit(self)
        end 
    end
    if self.reflectFlag then
        stream:write "\n"
        stream:write(mapName, ".Default._transitions = {\n")
        for _, trans in ipairs(fsm.transitions) do
            local transName = trans.name
            local transDefinition
            if defaultState and defaultState:findTransition(transName) then 
                transDefinition = 2
            else
                transDefinition = 0
            end
            stream:write("    ", transName, " = ", transDefinition, ",\n")
        end
        stream:write "}\n"
    end
    for _, state in ipairs(map.states) do
        state:visit(self)
    end
end

function method:visitState (state)
    local stream = self.stream
    local map = state.map
    local mapName = map.name
    local stateName = state.className
    stream:write "\n"
    stream:write(mapName, ".", stateName, " = ", mapName, ".Default:new('", mapName, ".", stateName, "', ", map.nextStateId, ")\n")
    if state.entryActions then
        stream:write "\n"
        stream:write("function ", mapName, ".", stateName, ":Entry (fsm)\n")
        stream:write "    local ctxt = fsm:getOwner()\n"
        self.indent = "    "
        for _, action in ipairs(state.entryActions) do
            action:visit(self)
        end
        stream:write "end\n"
    end
    if state.exitActions then
        stream:write "\n"
        stream:write("function ", mapName, ".", stateName, ":Exit (fsm)\n")
        stream:write "    local ctxt = fsm:getOwner()\n"
        self.indent = "    "
        for _, action in ipairs(state.exitActions) do
            action:visit(self)
        end
        stream:write "end\n"
    end
    for _, trans in ipairs(state.transitions) do
        trans:visit(self)
    end
    if self.reflectFlag then
        local defaultState = map.defaultState
        stream:write "\n"
        stream:write(mapName, ".", stateName, "._transitions = {\n")
        for _, trans in ipairs(map.fsm.transitions) do
            local transName = trans.name
            local transDefinition 
            if state:findTransition(transName) then
                transDefinition = 1
            elseif defaultState and defaultState:findTransition(transName) then
                transDefinition = 2
            else
                transDefinition = 0
            end
             stream:write("    ", transName, " = ", transDefinition, ",\n")
        end
        stream:write "}\n"
    end
end

function method:visitTransition (transition)
    local stream = self.stream
    local state = transition.state
    local map = state.map
    local mapName = map.name
    local stateName = state.className
    local transName = transition.name
    stream:write "\n"
    stream:write("function ", mapName, ".", stateName, ":", transName, " (fsm")
    for _, param in ipairs(transition.parameters) do
        stream:write(", ", param.name)
    end
    stream:write ")\n"
    if transition.hasCtxtReference then
        stream:write "    local ctxt = fsm:getOwner()\n"
    end
    if self.debugLevel >= 0 then
        stream:write "    if fsm:getDebugFlag() then\n"
        stream:write("        fsm:getDebugStream():write(\"LEAVING STATE   : ", mapName, ".", stateName, "\\n\")\n")
        stream:write "    end\n"
    end
    local guards = transition.guards
    self.guardIndex = 0
    self.guardCount = #guards
    local nullCondition = false
    for _, guard in ipairs(guards) do
        if guard.condition == '' then
            nullCondition = true
        end
        guard:visit(self)
        self.guardIndex = self.guardIndex + 1
    end
    if self.guardIndex > 0 and not nullCondition then
        stream:write("    else\n")
        stream:write("        ", mapName, ".Default:", transName, "(fsm")
        for _, param in ipairs(transition.parameters) do
            stream:write(", ", param.name)
        end
        stream:write ")\n"
        stream:write("    end\n")
    elseif self.guardCount > 1 then
        stream:write("    end\n")
    end
    stream:write "end\n"
end

function method:visitGuard (guard)
    local stream = self.stream
    local condition = guard.condition
    local indent2
    if self.guardCount > 1 then
        indent2 = "        "
        if self.guardIndex == 0 and condition ~= '' then
             stream:write("    if ", condition, " then\n")
        elseif condition ~= '' then
            stream:write("    elseif ", condition, " then\n")
        else
            stream:write("    else\n")
        end
    elseif condition == '' then
        indent2 = "    "
    else
        indent2 = "            "
        stream:write("        if ", condition, " then\n")
    end

    local transition = guard.transition
    local transType = guard.transType
    local transName = transition.name
    local state = transition.state
    local map = state.map
    local mapName = map.name
    local stateName = self:scopeStateName(state.className, mapName)
    local packageName = map.fsm._package
    if packageName then
        stateName = packageName .. "." .. stateName
    end
    local endStateName = guard.endState
    if transType ~= 'TRANS_POP' and endStateName ~= 'nil' then
        endStateName = self:scopeStateName(endStateName, mapName)
    end
    local loopbackFlag = self:isLoopback(transType, endStateName)
    local actions = guard.actions or {}
    local fqEndStateName = endStateName
    if loopbackFlag and #actions > 0 then
        fqEndStateName = "endState";
        stream:write(indent2, "local ", fqEndStateName, " = fsm:getState()\n")
    end

    if transType == 'TRANS_POP' or not loopbackFlag then
        if self.debugLevel >= 1 then
            stream:write(indent2, "if fsm:getDebugFlag() then\n")
            stream:write(indent2, "    fsm:getDebugStream():write(\"BEFORE EXIT     : ", stateName, ".Exit(fsm)\\n\")\n")
            stream:write(indent2, "end\n")
        end
        stream:write(indent2, "fsm:getState():Exit(fsm)\n")
        if self.debugLevel >= 1 then
            stream:write(indent2, "if fsm:getDebugFlag() then\n")
            stream:write(indent2, "    fsm:getDebugStream():write(\"AFTER EXIT      : ", stateName, ".Exit(fsm)\\n\")\n")
            stream:write(indent2, "end\n")
        end
    end

    if self.debugLevel >= 0 then
        stream:write(indent2, "if fsm:getDebugFlag() then\n")
        stream:write(indent2, "    fsm:getDebugStream():write(\"ENTER TRANSITION: ", stateName, ":", transName, "(")
        local sep = ""
        for _, param in ipairs(transition.parameters) do
            stream:write(sep, param.name, "=\" .. tostring(", param.name, ") .. \"")
            sep = ", "
        end
        stream:write(")\\n\")\n")
        stream:write(indent2, "end\n")
    end

    if #actions == 0 then
        if condition ~= '' then
            stream:write(indent2, "-- No actions.\n")
        end
    else
        stream:write(indent2, "fsm:clearState()\n")
        self.indent = indent2
        if not self.noCatchFlag then
            stream:write(indent2, "local r, msg = pcall(\n")
            stream:write(indent2, "    function ()\n")
            self.indent = indent2 .. "        "
        end
        for _, action in ipairs(actions) do
            action:visit(self)
        end
        if not self.noCatchFlag then
            stream:write(indent2, "    end\n")
            stream:write(indent2, ")\n")
            if self.debugLevel >= 1 then
                stream:write(indent2, "if not r then\n")
                stream:write(indent2, "    fsm:getDebugStream():write(msg)\n")
                stream:write(indent2, "end\n")
            end
        end
    end

    if self.debugLevel >= 0 then
        stream:write(indent2, "if fsm:getDebugFlag() then\n")
        stream:write(indent2, "    fsm:getDebugStream():write(\"EXIT TRANSITION: ", stateName, ":", transName, "(")
        local sep = ""
        for _, param in ipairs(transition.parameters) do
            stream:write(sep, param.name, "=\" .. tostring(", param.name, ") .. \"")
            sep = ", "
        end
        stream:write(")\\n\")\n")
        stream:write(indent2, "end\n")
    end

    if transType == 'TRANS_SET' and (not loopbackFlag or #actions > 0) then
        stream:write(indent2, "fsm:setState(", fqEndStateName, ")\n")
    elseif transType == 'TRANS_PUSH' then
        if not loopbackFlag or #actions > 0 then
            stream:write(indent2, "fsm:setState(", fqEndStateName, ")\n")
        end
        if not loopbackFlag then
            if self.debugLevel >= 1 then
                stream:write(indent2, "if fsm:getDebugFlag() then\n")
                stream:write(indent2, "    fsm:getDebugStream():write(\"BEFORE ENTRY    : ", stateName, ":Entry(fsm)\\n\")\n")
                stream:write(indent2, "end\n")
            end
            stream:write(indent2, "fsm:getState():Entry(fsm)\n")
            if self.debugLevel >= 1 then
                stream:write(indent2, "if fsm:getDebugFlag() then\n")
                stream:write(indent2, "    fsm:getDebugStream():write(\"AFTER ENTRY    : ", stateName, ":Entry(fsm)\\n\")\n")
                stream:write(indent2, "end\n")
            end
        end
        local pushStateName = self:scopeStateName(guard.pushState, mapName)
        stream:write(indent2, "fsm:pushState(", pushStateName, ")\n")
    elseif transType == 'TRANS_POP' then
        stream:write(indent2, "fsm:popState()\n")
    end

    if (transType == 'TRANS_SET' and not loopbackFlag) or transType == 'TRANS_PUSH' then
        if self.debugLevel >= 1 then
            stream:write(indent2, "if fsm:getDebugFlag() then\n")
            stream:write(indent2, "    fsm:getDebugStream():write(\"BEFORE ENTRY    : ", stateName, ":Entry(fsm)\\n\")\n")
            stream:write(indent2, "end\n")
        end
        stream:write(indent2, "fsm:getState():Entry(fsm)\n")
        if self.debugLevel >= 1 then
            stream:write(indent2, "if fsm:getDebugFlag() then\n")
            stream:write(indent2, "    fsm:getDebugStream():write(\"AFTER ENTRY    : ", stateName, ":Entry(fsm)\\n\")\n")
            stream:write(indent2, "end\n")
        end
    end

    if transType == 'TRANS_POP' and endStateName ~= 'nil' then
        stream:write(indent2, "fsm:", endStateName, "(", guard.popArgs, ")\n")
    end
end

function method:visitAction (action)
    local stream = self.stream
    stream:write(self.indent)
    if action.propertyFlag then
        stream:write("ctxt.", action.name, " = ", action.arguments[1], "\n")
    else
        if action.isEmptyStateStack then
            stream:write "fsm:emptyStateStack()\n"
        else
            local args = table.concat(action.arguments or {}, ", ")
            stream:write("ctxt:", action.name, "(", args, ")\n")
        end
    end
end

function method:visitParameter (parameter)
end
