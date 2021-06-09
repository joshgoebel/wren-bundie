import "repl" for Lexer, Token
import "io" for File
import "os" for Process
import "./src/module" for Module, IMPORTS
import "./src/buffer" for Buffer
import "./src/export_cache" for ExportCache

var path = Process.arguments[0]
var code = File.read(path)

var id = 0
var exports = {}

var exportFor = Fn.new { |im, key|
  if (exports["%(im.name)-%(key)"]) return exports["%(im.name)-%(key)"]
  id = id + 1
  var result = "%(key)%(id)_ex"
  exports["%(im.name)-%(key)"] = result
  return result
}

var module = Module.new(code, path)
module.process()
var out = ""
IMPORTS.each { |import_|
  import_.classes.keys.each { |key|
    out = out + "var %(exportFor.call(import_,key))\n"
  }
  out = out + "{\n"
  out = out + "// module: %(import_.name)\n"
  import_.classes.keys.each { |key|
    out = out + "%(exportFor.call(import_,key)) = %(key)\n"
  }
  out = out + "}\n"
}


var CACHE = ExportCache.new()

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
      imp.classes.keys.each { |klass|
        buffer << "var " << CACHE.name(imp.name, klass) << "\n"
      }
      buffer << "{\n"
      buffer << Bundler.new(imp.module).code << "\n"
      // actual exports
      imp.classes.keys.each { |klass|
        buffer << CACHE.name(imp.name, klass) << " = %(klass)\n"
      }
      buffer << "}\n"
      // hook up exports
      imp.classes.keys.each { |klass|
        buffer << "var %(klass) = " << CACHE.name(imp.name, klass) << "\n"
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

System.print(Bundler.new(module).code)
// System.print(code)

// System.print(module.imports)


