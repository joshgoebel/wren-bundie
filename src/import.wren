import "io" for File
import "cli" for Path
import "./module" for Module

class Import {
  construct new(name) {
    _name = name
    _classes = {}
    _external = null
    _module = null

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
  parseImportStatement(s) {
    if (s.peek().type != "for") return
    s.advance(2)

    while (true) {
      var klass = s.peek().text
      var as_ = klass
      s.advance(2)
      if (s.peek().text == "as") {
        as_ = s.peek(2)
        s.advance(3)
      }
      _classes[klass] = as_
      s.advanceThru(["whitespace","comma","comment"])
      if (s.peek().type == "line") break
    }
  }
  static fromStream(s) {
    s.advance(2)
    var importName = s.peek().text.replace("\"","")
    var result = Import.new(importName)
    if (s.peek(2).type == "for") {
      s.advance(2)
      result.parseImportStatement(s)
    }
    return result
  }
  toString {
    return [_name, _classes].toString
  }
}
