import 'dart:async';

import 'package:http/http.dart' as http;

/// A streamed byte response for a (possibly resumed) download.
class ByteStreamResponse {
  const ByteStreamResponse({
    required this.statusCode,
    required this.stream,
    this.totalBytes,
    this.acceptsRanges = false,
  });

  final int statusCode;

  /// Full size of the resource in bytes, if the server reported it.
  final int? totalBytes;

  /// Whether the server supports range requests (resumable downloads).
  final bool acceptsRanges;

  /// The (remaining) bytes, streamed so progress can be reported.
  final Stream<List<int>> stream;

  bool get isOk => statusCode == 200 || statusCode == 206;
}

/// Transport for downloading a package archive. Behind an interface so the app
/// depends on the capability (streamed, resumable HTTPS GET) and tests use a
/// fake with no real network.
abstract class DownloadHttpClient {
  /// Opens a byte stream for [url], optionally resuming from [fromByte] via an
  /// HTTP Range request. Throws on network/timeout errors.
  Future<ByteStreamResponse> openStream(String url, {int fromByte = 0});
}

/// Real HTTPS download client (package:http). Only used for `https://` URLs; a
/// production build wires this in. Supports resume via the `Range` header.
class HttpDownloadClient implements DownloadHttpClient {
  HttpDownloadClient({http.Client? client, this.timeout = const Duration(seconds: 30)})
      : _client = client ?? http.Client();

  final http.Client _client;
  final Duration timeout;

  @override
  Future<ByteStreamResponse> openStream(String url, {int fromByte = 0}) async {
    final uri = Uri.parse(url);
    // Production content must come over HTTPS only — never plain HTTP.
    if (uri.scheme != 'https') {
      throw ArgumentError('Refusing non-HTTPS download URL: $url');
    }
    final request = http.Request('GET', uri);
    if (fromByte > 0) {
      request.headers['Range'] = 'bytes=$fromByte-';
    }
    final streamed = await _client.send(request).timeout(timeout);
    final acceptRanges =
        streamed.headers['accept-ranges']?.contains('bytes') ?? false;
    int? total = streamed.contentLength;
    if (fromByte > 0 && total != null) total += fromByte;
    return ByteStreamResponse(
      statusCode: streamed.statusCode,
      totalBytes: total,
      acceptsRanges: acceptRanges || streamed.statusCode == 206,
      stream: streamed.stream,
    );
  }
}
