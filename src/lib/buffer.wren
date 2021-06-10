class Buffer {
    construct new(s) { _buffer = s }
    construct new() { _buffer = "" }
    add(s) {
        _buffer = _buffer + s
        return this
    }
    <<(s) { add(s) }
    toString { _buffer }
}