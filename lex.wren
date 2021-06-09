import "io" for File
import "os" for Process
import "./src/module" for Module
import "./src/buffer" for Buffer
import "./src/bundler" for Bundler, NAME_CACHE


var path = Process.arguments[0]
var code = File.read(path)
var module = Module.new(code, path)

var bundled = Bundler.new(module).code
var out = Buffer.new()
out << "// BEGIN exports\n"
NAME_CACHE.variables.each { |v| out << "var %(v)\n" }
out << "// END exports\n\n"
out << bundled

System.print(out)
// System.print(code)

// System.print(module.imports)


