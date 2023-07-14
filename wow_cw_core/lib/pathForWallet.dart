import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> pathForWalletDir({required String name}) async {
  final Directory root = await applicationRootDirectory();

  final prefix = "wownero";
  final walletsDir = Directory('${root.path}/wallets');
  final walletDire = Directory('${walletsDir.path}/$prefix/$name');

  if (!walletDire.existsSync()) {
    walletDire.createSync(recursive: true);
  }

  return walletDire.path;
}

Future<String> pathForWallet({required String name}) async =>
    await pathForWalletDir(name: name).then((path) => path + '/$name');

Future<String> outdatedAndroidPathForWalletDir({String? name}) async {
  final Directory directory = await applicationRootDirectory();

  final pathDir = directory.path + '/$name';

  return pathDir;
}

Future<Directory> applicationRootDirectory() async {
  Directory appDirectory;

// todo: can merge and do same as regular linux home dir?
  if (bool.fromEnvironment("IS_ARM")) {
    appDirectory = await getApplicationDocumentsDirectory();
    appDirectory = Directory("${appDirectory.path}/.stackwallet");
  } else if (Platform.isLinux) {
    appDirectory = Directory("${Platform.environment['HOME']}/.stackwallet");
  } else if (Platform.isWindows) {
// TODO: windows root .stackwallet dir location
    throw Exception("Unsupported platform");
  } else if (Platform.isMacOS) {
// currently run in ipad mode??
    throw Exception("Unsupported platform");
  } else if (Platform.isIOS) {
// todo: check if we need different behaviour here
    if (await isDesktop()) {
      appDirectory = await getLibraryDirectory();
    } else {
      appDirectory = await getLibraryDirectory();
    }
  } else if (Platform.isAndroid) {
    appDirectory = await getApplicationDocumentsDirectory();
  } else {
    throw Exception("Unsupported platform");
  }
  if (!appDirectory.existsSync()) {
    await appDirectory.create(recursive: true);
  }
  return appDirectory;
}

Future<bool> isDesktop() async {
  if (Platform.isIOS) {
    final Directory libraryPath = await getLibraryDirectory();
    if (!libraryPath.path.contains("/var/mobile/")) {
      return true;
    }
  }

  return Platform.isLinux || Platform.isMacOS || Platform.isWindows;
}
