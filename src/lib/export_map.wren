class ExportMap {
  construct new() {
    _map = {}
    _id = 0
  }
  variables { _map.values }
  next() { _id = _id + 1}
  name(module,klass) {
    var key = "%(module)#%(klass)"
    if (_map.containsKey(key)) return _map[key]

    next()
    _map[key] = "%(klass)__export__%(_id)"

    return _map[key]
  }

}