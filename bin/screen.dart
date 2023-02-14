import 'dart:io';

import 'package:args/args.dart';
import 'package:np_getx_generator/constant.dart';
import 'package:np_getx_generator/create_screen.dart';

void main(List<String> args) {
  final parser = ArgParser();

  parser.addOption('name');
  parser.addOption('multi');
  parser.addOption('rootPath', abbr: 'r');
  parser.addOption('bindingSub', abbr: 'b');
  parser.addOption('controllerSub', abbr: 'c');
  parser.addOption('screenSub', abbr: 's');
  parser.addFlag('withRoute', abbr: 'w');
  parser.addOption('routeSub', abbr: 'x');

  ArgResults parsedArgs;
  try {
    parsedArgs = parser.parse(args);
  } catch (e) {
    print('❌  $e');
    return;
  }

  // name must snake case (eg: login_test_abc) for best practice
  String name = (parsedArgs['name'] ?? '').toString().trim();
  // multi file name
  String multi = (parsedArgs['multi'] ?? '').toString().trim();
  // default path lib/app/
  String rootPath =
      ((parsedArgs['rootPath'] ?? '').toString().isEmpty ? Constant.defaultRootPath : parsedArgs['rootPath'])
          .toString()
          .trim();
  // default binding/
  String bindingSub =
      ((parsedArgs['bindingSub'] ?? '').toString().isEmpty ? Constant.defaultBindingSub : parsedArgs['bindingSub'])
          .toString()
          .trim();
  // default controller/
  String controllerSub = ((parsedArgs['controllerSub'] ?? '').toString().isEmpty
          ? Constant.defaultControllerSub
          : parsedArgs['controllerSub'])
      .toString()
      .trim();
  // default ui/screen/
  String screenSub =
      ((parsedArgs['screenSub'] ?? '').toString().isEmpty ? Constant.defaultScreenSub : parsedArgs['screenSub'])
          .toString()
          .trim();

  // define route sub directory (optional)
  bool withRoute = parsedArgs['withRoute'] ?? false;
  String routeSub =
      ((parsedArgs['routeSub'] ?? '').toString().isEmpty ? Constant.defaultRouteSub : parsedArgs['routeSub'])
          .toString()
          .trim();

  if (name.isEmpty && multi.isEmpty) {
    print('❌  Please enter file name by: --name <name> or --multi <name1,name2,...>');
    return;
  }

  if (name.isNotEmpty && multi.isNotEmpty) {
    print('❌  Use only --name <name> OR --multi <name1,name2,...>');
    return;
  }

  List<String> listName = [];

  if (name.isNotEmpty) {
    listName.add(name);
  } else if (multi.isNotEmpty) {
    List<String> ln = multi.split(',');
    if (ln.isEmpty) {
      listName.add(multi);
    } else {
      listName = [...ln];
    }
  }

  if (rootPath[rootPath.length - 1] != '/' ||
      bindingSub[bindingSub.length - 1] != '/' ||
      controllerSub[controllerSub.length - 1] != '/' ||
      screenSub[screenSub.length - 1] != '/') {
    print('❌  paths and subs must end with "/"');
    return;
  }

  // create directories
  Directory directoryRoot = Directory(rootPath);
  if (!directoryRoot.existsSync()) {
    directoryRoot.createSync(recursive: true);
  }

  Directory directoryBinding = Directory('$rootPath$bindingSub');
  if (!directoryBinding.existsSync()) {
    directoryBinding.createSync(recursive: true);
  }

  Directory directoryController = Directory('$rootPath$controllerSub');
  if (!directoryController.existsSync()) {
    directoryController.createSync(recursive: true);
  }

  Directory directoryScreen = Directory('$rootPath$screenSub');
  if (!directoryScreen.existsSync()) {
    directoryScreen.createSync(recursive: true);
  }

  if (withRoute) {
    Directory directoryRoute = Directory('$rootPath$routeSub');
    if (!directoryRoute.existsSync()) {
      directoryRoute.createSync(recursive: true);
    }
    if (!directoryRoute.existsSync()) {
      print('❌  Cannot create directory $rootPath$routeSub');
      return;
    }
  }

  if (!directoryBinding.existsSync() || !directoryController.existsSync() || !directoryController.existsSync()) {
    print('❌  Cannot create directories');
    return;
  }

  List<String> listFileCreatedExisted = [];
  List<String> listFileCreatedSuccess = [];
  for (var name in listName) {
    if (name.trim().isNotEmpty) {
      Map result = createScreen(name.trim(), rootPath, bindingSub, controllerSub, screenSub, withRoute ? routeSub : '');
      listFileCreatedExisted.addAll(result['listFileCreatedExisted'] ?? []);
      listFileCreatedSuccess.addAll(result['listFileCreatedSuccess'] ?? []);
    }
  }
  print('❌  Number of file creation failed (already existing) ${listFileCreatedExisted.length}');
  for (var element in listFileCreatedExisted) {
    print('   ❗  $element');
  }

  print('✅ Number of files successfully created ${listFileCreatedSuccess.length}');
  for (var element in listFileCreatedSuccess) {
    print('   🚀  $element');
  }
}
