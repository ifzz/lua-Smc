
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
with 'Smc.Visitor'

has.suffix          = { '+', default = 'html' }

function override:generate(fsm, stream)
    self.stream = stream
    self:visitFSM(fsm)
end

function method:visitFSM (fsm)
    local stream = self.stream

    stream:write "<html>\n"
    stream:write "  <head>\n"
    stream:write("    <title>", self.srcfileBase, "</title>\n")
    stream:write "  </head>\n"
    stream:write "\n"
    stream:write "  <body>\n"

    local sep = ""
    for _, map in ipairs(fsm.maps) do
        stream:write(sep)
        map:visit(self)
        sep = "    <p>\n"
    end

    stream:write "  </body>\n"
    stream:write "</html>\n"
end

function method:visitMap (map)
    local stream = self.stream

    local mapName = map.name
    local transitions = map.transitions
    local transitionCount = #transitions + 1

    stream:write "    <table align=center border=3 cellspacing=2 cellpadding=2>\n"
    stream:write "      <caption align=\"top\">\n"
    stream:write("        ", mapName, " Finite State Machine\n")
    stream:write "      </caption>\n"

    stream:write "      <tr>\n"
    stream:write "        <th rowspan=2>\n"
    stream:write "          State\n"
    stream:write "        </th>\n"
    stream:write "        <th colspan=2>\n"
    stream:write "          Actions\n"
    stream:write "        </th>\n"
    stream:write("        <th colspan=", transitionCount, ">\n")
    stream:write "          Transition\n"
    stream:write "        </th>\n"
    stream:write "      </tr>\n"
    stream:write "      <tr>\n"
    stream:write "        <th>\n"
    stream:write "          Entry\n"
    stream:write "        </th>\n"
    stream:write "        <th>\n"
    stream:write "         Exit\n"
    stream:write "        </th>\n"

    for _, trans in ipairs(transitions) do
        local transName = trans.name
        if transName ~= 'Default' then
            local parameters = trans.parameters
            stream:write "        <th>\n"
            stream:write("          ", transName, "\n")

            if #parameters > 0 then
                stream:write "          <br>\n"
                stream:write "          ("
                local first = true
                for _, param in ipairs(parameters) do
                    if not first then
                        stream:write ",\n"
                        stream:write "          <br>\n"
                        stream:write "          "
                    end
                    param:visit(self)
                    first = false
                end
                stream:write ")\n"
            end

            stream:write "        </th>\n"
        end
    end

    stream:write "        <th>\n"
    stream:write "          <b>Default</b>\n"
    stream:write "        </th>\n"
    stream:write "      </tr>\n"

    for _, state in ipairs(map.states) do
        stream:write "      <tr>\n"
        state:visit(self)

        -- We need to generate transitions in the exact same order as in the header.
        for _, trans in ipairs(transitions) do
            local transName = trans.name
            if transName ~= 'Default' then
                stream:write "        <td>\n"
                local transition = state:findTransition(transName)
                if transition then
                    stream:write "          <pre>\n"
                    transition:visit(self)
                    stream:write "          </pre>\n"
                end
                stream:write "        </td>\n"
            end
        end

        stream:write "        <td>\n"
        local transition = state:findTransition('Default')
        if transition then
            stream:write "          <pre>\n"
            transition:visit(self)
            stream:write "          </pre>\n"
        end
        stream:write "        </td>\n"

        stream:write "      </tr>\n"
    end

    stream:write "    </table>\n"
end

function method:visitState (state)
    local stream = self.stream

    stream:write "        <td>\n"
    stream:write("          ", state.instanceName, "\n")
    stream:write "        </td>\n"

    local actions = state.entryActions
    stream:write "        <td>\n"
    if actions then
        stream:write "          <pre>\n"
        for _, action in ipairs(actions) do
            action:visit(self, '')
        end
        stream:write "          </pre>\n"
    end
    stream:write "        </td>\n"

    local actions = state.exitActions
    stream:write "        <td>\n"
    if actions then
        stream:write "          <pre>\n"
        for _, action in ipairs(actions) do
            action:visit(self, '')
        end
        stream:write "          </pre>\n"
    end
    stream:write "        </td>\n"
end

function method:visitTransition (transition)
    local stream = self.stream

    for _, guard in ipairs(transition.guards) do
        stream:write "\n"
        guard:visit(self)
    end
end

function method:visitGuard (guard)
    local stream = self.stream

    local condition = guard.condition
    if condition ~= '' then
        stream:write("[", condition, "]\n")
    end

    local transType = guard.transType
    local endState = guard.endState
    if transType == 'TRANS_POP' then
        stream:write "  pop("
        if endState ~= 'nil' then
            stream:write(endState)
            local popArgs = guard.popArgs
            if popArgs ~= '' then
                stream:write(", ", popArgs)
            end
        end
        stream:write ")\n"
    elseif transType == 'TRANS_PUSH' then
        stream:write "  push("
        if endState == 'nil' then
            local state = guard.transition.state
            stream:write(state.map.name, "::", state.name)
        else
            stream:write(endState)
        end
        stream:write ")\n"
    else
        stream:write "  "
        if endState == 'nil' then
            local state = guard.transition.state
            stream:write(state.instanceName)
        else
            stream:write(endState)
        end
        stream:write "\n"
    end

    if guard.hasActions then
        stream:write "  {\n"
        for _, action in ipairs(guard.actions) do
            action:visit(self, "    ")
        end
        stream:write "  }\n"
    else
        stream:write "  {}\n"
    end
end

function method:visitAction (action, indent)
    local stream = self.stream
    stream:write(indent, action.name)
    if action.propertyFlag then
        stream:write(" = ", action.arguments[1])
    else
        local args = table.concat(action.arguments or {}, ", ")
        stream:write("(", args, ")")
    end
    stream:write ";\n"
end

function method:visitParameter (parameter)
    local stream = self.stream
    stream:write(parameter.name)
    local _type = parameter._type or ''
    if _type ~= '' then
        stream:write(": ", _type)
    end
end

