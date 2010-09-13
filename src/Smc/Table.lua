
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

function override:generate(fsm, stream)
    local function maps4html ()
        local maps = {}
        for _, map in ipairs(fsm.maps) do
            -- We need to generate transitions in the exact same order as in the header.
            local transitions = {}
            for _, trans in ipairs(map.transitions) do
                local name = trans.name
                if name ~= 'Default' then
                    table.insert(transitions, name)
                end
            end
            local states = {}
            for _, state in ipairs(map.states) do
                local t = {}
                for _, trans in ipairs(map.transitions) do
                    local name = trans.name
                    if name ~= 'Default' then
                        table.insert(t, state:findTransition(name) or {})
                    end
                end
                table.insert(t, state:findTransition('Default') or {})
                table.insert(states, {
                    state = state,
                    transitions = t,
                })
            end
            if map.defaultState then
                local t = {}
                for _, trans in ipairs(map.transitions) do
                    local name = trans.name
                    if name ~= 'Default' then
                        table.insert(t, map.defaultState:findTransition(name) or {})
                    end
                end
                table.insert(t, map.defaultState:findTransition('Default') or {})
                table.insert(states, {
                    state = map.defaultState,
                    transitions = t,
                })
            end
            table.insert(maps, {
                map = map,
                nbTransitions = #transitions + 1,
                states = states,
            })
        end
        return maps
    end -- maps4html

    local tmpl = self.template
    tmpl.fsm = fsm
    tmpl.generator = self
    tmpl.maps = maps4html()
    local output, msg = tmpl 'TOP'
    stream:write(output)
    if msg then error(msg) end
end

function method:_build_template ()
    local function escape_xml (s)
        s = s:gsub("&", "&amp;")
        s = s:gsub(">", "&gt;")
        s = s:gsub("<", "&lt;")
        return s
    end

    return CodeGen{
        TOP = [[
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
  <head>
    <title>${generator.srcfileBase}</title>
    <style type="text/css">
        table {
            empty-cells: hide;
        }
        caption {
            caption-side: top;
            text-align: center;
        }
        td {
            vertical-align: top;
        }
    </style>
  </head>

  <body>
${maps/_map()}
  </body>
</html>
]],
        _map = [[
    <div>
      <table border="3" cellspacing="2" cellpadding="2">
        <caption>
          ${map.name} Finite State Machine
        </caption>
        <tr>
          <th rowspan="2">
            State
          </th>
          <th colspan="2">
            Actions
          </th>
          <th colspan="${nbTransitions}">
            Transition
          </th>
        </tr>
        <tr>
          <th>
            Entry
          </th>
          <th>
            Exit
          </th>
${map.transitions/_transition_header()}
          <th>
            <b>Default</b>
          </th>
        </tr>
${states/_state()}
      </table>
      <br />
    </div>
]],
            _transition_header = "${isntDefault?_transition_header_if()}\n",
            _transition_header_if = [[
          <th>
            ${name}
${hasParameters?_transition_header_param()}
          </th>
]],
                _transition_header_param = [[
            <br />
              (
              ${parameters/_parameter_header(); separator=",\n<br />"}
              )
]],
                    _parameter_header = "${name}${_type?_parameter_type()}",
                    _parameter_type = ": ${_type}",
        _state = [[
            <tr>
              <th>
                ${state.name}
              </th>
              <td>
${state.entryActions?_state_entry()}
              </td>
              <td>
${state.exitActions?_state_exit()}
              </td>
${transitions/_transition()}
            </tr>
]],
            _state_entry = [[
<pre>
${state.entryActions/_action()}
</pre>
]],
            _state_exit = [[
<pre>
${state.exitActions/_action()}
</pre>
]],
        _transition = [[
              <td>
${name?_transition_if()}
              </td>
]],
            _transition_if = [[
<pre>
${guards/_guard(); separator="\n"}
</pre>
]],
        _guard = [[
${hasCondition?_condition()}
${doesPop?_guard_pop()!_guard_no_pop()}
${hasActions?_actions()!_no_action()}
]],
            _condition = [[
[${condition; format=escape}]
]],
            escape = escape_xml,
            _guard_no_pop = "${doesPush?_guard_push()!_guard_set()}",
            _guard_pop = [[
  pop(${endState}${popArgs; format=with_arg})
]],
                with_arg = function (s)
                    if s == '' then
                        return s
                    else
                        return ", " .. escape_xml(s)
                    end
                end,
            _guard_push = [[
  ${endState}/push(${pushState})
]],
            _guard_set = [[
  ${endState}
]],
            _actions = [[
  {
    ${actions/_action()}
  }
]],
            _no_action = [[
  {}
]],
        _action = "${propertyFlag?_action_prop()!_action_no_prop()}\n",
            _action_prop = [[
${name} = ${arguments; format=escape};
]],
            _action_no_prop = [[
${name}(${arguments; separator=", "; format=escape});
]],
    }
end

