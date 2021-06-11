#!/usr/bin/env wrenc
import "io" for File
import "os" for Process
import "../src/module" for Module
import "../src/lib/buffer" for Buffer
import "../src/bundler" for Bundler, EXPORT_MAP
import "cli" for Path

// we do not support absolute paths
var root = Path.new(".")
var path = root.join(Process.arguments[0])
var module = Module.new(path)

var bundled = Bundler.new(module).code
var out = Buffer.new()
out << "// BEGIN exports\n"
EXPORT_MAP.variables.each { |v| out << "var %(v)\n" }
out << "// END exports\n\n"
out << bundled

System.print(out)
// System.print(code)

// System.print(module.imports)


