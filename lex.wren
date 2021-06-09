import "repl" for Lexer, Token
import "io" for File
import "os" for Process
import "./src/module" for Module, IMPORTS
import "./src/buffer" for Buffer
import "./src/export_cache" for ExportCache

var NAME_CACHE = ExportCache.new()

class Bundler {
  construct new(module) {
    _module = module
    _buffer = Buffer.new()
  }
  buffer { _buffer }
  intro { "{\n" }
  outro { "\n}\n"}
  writeImport(buffer) {
    var stream = _module.stream
    var name = stream.peek(2).text.replace("\"","")
    var imp = _module.imports.where {|x| x.name == name }.toList[0]
    if (imp.isExternal) {
      buffer << "// import %(name)\n"
      // prepare exports
      // imp.classes.keys.each { |klass|
      //   buffer << "var " << CACHE.name(imp.name, klass) << "\n"
      // }
      buffer << "{\n"
      buffer << Bundler.new(imp.module).code << "\n"
      // actual exports
      imp.classes.keys.each { |klass|
        buffer << NAME_CACHE.name(imp.name, klass) << " = %(klass)\n"
      }
      buffer << "}\n"
      // hook up exports
      imp.classes.keys.each { |klass|
        buffer << "var %(imp.classes[klass]) = " << NAME_CACHE.name(imp.name, klass) << "\n"
      }

      // skip until we find the line end
      while(stream.peek().type != "line") stream.advance()
      // buffer << imp.toString
    } else {
      buffer << "import"
    }
  }
  code {
    var peek
    _module.stream.rewind()
    // buffer << intro
    while (peek = _module.stream.peek()) {
      if (peek.type == "import") {
        writeImport(buffer)
      } else {
        buffer << peek.text
      }
      _module.stream.advance()
    }
    // buffer << _module.stream.all.map {|x| x.text}.join("")
    // buffer << outro
    return buffer.toString
  }
}

var path = Process.arguments[0]
var code = File.read(path)
var module = Module.new(code, path)
module.process()

var bundled = Bundler.new(module).code
var out = Buffer.new()
out << "// BEGIN exports\n"
NAME_CACHE.variables.each { |v| out << "var %(v)\n" }
out << "// END exports\n\n"
out << bundled

System.print(out)
// System.print(code)

// System.print(module.imports)


