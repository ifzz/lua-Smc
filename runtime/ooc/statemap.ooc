
import structs/ArrayList


StateUndefinedException: class extends Exception {
    init: func () {
        this origin = This
        this message = ""
    }
}

TransitionUndefinedException: class extends Exception {
    init: func (name, transition: String) {
        this origin = This
        this message = "State: " + name + ", Transition: " + transition
    }
}

State: abstract class {
    name: String { get set }
    id: Int { get set }
}

FSMContext: abstract class {
    _state: State
    _stateStack: ArrayList<State>
    previousState: State { get set }
    transition: String { get set }
    debugFlag: Bool { get set }
    debugStream: FStream { get set }

    init: func () {
        transition = ""
        debugFlag = false
        debugStream = stderr
        _state = null
        _stateStack = ArrayList<State> new()
    }

    setState: func (state: State) {
        previousState = _state
        if (debugFlag)
            fputs("ENTER STATE     : " + state name + "\n", debugStream)
        _state = state
    }

    getState: func () -> State {
        if (_state == null)
            StateUndefinedException new() throw()
        return _state
    }

    clearState: func () {
        _state = null
    }

    pushState: func (state: State) {
        assert(_state != null)
        if (_state == null)
            StateUndefinedException new() throw()
        previousState = _state
        if (debugFlag)
            fputs("PUSH TO STATE   : " + state name + "\n", debugStream)
        _stateStack add(_state)
        _state = state
    }

    popState: func () {
        if (_stateStack empty?()) {
            if (debugFlag)
                fputs("POPPING ON EMPTY STATE STACK.\n", debugStream)
            Exception new(This, "Trying to pop an empty stack.") throw()
        }
        previousState = _state
        _state = _stateStack removeAt(_stateStack lastIndex())
        if (debugFlag)
            fputs("POP TO STATE    : " + _state name + "\n", debugStream)
    }

    emptyStateStack: func () {
        _stateStack = ArrayList<State> new()
    }
}

