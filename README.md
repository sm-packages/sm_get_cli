# sm_get_cli

## Documentation languages

| [pt_BR](README-pt_BR.md) | en_US - this file | [zh_CN](README-zh_CN.md) |
| --- | --- | --- |

A community-maintained fork of the GetX™ CLI for building Flutter and Server applications. The upstream project is [`jonataslaw/get_cli`](https://github.com/jonataslaw/get_cli); fork-specific behavior is summarized below.

## Installation

Install the published package from pub.dev:

```shell
dart pub global activate sm_get_cli
```

Ensure the pub cache `bin` directory is on `PATH`. The package installs both `get` and `getx` executables:

```shell
get --version
getx --version
```

Git and local path activation are supported for development builds:

```shell
dart pub global activate --source git https://github.com/sm-packages/sm_get_cli.git
dart pub global activate --source path .
```

When migrating from `get_cli`, keep the existing `get`/`getx` commands, `get_cli:` configuration key, and `.get_cli.yaml` file. Only the Dart package and activation name change to `sm_get_cli`.

## Fork capability index

| Capability | User contract |
| --- | --- |
| Independent package and compatible commands | Published as `sm_get_cli`; keeps `get`, `getx`, `get_cli:`, and `.get_cli.yaml`. All supported activation sources report the package version. |
| Configurable GetX import target | `use_sm_getx: true` generates `package:sm_getx/get.dart`; the default remains `package:get/get.dart`. |
| State generation and GetX 4/5 output | `get create state` and `use_state` generate and connect state files; `version` selects compatible binding output. |
| Project-defined templates | Explicit template files or a `.template` directory can replace page, controller, binding, state, and insertion templates. |
| Configurable locale generation | Input and output can be configured or overridden with command flags; file name and class name are set through configuration. |
| Nested route generation | `get create page:name on parent` adds child routes and avoids duplicate routes, pages, and imports. |
| Safe Flutter project creation | Current Flutter Android language options and paths containing spaces are passed as structured arguments; failed creation stops initialization. |
| Reliable failure status | Handled CLI failures leave a nonzero process exit code for scripts and CI. |
| Current Dart and Flutter compatibility | The fork tracks current Dart formatting and process APIs without changing the generated-code contract. |

## Fork configuration

Place these keys under `get_cli:` in `pubspec.yaml`, or at the top level of `.get_cli.yaml`. When both files define fork settings, the `pubspec.yaml` `get_cli:` map takes precedence.

```yaml
get_cli:
  # Defaults to GetX 4 generation behavior.
  version: 5
  # Defaults to false. Page, screen, and controller generation also creates state.
  use_state: true
  # Defaults to false. Generate imports for the sm_getx fork.
  use_sm_getx: true
  templates:
    # Discovers non-recursive *.template files by filename.
    path: assets/templates
    # Explicit keys take precedence over discovered files.
    # page: assets/templates/page.dart.template
    # controller: assets/templates/controller.dart.template
    # binding: assets/templates/binding.dart.template
    # state: assets/templates/state.dart.template
    # insert_state: assets/templates/insert_state.dart.template
    # insert_controller: assets/templates/insert_controller.dart.template
  locales:
    input: translations
    output: lib/gen
    file_name: locales
    class_name: AppTranslation
```

`version` defaults to `4`, and `use_state` defaults to `false`. Run `get create state:session on home` to create a state explicitly and connect it to a matching controller. For templates, `page` falls back to `view`, and missing custom templates fall back to the built-in samples.

`use_sm_getx` defaults to `false`. When it is `true`, built-in Flutter generators and the `@{import}` custom-template variable emit `import 'package:sm_getx/get.dart';` instead of `package:get/get.dart`. The project must already depend on `sm_getx`; this setting does not add, remove, or change dependencies. Get Server projects continue to import `package:get_server/get_server.dart`.

Locale generation reads only JSON files. Explicit `-i` and `-o` arguments override configuration; the default input is `assets/locales`, the default generated filename is `locales.g.dart`, and the default translation class is `AppTranslation`:

```shell
get generate locales -i translations -o lib/gen
```

Translation keys are emitted verbatim as Dart field names, so use valid, non-keyword Dart identifiers such as `welcome_message`. Invalid JSON fails generation. The current key validator rejects leading digits, whitespace, and several special characters, but it does not normalize or fully validate Dart identifiers.

## Runtime and compatibility contracts

- Repeating top-level or nested page generation must not duplicate route constants, `GetPage` entries, child routes, or imports.
- Flutter project creation supports Kotlin or Java for Android. The removed Flutter iOS-language option is not passed, and a nonzero `flutter create` result stops the remaining initialization.
- Caught CLI exceptions leave a nonzero process exit code. Automation may treat exit code `0` as success and any nonzero code as failure.
- Toolchain compatibility is automatic. Projects only need to satisfy the SDK constraint in `pubspec.yaml`; no separate compatibility setting is required.

## Command quick reference

```shell
// To create a flutter project in the current directory:
// Note: By default it will take the folder's name as project name
// You can name the project with `get create project:my_project`
// If the name has spaces use `get create project:"my cool project"`
get create project

// To generate the chosen structure on an existing project:
get init

// To create a page:
// (Pages have controller, view, and binding)
// Note: you can use any name, ex: `get create page:login`
// Nota: use this option if the chosen structure was Getx_pattern
get create page:home

// To create a screen
// (Screens have controller, view, and binding)
// Note: you can use any name, ex: `get screen page:login`
// Nota: use this option if the chosen structure was CLEAN (by Arktekko)
get create screen:home

// To create a new controller in a specific folder:
// Note: you don't need to reference the folder,
// Getx will search automatically for the home folder
// and add your controller there.
get create controller:dialogcontroller on home

// To create a state and connect it to a matching controller:
get create state:session on home

// To create a new view in a specific folder:
// Note: you don't need to reference the folder,
// Getx will automatically search for the home folder
// and insert your view there.
get create view:dialogview on home

// To create a new provider in a specific folder:
get create provider:user on home

// To generate a localization file:
// Note: 'assets/locales' directory with your translation files in json format
get generate locales assets/locales

// To generate a class model:
// Note: 'assets/models/user.json' path of your template file in json format
// Note: on  == folder output file
// Getx will automatically search for the home folder
// and insert your class model there.
get generate model on home with assets/models/user.json

//to generate the model without the provider
get generate model on home with assets/models/user.json --skipProvider

//Note: the URL must return a json format
get generate model on home from "https://api.github.com/users/CpdnCristiano"

// To install a package in your project (dependencies):
get install camera

// To install several packages from your project:
get install http path camera

// To install a package with specific version:
get install path:1.6.4

// You can also specify several packages with version numbers

// To install a dev package in your project (dependencies_dev):
get install flutter_launcher_icons --dev

// To remove a package from your project:
get remove http

// To remove several packages from your project:
get remove http path

// To update CLI:
get update
// or `get upgrade`

// Shows the current CLI version:
get -v
// or `get --version`

// For help
get help
```

## Exploring the CLI

let's explore the existing commands in the cli

### Create project

```shell
  get create project
```

Using to generate a new project, you can choose between [Flutter](https://github.com/flutter/flutter) and [get_server](https://pub.dev/packages/get_server), after creating the default directory, it will run a `get init` next command

### Init

```shell
  get init
```

Use this command with care it will overwrite all files in the lib folder.
It allows you to choose between two structures, [getx_pattern](https://kauemurakami.github.io/getx_pattern/) and [clean](https://github.com/Katekko/ekko_app).

### Create page

```shell
  get create page:name
```

this command allows you to create modules, it is recommended for users who chose to use getx_pattern.

creates the view, controller and binding files, in addition to automatically adding the route.

You can create a module within another module.

```shell
  get create page:name on other_module
```

When creating a new project now and use `on` to create a page the CLI will use [children pages](https://github.com/jonataslaw/getx/blob/master/CHANGELOG.md#3210---big-update).

### Create Screen

```shell
  get create screen:name
```

similar to the `create page`, but suitable for those who use Clean

### Create controller

```shell
  get create controller:dialog on your_folder
```

create a controller in a specific folder.

_Using with option_
You can now create a template file, the way you prefer.

_run_

```shell
  get create controller:auth with examples/authcontroller.dart on your_folder
```

or with url
_run_

```shell
  get create controller:auth with 'https://raw.githubusercontent.com/sm-packages/sm_get_cli/master/samples_file/controller.dart.template' on your_folder
```

input:

```dart
@{import}

class @{controller} extends GetxController {
  final  email = ''.obs;
  final  password = ''.obs;
  void login() {
  }

}
```

output:

```dart
import 'package:get/get.dart';

class AuthController extends GetxController {
  final email = ''.obs;
  final password = ''.obs;
  void login() {}
}
```

### Create view

```shell
  get create view:dialog on your_folder
```

create a view in a specific folder

### Generate Locates

create the json language files in the assets/locales folder.

input:

pt_BR.json

```json
{
  "buttons": {
    "login": "Entrar",
    "sign_in": "Cadastrar-se",
    "logout": "Sair",
    "sign_in_fb": "Entrar com o Facebook",
    "sign_in_google": "Entrar com o Google",
    "sign_in_apple": "Entrar com a  Apple"
  }
}
```

en_US.json

```json
{
  "buttons": {
    "login": "Login",
    "sign_in": "Sign-in",
    "logout": "Logout",
    "sign_in_fb": "Sign-in with Facebook",
    "sign_in_google": "Sign-in with Google",
    "sign_in_apple": "Sign-in with Apple"
  }
}
```

Run :

```dart
get generate locales assets/locales
```

output:

```dart
abstract class AppTranslation {

  static Map<String, Map<String, String>> translations = {
    'en_US' : Locales.en_US,
    'pt_BR' : Locales.pt_BR,
  };

}
abstract class LocaleKeys {
  static const buttons_login = 'buttons_login';
  static const buttons_sign_in = 'buttons_sign_in';
  static const buttons_logout = 'buttons_logout';
  static const buttons_sign_in_fb = 'buttons_sign_in_fb';
  static const buttons_sign_in_google = 'buttons_sign_in_google';
  static const buttons_sign_in_apple = 'buttons_sign_in_apple';
}

abstract class Locales {

  static const en_US = {
   'buttons_login': 'Login',
   'buttons_sign_in': 'Sign-in',
   'buttons_logout': 'Logout',
   'buttons_sign_in_fb': 'Sign-in with Facebook',
   'buttons_sign_in_google': 'Sign-in with Google',
   'buttons_sign_in_apple': 'Sign-in with Apple',
  };
  static const pt_BR = {
   'buttons_login': 'Entrar',
   'buttons_sign_in': 'Cadastrar-se',
   'buttons_logout': 'Sair',
   'buttons_sign_in_fb': 'Entrar com o Facebook',
   'buttons_sign_in_google': 'Entrar com o Google',
   'buttons_sign_in_apple': 'Entrar com a  Apple',
  };

}

```

now just add the line in GetMaterialApp

```dart

    GetMaterialApp(
      ...
      translationsKeys: AppTranslation.translations,
      ...
    )
```

### Generate model example

Create the json model file in the assets/models/user.json<br/>

input: <br/>

```json
{
  "name": "",
  "age": 0,
  "friends": ["", ""]
}
```

Run :

```dart
get generate model on home with assets/models/user.json
```

output:

```dart
class User {
  String name;
  int age;
  List<String> friends;

  User({this.name, this.age, this.friends});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    age = json['age'];
    friends = json['friends'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['age'] = this.age;
    data['friends'] = this.friends;
    return data;
  }
}

```

### Separator file type

One day a user asked me, if it was possible to change what the final name of the file was, he found it more readable to use: `my_controller_name.controller.dart`, instead of the default generated by the cli: `my_controller_name_controller. dart` thinking about users like him we added the option for you to choose your own separator, just add this information in your pubsepc.yaml

Example:

```yaml
get_cli:
  separator: "."
```

### Configure Getx directory layout

When you create a page or screen, each module will have bindings, controllers, views sub directories.

If you prefer to have a flat file hierarchy, add the following lines to your `pubspec.yaml`:

```yml
get_cli:
    sub_folder: false
```

### Are your imports disorganized?

To help you organize your imports a new command was created: `get sort`, in addition to organizing your imports the command will also format your dart file. thanks to [dart_style](https://pub.dev/packages/dart_style).
When using get sort all files are renamed, with the [separator](#separator-file-type).
To not rename use the `--skipRename` flag.

You are one of those who prefer to use relative imports instead of project imports, use the `--relative` option. sm_get_cli will convert.

### Internationalization of the cli

CLI now has an internationalization system.

to translate the cli into your language:

1. create a new json file with your language, in the [translations](/translations) folder
2. Copy the keys from the [file](/translations/en.json), and translate the values
3. send your PR.

TODO:

- Support for customModels
- Include unit tests
- Improve generated structure
- Add a backup system
