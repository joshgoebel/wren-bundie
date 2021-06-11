import "wren-package" for WrenPackage, Dependency
import "os" for Process

class Package is WrenPackage {
  construct new() {}
  name { "wren-bundie" }
  version { "0.1.0" }
  dependencies { [] }
}

Package.new().default()
