import "./token_stream" for TokenStream


var IMPORTS = []

class Module {
  construct new(code, path) {
    _code = code
    _path = path
    _stream = TokenStream.new(code)
  }
  code { _code }
  process() {
    IMPORTS.addAll(imports)
  }
  stream { _stream }
  imports {
    if (_imports != null ) return _imports
    _imports = []
    while (true) {
      var imp = _stream.seek { |t| t.type == "import" }
      if (imp == null) break

      _imports.add(Import.fromStream(_stream))
      _stream.advance()
    }
    return _imports
  }
}

import "./import" for Import