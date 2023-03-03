class Temp {
  static const binding =
      "import 'package:get/get.dart';\n\nimport '{fileControllerPath}';\n\nclass {classBindingName} extends Bindings {\n\t@override\n\tvoid dependencies() {\n\t\tGet.put({classControllerName}());\n\t}\n}\n";
  static const controller = "import 'package:get/get.dart';\n\nclass {classControllerName} extends GetxController {}\n";
  static const screen =
      "import 'package:flutter/widgets.dart';\nimport 'package:get/get.dart';\nimport '{fileControllerPath}';\n\nclass {classScreenName} extends GetView<{classControllerName}> {\n\tconst {classScreenName}({Key? key}) : super(key: key);\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn const Placeholder();\n\t}\n}\n";
  static const appPage =
      "import '{fileBindingPath}';\nimport '{fileScreenPath}';\nimport 'package:get/get.dart';\nimport 'app_route.dart';\n\nclass AppPage {\n\tstatic final pages = [\n\t\tGetPage(name: AppRoute.{nameCamelCase}Screen, page: () => const {classScreenName}(), binding: {classBindingName}()),\n\t];\n}\n";
}
