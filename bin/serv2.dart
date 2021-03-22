import 'dart:io';

import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;

// For Google Cloud Run, set _hostname to '0.0.0.0'.
const _hostname = 'localhost';
const _port = 8080;

void main(List<String> args) async {
  // Cascades handlers
  final handlerCascade = shelf.Cascade().add((request) {
    if (request.url.path == 'a') {
      // if path matches exit cascade
      return shelf.Response.ok('handler a');
    }
    return shelf.Response.notFound('not found');
  }).add((request) {
    if (request.url.path == 'b') {
      // if path matches exit cascade
      return shelf.Response.ok('handler b');
    }
    return shelf.Response.notFound('not found');
  }).add((request) {
    if (request.url.path == 'c') {
      // if path matches exit cascade
      return shelf.Response.ok('handler c');
    }
    return shelf.Response.notFound('not found');
  }).add((request) {
    // if (request.headers['My-Custom-Header'] != null) {
    //   // if header exists exit cascade
    //   return shelf.Response.ok(request.headers['My-Custom-Header']);
    // }
    // if all else fails throw not found
    return shelf.Response.notFound('not found');
  }).handler;

  // Pipeline handlers
  final handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addMiddleware((innerHandler) => (request) async {
            final updatedRequest = request.change(
              headers: {'My-Custom-Header': 'custom header value'},
            );

            return await innerHandler(updatedRequest);
          })
      .addHandler(handlerCascade);

  // Create a shelf server 1
  final server = await io.serve(
    handler,
    _hostname,
    _port,
  );

  // Create a shelf server 2
  // final server = await HttpServer.bind(_hostname, _port);
  // final ioserver = await io.IOServer(server);
  // ioserver.mount((request) => shelf.Response.ok('Hello, Worlddd'));

  // Create a shelf server 3
  // final ioserver2 = await io.IOServer.bind(_hostname, _port);
  // ioserver2.mount((request) => shelf.Response.ok('Hello, Worlddd'));

  print('Serving at http://${server.address.host}:${server.port}');
}
