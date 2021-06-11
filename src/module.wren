import "io" for File
import "./lib/token_stream" for TokenStream

var MODULES = {}

class Module {
  static findOrNew(path) {
    path = path.toString
    // System.print("findOrNew: %(path)")
    if (MODULES.containsKey(path)) return MODULES[path]
    MODULES[path] = Module.new(path)
    return MODULES[path]
  }
  construct new(path) {
    _code = File.read(path.toString)
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

      _imports.add(Import.fromStream(_stream, { "relativeTo": this }))
      _stream.advance()
    }
    // System.print(("imports end"))
  }
}

import "./import" for Import