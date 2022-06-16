import 'package:collection/collection.dart';
import 'package:path/path.dart';

@Deprecated("This class has been superseded by NoteImage")
class SavedImage {
  final String id;
  final StorageLocation storageLocation;
  final String? hash;
  final String? blurHash;
  final String? fileExtension;
  final bool encrypted;
  final double? width;
  final double? height;
  final bool uploaded;

  String getPath(String baseDir) => join(baseDir, "$id$fileExtension");

  @Deprecated("This class has been superseded by NoteImage")
  const SavedImage({
    required this.id,
    this.storageLocation = StorageLocation.local,
    this.hash,
    this.fileExtension,
    this.encrypted = false,
    this.width,
    this.height,
    this.uploaded = false,
    this.blurHash,
  });

  @Deprecated("This class has been superseded by NoteImage")
  factory SavedImage.fromJson(Map<String, dynamic> json) {
    return SavedImage(
      id: json['id'] as String,
      storageLocation: StorageLocation.values.firstWhereOrNull(
            (e) => e.name == json['storageLocation'],
          ) ??
          StorageLocation.local,
      hash: json['hash'] as String?,
      fileExtension: json['fileExtension'] as String?,
      encrypted: json['encrypted'] as bool,
      width: (json['width'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      blurHash: json['blurHash'] as String?,
      uploaded: json['uploaded'] as bool,
    );
  }
}

enum StorageLocation { local, sync }
