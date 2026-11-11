import 'package:http/http.dart' as http;

import '../internal/api_transport.dart';
import '../internal/entry_parser.dart';
import '../internal/request_encoding.dart';
import '../models/media_item.dart';

/// Media upload and management (bytes-based, no `dart:io`).
class MediaResource {
  /// Creates [MediaResource].
  MediaResource(this._transport);

  final ApiTransport _transport;

  /// Uploads a media file from in-memory bytes.
  Future<MediaItem> upload({
    required List<int> bytes,
    required String filename,
    String? contentType,
  }) async {
    final envelope = await _transport.send(
      scope: 'media',
      method: 'upload',
      files: [
        http.MultipartFile.fromBytes(
          'File',
          bytes,
          filename: filename,
        ),
      ],
    );
    return MediaItem.fromJson(parseEntryObject(envelope.entries));
  }

  /// Lists uploaded media files.
  Future<MediaListResult> list({int? page, int? size}) async {
    final envelope = await _transport.send(
      scope: 'media',
      method: 'list',
      httpMethod: HttpMethod.get,
      fields: omitNull({
        'page': page?.toString(),
        'size': size?.toString(),
      }),
    );
    return MediaListResult.fromJson(parseEntryObject(envelope.entries));
  }

  /// Fetches one media item by id.
  Future<MediaItem> get(String id) async {
    final envelope = await _transport.send(
      scope: 'media',
      method: 'get',
      httpMethod: HttpMethod.get,
      fields: {'id': id},
    );
    return MediaItem.fromJson(parseEntryObject(envelope.entries));
  }

  /// Deletes a media file by id.
  Future<MediaDeleteResult> delete(String id) async {
    final envelope = await _transport.send(
      scope: 'media',
      method: 'delete',
      httpMethod: HttpMethod.delete,
      fields: {'id': id},
    );
    return MediaDeleteResult.fromJson(parseEntryObject(envelope.entries));
  }
}
