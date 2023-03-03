import 'dart:io';

import 'package:np_getx_generator/recase.dart';
import 'package:np_getx_generator/temp.dart';

Map createScreen(
    String name, String rootPath, String bindingSub, String controllerSub, String screenSub, String routeSub) {
  List<String> listFileCreatedExisted = [];
  List<String> listFileCreatedSuccess = [];
  List<String> listFileUpdatedSuccess = [];

  String fileBindingName = '$rootPath$bindingSub${name.toLowerCase()}_binding.dart';
  String fileControllerName = '$rootPath$controllerSub${name.toLowerCase()}_controller.dart';
  String fileScreenName = '$rootPath$screenSub${name.toLowerCase()}_screen.dart';

  String classBindingName = '${name.camelCase[0].toUpperCase()}${name.camelCase.substring(1)}Binding';
  String classControllerName = '${name.camelCase[0].toUpperCase()}${name.camelCase.substring(1)}Controller';
  String classScreenName = '${name.camelCase[0].toUpperCase()}${name.camelCase.substring(1)}Screen';

  final fileBinding = File(fileBindingName);
  if (!fileBinding.existsSync()) {
    fileBinding.createSync(recursive: true);
    String preSub = '';
    for (int i = 0; i < '/'.allMatches(bindingSub).length; i++) {
      preSub += '../';
    }
    fileBinding.writeAsStringSync(Temp.binding
        .replaceAll('{fileControllerPath}', '$preSub$controllerSub${name.toLowerCase()}_controller.dart')
        .replaceAll('{classBindingName}', classBindingName)
        .replaceAll('{classControllerName}', classControllerName));
    listFileCreatedSuccess.add(fileBindingName);
  } else {
    listFileCreatedExisted.add(fileBindingName);
  }

  final fileController = File(fileControllerName);
  if (!fileController.existsSync()) {
    fileController.createSync(recursive: true);
    fileController.writeAsStringSync(Temp.controller.replaceAll('{classControllerName}', classControllerName));
    listFileCreatedSuccess.add(fileControllerName);
  } else {
    listFileCreatedExisted.add(fileControllerName);
  }

  final fileScreen = File(fileScreenName);
  if (!fileScreen.existsSync()) {
    fileScreen.createSync(recursive: true);
    String preSub = '';
    for (int i = 0; i < '/'.allMatches(screenSub).length; i++) {
      preSub += '../';
    }
    fileScreen.writeAsStringSync(Temp.screen
        .replaceAll('{fileControllerPath}', '$preSub$controllerSub${name.toLowerCase()}_controller.dart')
        .replaceAll('{classScreenName}', classScreenName)
        .replaceAll('{classControllerName}', classControllerName));
    listFileCreatedSuccess.add(fileScreenName);

    if (routeSub.isNotEmpty) {
      String fileAppPageName = '$rootPath${routeSub}app_page.dart';
      String fileAppRouteName = '$rootPath${routeSub}app_route.dart';

      String preSubAppPage = '';
      for (int i = 0; i < '/'.allMatches(routeSub).length; i++) {
        preSubAppPage += '../';
      }
      final fileAppPage = File(fileAppPageName);
      if (!fileAppPage.existsSync()) {
        fileAppPage.createSync(recursive: true);
        fileAppPage.writeAsStringSync(Temp.appPage
            .replaceAll('{fileBindingPath}', '$preSubAppPage$bindingSub${name.toLowerCase()}_binding.dart')
            .replaceAll('{fileScreenPath}', '$preSubAppPage$screenSub${name.toLowerCase()}_screen.dart')
            .replaceAll('{nameCamelCase}', name.camelCase)
            .replaceAll('{classScreenName}', classScreenName)
            .replaceAll('{classBindingName}', classBindingName));
        listFileCreatedSuccess.add(fileAppPageName);
      } else {
        String contents = fileAppPage.readAsStringSync();
        if (contents.contains(']')) {
          contents =
              "import '$preSubAppPage$bindingSub${name.toLowerCase()}_binding.dart';\nimport '$preSubAppPage$screenSub${name.toLowerCase()}_screen.dart';\n${contents.replaceFirst(contents[contents.lastIndexOf(']')], "\tGetPage(name: AppRoute.${name.camelCase}Screen, page: () => const $classScreenName(), binding: $classBindingName()),\n\t]")}";
          fileAppPage.writeAsStringSync(contents);
          listFileUpdatedSuccess.add(fileAppPageName);
        }
      }

      final fileAppRoute = File(fileAppRouteName);
      if (!fileAppRoute.existsSync()) {
        fileAppRoute.createSync(recursive: true);
        fileAppRoute.writeAsStringSync(
            "class AppRoute {\n\tstatic const String ${name.camelCase}Screen = '/${name.camelCase}Screen';\n}\n");
        listFileCreatedSuccess.add(fileAppRouteName);
      } else {
        String contents = fileAppRoute.readAsStringSync();
        if (contents.contains('}')) {
          contents = contents.replaceFirst(contents[contents.lastIndexOf('}')],
              "\tstatic const String ${name.camelCase}Screen = '/${name.camelCase}Screen';\n}");
          fileAppRoute.writeAsStringSync(contents);
          listFileUpdatedSuccess.add(fileAppRouteName);
        }
      }
    }
  } else {
    listFileCreatedExisted.add(fileScreenName);
  }

  return {
    'listFileCreatedExisted': listFileCreatedExisted,
    'listFileCreatedSuccess': listFileCreatedSuccess,
    'listFileUpdatedSuccess': listFileUpdatedSuccess,
  };
}
