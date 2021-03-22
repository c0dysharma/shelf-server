import 'dart:io';

import 'package:args/args.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;

// For Google Cloud Run, set _hostname to '0.0.0.0'.
const _hostname = 'localhost';
const _port = 8080;
void main(List<String> args) async {
  final server = await io.serve(
      (request) => shelf.Response.ok('Hello, World\n'), _hostname, _port);
  print('Serving at http://${server.address.host}:${server.port}');

}
