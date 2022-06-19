import 'dart:io';

abstract class Directories {
  final Directory tempDirectory;
  final Directory supportDirectory;
  final Directory imagesDirectory;
  final Directory themesDirectory;
  final Directory backupDirectory;

  const Directories({
    required this.tempDirectory,
    required this.supportDirectory,
    required this.imagesDirectory,
    required this.themesDirectory,
    required this.backupDirectory,
  });
}
