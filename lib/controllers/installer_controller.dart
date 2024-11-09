import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shell_cmd/shell_cmd.dart';
import 'package:tar/tar.dart';
import 'package:path/path.dart' as path;
import 'package:setup/config/installer_config.dart';

class InstallerController {
  String outputPath = InstallerConfig().defaultPath;
  bool isStarted = false;
  bool isFinished = false;
  double progress = 0.0;
  int processedBytes = 0;
  int totalBytes = 0;
  final VoidCallback updatePage;

  InstallerController({required this.updatePage});

  Future<void> unpack() async {
    if(isFinished)
    {
      exit(0);
    }

    if(isStarted)
    {
      return;
    }

    isStarted = true;
    isFinished = false;
    progress = 0.0;
    processedBytes = 0;
    totalBytes = 0;
    updatePage();

    String archivePath = "data/bundle.qam";

    final archiveFile = File(archivePath);
    final outputDirectory = Directory(path.normalize(outputPath));

    await _initUnpack(archiveFile, outputDirectory);
  }

  void changePath({required String path}) {
    outputPath = path;
  }

  Future<void> _initUnpack(File archive, Directory outputDir) async {
    final fixedOutputDir = Directory(path.normalize(outputDir.path));

    if (!await fixedOutputDir.exists()) {
      await fixedOutputDir.create(recursive: true);
    }

    late Stream<List<int>> inputStream;
    late TarReader tarReader;

    try
    {
      inputStream = archive.openRead();
      tarReader = TarReader(inputStream);
      totalBytes = await archive.length();
    }
    catch(e)
    {
      if (kDebugMode) {
        print("Cannot open file: $e");
      }
      _reset();
      return;
    }

    await _streamWriter(tarReader: tarReader, outputPath: fixedOutputDir.path);

    await _finish();
  }


  Future<void> _streamWriter({required TarReader tarReader, required String outputPath}) async {
    while (await tarReader.moveNext()) {
      final entry = tarReader.current;
      String outputFilePath = _pathBuilder(entry.name, outputPath);

      if(outputFilePath.isEmpty)
      {
        if (kDebugMode) {
          print("Invalid folder name: ${entry.name}");
        }
        continue;
      }

      final outputFile = File(path.normalize(outputFilePath));
      if (kDebugMode) {
        print(outputFile.path);
      }

      if (entry.header.typeFlag == TypeFlag.dir) {
       await _processDir(outputFilePath: outputFile.path);
      }
      else {
        await _processFile(outputFile: outputFile, entry: entry);
      }
    }
  }

  Future<void> _processDir({required String outputFilePath}) async
  {
    try
    {
      if(!Directory(outputFilePath).existsSync())
      {
        await Directory(outputFilePath).create(recursive: true);
      }
    }
    catch(e)
    {
      if (kDebugMode) {
        print("Cannot unpack with directory: $e");
      }
    }
  }

  Future<void> _processFile({required File outputFile, required TarEntry entry}) async
  {
    try
    {
      await outputFile.parent.create(recursive: true);
      IOSink writer = outputFile.openWrite();

      await writer.addStream(entry.contents).then((writer) {
        processedBytes += entry.header.size;
        progress = (processedBytes / totalBytes).toDouble() * 95;
        updatePage();
      });

      writer.close();

      if (kDebugMode) {
        print("Extracted file: ${outputFile.path}");
      }
    }
    catch(e)
    {
      processedBytes += entry.header.size;
      progress = (processedBytes / totalBytes).toDouble() * 95;
      updatePage();

      if (kDebugMode) {
        print("Cannot unpack file: $e");
      }
    }
  }

  String _pathBuilder(String file, String output)
  {

    String outputFilePath = "";

    if(file.startsWith("{content}"))
    {
      outputFilePath = file.replaceFirst("{content}", output);
    }

    if(file.startsWith("{hardcode}"))
    {
      outputFilePath = file.replaceFirst("{hardcode}", "C:").replaceAll("{user}", Platform.environment['USERNAME']!);
    }

    return outputFilePath;
  }

  Future<void> _executeCommands() async {
    List<String> commands = InstallerConfig().commands;

    for (String command in commands)
    {
      final cmd = ShellCmd(command);
      final result = await cmd.run(runInShell: true);
      if (kDebugMode) {
        print("Out: ${result.stdout}");
        print("Err: ${result.stderr}");
        print("ExitCode: ${result.exitCode}");
      }
    }
  }

  Future<void> _finish() async {
    await _executeCommands();
    isFinished = true;
    progress = 100.0;
    updatePage();
  }

  void _reset()
  {
    isStarted = false;
    isFinished = false;
    progress = 0.0;
    processedBytes = 0;
    totalBytes = 0;
    updatePage();
  }
}
