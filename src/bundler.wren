import "./module" for Module
import "./lib/buffer" for Buffer
import "./lib/export_map" for ExportMap

var EXPORT_MAP = ExportMap.new()
var MODULES_ADDED = []

class Bundler {
  construct new(module) {
    _module = module
    _buffer = Buffer.new()
  }
  buffer { _buffer }
  intro(name) { "/* ========== import %(name) ========== */\n{\n" }
  outro(name) { "}\n/* ========== end import %(name) ========== */\n" }
  stream { _module.stream }
  writeExternalImport(import_) {
    if (!MODULES_ADDED.contains(import_.module)) {
      MODULES_ADDED.add(import_.module)
      buffer << intro(import_.name)
      buffer << Bundler.new(import_.module).code << "\n"
      // actual exports from our block to the global scope
      import_.classes.keys.each { |klass|
        buffer << EXPORT_MAP.name(import_.name, klass) << " = %(klass)\n"
      }
      buffer << outro(import_.name)
    }

    // hook up exports
    import_.classes.keys.each { |klass|
      buffer << "var %(import_.classes[klass]) = " << EXPORT_MAP.name(import_.name, klass) << "\n"
    }

    // System.print("STREAMING")
    // System.print("imp %(imp)")
    // System.print("stream %(stream.all[50..-1])")
    // System.print("stream %(stream.cursor)")
    // skip until we find the line end
    while(stream.peek().type != "line") {
        // System.print(stream.peek())
        if (stream.atEnd) break
        stream.advance()
    }
  }
  writeImport(import_) {
    if (!import_.isExternal) {
      buffer << "import"
      return
    }
    writeExternalImport(import_)
  }
  code {
    // System.print(("start: %(_module.path)"))
    var i = 0
    var peek
    stream.rewind()
    while (!stream.atEnd) {
      peek = stream.peek()
      if (peek.type == "import") {
        // System.print(("found import at %(stream.cursor)"))
        var import_ = _module.imports[i]
        i = i + 1
        writeImport(import_)
      } else {
        buffer << peek.text
      }
      stream.advance()
    }
    // System.print(("done: %(_module.path)"))
    return buffer.toString
  }
}