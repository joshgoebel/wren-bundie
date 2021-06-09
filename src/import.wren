import "io" for File
import "cli" for Path
import "./module" for Module

class Import {
  construct new(name) {
    _name = name
    _classes = {}
    _external = null
    _module = null
    _code = ""

    _path = "%(name).wren"
    if (_path[0] == ".") {
        _external = true
        var code = File.read(_path)
        _module = Module.findOrNew(code, _path)
    }
  }
  module { _module }
  isExternal { _external }
  name { _name }
  classes { _classes }
  parseStream(s) {
    if (s.peek().type != "for") return
    s.advance(2)

    while (s.peek().type != "line") {
      var klass = s.peek().text
      var as_ = klass
      s.advance(2)
      if (s.peek().text == "as") {
        s.advance(2)
        as_ = s.peek()
        s.advance()
      }
      _classes[klass] = as_
      while (s.peek().type == "whitespace" || s.peek().type == "comma" || s.peek().type == "comment") {
        s.advance()
      }
    }
  }
  static fromStream(s) {
    s.advance(2)
    var result = Import.new(s.peek().text.replace("\"",""))
    s.advance(2)
    result.parseStream(s)

    return result
  }
  toString {
    return [_name, _classes].toString
  }
}
