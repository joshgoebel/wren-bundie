import "./token_stream" for TokenStream

var MODULES = {}
var IMPORTS = []

// TODO: normalize paths

class Module {
  static findOrNew(code, path) {
    // System.print("findOrNew: %(path)")
    if (MODULES.containsKey(path)) return MODULES[path]
    MODULES[path] = Module.new(code,path)
    return MODULES[path]
  }
  construct new(code, path) {
    _code = code
    _path = path
    _stream = TokenStream.new(code)
    parse()
  }
  path { _path }
  code { _code }
  stream { _stream }
  imports { _imports }
  parse() {
    stream.rewind()
    _imports = []
    while (true) {
      var imp = _stream.seek { |t| t.type == "import" }
      if (imp == null) break

      _imports.add(Import.fromStream(_stream))
      _stream.advance()
    }
    // System.print(("imports end"))
    stream.rewind()
  }
}

import "./import" for Import