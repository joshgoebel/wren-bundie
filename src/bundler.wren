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
  intro { "{\n" }
  outro { "\n}\n"}
  stream { _module.stream }
  writeImport(buffer) {
    var imp = _module.imports[_i]
    _i = _i + 1
    if (!imp.isExternal) {
      buffer << "import"
      return
    }
    if (!MODULES_ADDED.contains(imp.module)) {
      MODULES_ADDED.add(imp.module)
      buffer << "// import %(imp.name)\n"
      buffer << "{\n"
      buffer << Bundler.new(imp.module).code << "\n"
      // actual exports from our block to the global space
      imp.classes.keys.each { |klass|
        buffer << EXPORT_MAP.name(imp.name, klass) << " = %(klass)\n"
      }
      buffer << "}\n"
    }

    // hook up exports
    imp.classes.keys.each { |klass|
      buffer << "var %(imp.classes[klass]) = " << EXPORT_MAP.name(imp.name, klass) << "\n"
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
  code {
    // System.print(("start: %(_module.path)"))
    _i = 0
    var peek
    stream.rewind()
    // buffer << intro
    while (!stream.atEnd) {
      peek = stream.peek()
      if (peek.type == "import") {
        // System.print(("found import at %(stream.cursor)"))
        writeImport(buffer)
      } else {
        buffer << peek.text
      }
      stream.advance()
    }
    // System.print(("done: %(_module.path)"))
    // buffer << outro
    return buffer.toString
  }
}