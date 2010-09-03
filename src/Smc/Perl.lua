
require 'Coat'

singleton 'Smc.Perl'
extends 'Smc.Language'

has.id              = { '+', default = 'PERL' }
has.name            = { '+', default = 'Perl' }
has.option          = { '+', default = '-perl' }
has.suffix          = { '+', default = '_sm' }
has.generator       = { '+', isa = 'Smc.Perl.Generator',
                        default = function () return require 'Smc.Perl.Generator' end }
has.reflectFlag     = { '+', default = true }


class 'Smc.Perl.Generator'
extends 'Smc.Generator'

has.suffix          = { '+', default = 'pm' }

function method:_build_template ()
    return CodeGen{
        TOP = [[
# ex: set ro:
# DO NOT EDIT.
# generated by smc (http://github.com/fperrad/lua-Smc)
# from file : ${fsm.filename}

${_preamble()}
${_base_state()}
${fsm.maps:_map()}
${_context()}
1;

# Local variables:
#  buffer-read-only: t
# End:
]],
        _preamble = [[
${fsm.source}
use strict;
use warnings;

use DFA::Statemap;
${fsm.importList:_import()}
]],
            _import = "use ${it};\n",
        _base_state = [[

package ${fsm.context}State;
    use base qw(DFA::Statemap::State);

    use Carp;

    sub Entry {}

    sub Exit {}

    my %meth = (
        ${fsm.transitions:_transition_base_state()}
    );

    sub AUTOLOAD {
        my $self = shift;
        use vars qw( $AUTOLOAD );
        (my $method = $AUTOLOAD) =~ s/^.*:://;
        return unless exists $meth{$method};
        $self->Default(@_);
    }

    sub Default {
        my $self = shift;
        my ($fsm) = @_;
        ${generator.debugLevel0?_base_state_debug()!_base_state_no_debug()}
    }
]],
            _transition_base_state = "${isntDefault?_transition_base_state_if()}\n",
            _transition_base_state_if = "${name} => undef,",
            _base_state_debug = [[
if ($fsm->getDebugFlag()) {
    my $fh = $fsm->getDebugStream();
    print $fh "TRANSITION   : Default\n";
}
confess "TransitionUndefinedException\n",
    "State: ", $fsm->getState()->getName(), "\n",
    "Transition: ", $fsm->getTransition(), "\n";
]],
            _base_state_no_debug = [[
croak "TransitionUndefinedException\n",
    "State: ", $fsm->getState()->getName(), "\n",
    "Transition: ", $fsm->getTransition(), "\n";
]],
        _map = [[

package ${name};

    use vars qw(
        ${states:_state_var()}
        $Default
    );

package ${name}_Default;
    use base qw(${fsm.context}State);
    ${defaultState?_map_default_state()}
    ${generator.reflectFlag?_state_reflect()}
${states:_state()}

package ${name};

    sub BEGIN {
        ${states:_state_init()}
        $Default = ${name}_Default->new('${name}.Default', -1);
    }
]],
            _state_var = "$${instanceName}\n",
            _state_init = "$${instanceName} = ${map.name}_${className}->new('${map.name}.${className}', ${map.nextStateId});\n",
            _map_default_state = "${defaultState.transitions:_transition()}",
        _state = [[

package ${map.name}_${className};
    use base qw(${map.name}_Default);
    ${entryActions?_state_entry()}
    ${exitActions?_state_exit()}
    ${transitions:_transition()}
    ${generator.reflectFlag?_state_reflect()}
]],
            _state_entry = [[

sub Entry {
    my $self = shift;
    my ($fsm) = @_;
    my $ctxt = $fsm->getOwner();
    ${entryActions:_action()}
}
]],
            _state_exit = [[

sub Exit {
    my $self = shift;
    my ($fsm) = @_;
    my $ctxt = $fsm->getOwner();
    ${exitActions:_action()}
}
]],
            _state_reflect = [[

sub getTransitions {
    return {
        ${reflect:_reflect()}
    }
}
]],
                _reflect = "'${name}' => ${def},\n",
        _transition = [[

sub ${name} {
    my $self = shift;
    my ($fsm${parameters:_parameter_proto()}) = @_;
    ${hasCtxtReference?_transition_ctxt()}
    ${generator.debugLevel0?_transition_debug()}
    ${guards:_guard()}
    ${needFinalElse?_transition_else()}
}
]],
            _parameter_proto = ", ${name}",
            _transition_ctxt = [[
my $ctxt = $fsm->getOwner();
]],
            _transition_debug = [[
if ($fsm->getDebugFlag()) {
    my $fh = $fsm->getDebugStream();
    print $fh "LEAVING STATE   : ${state.map.name}.${state.className}\n";
}
]],
            _transition_else = [[
else {
    $self->SUPER::${name}($fsm${parameters:_parameter_proto()});
}
]],
        _guard = "${hasCondition?_guard_conditional()!_guard_unconditional()}",
            _guard_conditional = "${ifCondition?_guard_if()!_guard_no_if()}",
            _guard_no_if = "${elseifCondition?_guard_elseif()!_guard_else()}",
            _guard_unconditional = [[
${_guard_core()}
]],
            _guard_if = [[
if (${condition}) {
    ${_guard_core()}
}
]],
            _guard_elseif = [[

elsif (${condition}) {
    ${_guard_core()}
}
]],
            _guard_else = [[

else {
    ${_guard_core()}
}
]],
            _guard_core = [[
${needVarEndState?_guard_end_state()}
${doesExit?_guard_exit()}
${generator.debugLevel0?_guard_debug_enter()}
${hasActions?_guard_actions()!_guard_no_action()}
${generator.debugLevel0?_guard_debug_exit()}
${doesSet?_guard_set()}
${doesPush?_guard_push()}
${doesPop?_guard_pop()}
${doesEntry?_guard_entry()}
${doesEndPop?_guard_end_pop()}
]],
                _guard_end_state = "my $${varEndState} = $fsm->getState();",
                _guard_exit = [[
${generator.debugLevel1?_guard_debug_before_exit()}
$fsm->getState()->Exit($fsm);
${generator.debugLevel1?_guard_debug_after_exit()}
]],
                    _guard_debug_before_exit = [[
if ($fsm->getDebugFlag()) {
    my $fh = $fsm->getDebugStream();
    print $fh "BEFORE EXIT     : ${transition.state.fullName}->Exit($fsm)\n";
}
]],
                    _guard_debug_after_exit = [[
if ($fsm->getDebugFlag()) {
    my $fh = $fsm->getDebugStream();
    print $fh "AFTER EXIT      : ${transition.state.fullName}->Exit($fsm)\n";
}
]],
                _guard_debug_enter = [[
if ($fsm->getDebugFlag()) {
    my $fh = $fsm->getDebugStream();
    print $fh "ENTER TRANSITION: ${transition.state.fullName}->${transition.name}(${transition.parameters:_guard_debug_param(); separator=', '})\n";
}
]],
                    _guard_debug_param = "${name}",
                _guard_no_action = "${hasCondition?_guard_no_action_if()}",
                    _guard_no_action_if = "# No actions.\n",
                _guard_actions = [[
$fsm->clearState();
${generator.catchFlag?_guard_actions_protected()!_guard_actions_not_protected()}
]],
                    _guard_actions_protected = [[
eval {
    ${actions:_action()}
};
warn $@ if ($@);
]],
                    _guard_actions_not_protected = "${actions:_action()}",
                _guard_debug_exit = [[
if ($fsm->getDebugFlag()) {
    my $fh = $fsm->getDebugStream();
    print $fh "EXIT TRANSITION : ${transition.state.fullName}->${transition.name}(${transition.parameters:_guard_debug_param(); separator=', '})\n";
}
]],
                _guard_set = "$fsm->setState($${varEndState; format=scoped});",
                scoped = function (s) return s:gsub("%.", "::") end,
                _guard_push = [[
${doesPushSet?_guard_set()}
${doesPushEntry?_guard_entry()}
$fsm->pushState($${pushStateName; format=scoped});
]],
                _guard_pop = "$fsm->popState();",
                _guard_entry = [[
${generator.debugLevel1?_guard_debug_before_entry()}
$fsm->getState()->Entry($fsm);
${generator.debugLevel1?_guard_debug_after_entry()}
]],
                    _guard_debug_before_entry = [[
if ($fsm->getDebugFlag()) {
    my $fh = $fsm->getDebugStream();
    print $fh "BEFORE ENTRY    : ${transition.state.fullName}.Entry(fsm)\n";
}
]],
                    _guard_debug_after_entry = [[
if ($fsm->getDebugFlag()) {
    my $fh = $fsm->getDebugStream();
    print $fh "AFTER ENTRY     : ${transition.state.fullName}.Entry(fsm)\n";
}
]],
                _guard_end_pop = "$fsm->${endStateName}(${popArgs});",
        _action = "${propertyFlag?_action_prop()!_action_no_prop()}\n",
            _action_prop = "$ctxt->{${name}} = ${arguments};",
            _action_no_prop = "${isEmptyStateStack?_action_ess()!_action_no_ess()}",
            _action_ess = "$fsm->emptyStateStack();",
            _action_no_ess = "$ctxt->${name}(${arguments; separator=', '});",
        _context = [[

package ${fsm.context}_sm;
    use base qw(DFA::Statemap::FSMContext);

    sub new {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self = $class->SUPER::new($${fsm.startState});
        my ($owner) = @_;
        $self->{_owner} = $owner;
        return $self;
    }

    sub AUTOLOAD {
        my $self = shift;
        use vars qw( $AUTOLOAD );
        (my $method = $AUTOLOAD) =~ s/^.*:://;
        return unless exists $meth{$method};
        $self->{_transition} = $method;
        $self->getState()->$method($self, @_);
        $self->{_transition} = undef;
    }

    sub enterStartState {
        my $self = shift;
        $self->{_state}->Entry($self);
    }

    sub getOwner {
        my $self = shift;
        return $self->{_owner};
    }

    ${generator.reflectFlag?_context_reflect()}
]],
            _context_reflect = [[
sub getStates {
    my $self = shift;
    return (
        ${fsm.maps:_map_context_reflect()}
    );
}

sub getTransitions {
    my $self = shift;
    return (
        ${fsm.transitions:_transition_context_reflect()}
    )
}

]],
                _map_context_reflect = "${states:_state_context_reflect()}\n",
                     _state_context_reflect = "$${map.name}::${className},\n",
                _transition_context_reflect = "'${name}',\n",
    }
end
