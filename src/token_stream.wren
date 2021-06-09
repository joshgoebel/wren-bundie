import "repl" for Lexer, Token

class TokenStream {
  construct new(code) {
    _code = code
    _tokens = []
    _cursor = 0
    lex()
  }
  all { _tokens }
  rewind() { _cursor = 0 }
  atEnd { _cursor >= _tokens.count }
  peek() {
    if (atEnd) return null
    return _tokens[_cursor]
  }
  peek(n) {
    if (_cursor+n >= _tokens.count) return null
    return _tokens[_cursor+n]
  }
  advance() { advance(1) }
  advance(n) { _cursor = _cursor + n }
  seek(fn) {
    while(!atEnd) {
      System.print("hi")
      if (fn.call(peek())) {
        return peek()
      }
      advance()
    }
  }
  lex() {
    var l = Lexer.new(_code)
    while (true) {
      var t = l.readToken()
      if (t.type == Token.eof) return
      _tokens.add(t)
      // System.print("%(t.type): %(t.text) ")
    }
  }
}
