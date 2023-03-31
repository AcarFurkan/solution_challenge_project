enum HttpClients { nutrition }

extension HttpClientExtension on HttpClients {
  String get client => ("${name}_uri").toUpperCase();
}
