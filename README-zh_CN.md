# sm_get_cli

## 文档支持语言

| [pt_BR](README-pt_BR.md) | [en_US](README.md) | zh_CN - 本文件 |
| --- | --- | --- |

社区维护的 GetX™ CLI fork，用于快速构建 Flutter 和 Server 应用。上游项目为 [`jonataslaw/get_cli`](https://github.com/jonataslaw/get_cli)；本 fork 的公开差异汇总如下。

## 安装

推荐从 pub.dev 安装已发布版本：

```shell
dart pub global activate sm_get_cli
```

请确保 pub cache 的 `bin` 目录已经加入 `PATH`。包会同时安装 `get` 和 `getx` 两个命令：

```shell
get --version
getx --version
```

开发版本也支持从 Git 或本地路径激活：

```shell
dart pub global activate --source git https://github.com/sm-packages/sm_get_cli.git
dart pub global activate --source path .
```

从 `get_cli` 迁移时，继续使用原有的 `get`/`getx` 命令、`get_cli:` 配置键和 `.get_cli.yaml` 文件；只有 Dart 包名和激活名称改为 `sm_get_cli`。

## Fork 能力索引

| 能力 | 用户契约 |
| --- | --- |
| 独立包与兼容命令 | 以 `sm_get_cli` 发布；保留 `get`、`getx`、`get_cli:` 和 `.get_cli.yaml`。所有支持的激活来源都能显示包版本。 |
| 可配置 GetX 包前缀 | `get_package_prefix: sm_getx` 生成 `package:sm_getx/get.dart`；可指定任意兼容的 GetX 包，默认仍为 `get`。 |
| State 生成与 GetX 4/5 输出 | `get create state` 和 `use_state` 可生成并接入 state；`version` 控制兼容的 binding 代码。 |
| 项目自定义模板 | 可用显式模板路径或 `.template` 目录替换 page、controller、binding、state 和插入片段。 |
| 可配置多语言生成 | 输入和输出可配置，也可由命令参数覆盖；文件名和类名通过配置设置。 |
| 嵌套路由生成 | `get create page:name on parent` 会添加子路由，并避免重复路由、页面和 import。 |
| 安全创建 Flutter 项目 | 使用当前 Flutter 支持的 Android 语言参数，安全处理含空格路径；创建失败会停止后续初始化。 |
| 可靠的失败状态 | CLI 已处理的失败仍会留下非零进程退出码，供脚本和 CI 判断。 |
| 当前 Dart/Flutter 工具链兼容 | fork 适配当前格式化与进程 API，同时保持生成代码契约。 |

## Fork 配置

以下配置可以放在 `pubspec.yaml` 的 `get_cli:` 下，或直接放在 `.get_cli.yaml` 顶层。如果两处同时配置，以 `pubspec.yaml` 的 `get_cli:` 为准。

```yaml
get_cli:
  # 默认按 GetX 4 语义生成。
  version: 5
  # 默认为 false；创建 page、screen 或 controller 时同时生成 state。
  use_state: true
  # 默认为 get；填写 GetX fork 的包名。
  get_package_prefix: sm_getx
  templates:
    # 按文件名发现当前目录下的 *.template 文件，不递归子目录。
    path: assets/templates
    # 显式键优先于目录自动发现。
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

`version` 默认值为 `4`，`use_state` 默认值为 `false`。也可以运行 `get create state:session on home` 单独创建 state，并将它接入匹配的 controller。模板未配置 `page` 时会回退到 `view`；没有有效自定义模板时使用内置模板。

`get_package_prefix` 默认值为 `get`。将它设为任意兼容的 GetX fork 包名（例如 `sm_getx`）后，内置 Flutter 生成器和自定义模板的 `@{import}` 变量会生成 `import 'package:sm_getx/get.dart';`。配置值必须是合法的小写 Dart 包名；非法值会以配置错误终止命令。项目必须已经依赖配置的包；此配置不会添加、删除或修改依赖。Get Server 项目仍生成 `package:get_server/get_server.dart`。

多语言生成只读取 JSON 文件。显式 `-i` 和 `-o` 参数优先于配置；默认输入目录是 `assets/locales`，默认生成文件是 `locales.g.dart`，默认翻译类是 `AppTranslation`：

```shell
get generate locales -i translations -o lib/gen
```

键名会原样作为 Dart 字段名输出，因此应只使用合法且非保留字的 Dart 标识符，例如 `welcome_message`。非法 JSON 会使生成失败；当前键名校验会拒绝首位数字、空白和部分特殊字符，但不会规范化或完整校验 Dart 标识符。

## 运行与兼容契约

- 重复生成顶层或嵌套 page 时，不得重复写入路由常量、`GetPage`、子路由或 import。
- Flutter 项目创建支持 Android 的 Kotlin 或 Java。不会再传递 Flutter 已移除的 iOS language 参数；`flutter create` 非零退出时会停止后续初始化。
- CLI 捕获并记录异常后仍返回非零进程状态。自动化脚本可将退出码 `0` 视为成功，非零视为失败。
- 工具链兼容是自动的。项目只需满足 `pubspec.yaml` 的 SDK 约束，不需要额外配置。

## 命令速查

```shell
// 在当前目录创建一个 Flutter 项目:
// 注: 默认使用文件夹名称作为项目名称
// 你可以使用 `get create project:my_project` 给项目命名
// 如果项目名称有空格则使用 `get create project:"my cool project"`
get create project

// 在现有项目中生成所选结构:
get init

// 创建page:
// (页面包括 controller, view, 和 binding)
// 注: 你可以随便命名, 例如: `get create page:login`
// 注: 选择了 Getx_pattern 结构才用这个选项
get create page:home

// 创建 Screen:
// (Screens 有 controller, view, 和 binding)
// 注: 你可以随便命名，例如: `get screen page:login`
// 注: 选择了 CLEAN 结构才用这个选项 (by Arktekko)
get create screen:home

// 在指定文件夹创建新 controller:
// 注: 你无需引用文件夹, Getx 会自动搜索 home 目录,
// 并把你的controller放在那儿
get create controller:dialogcontroller on home

// 创建 state 并接入匹配的 controller:
get create state:session on home

// 在指定文件夹创建新 view:
// 注: 你无需引用文件夹,Getx 会自动搜索 home 目录,
// 并把你的 view 放在那儿
get create view:dialogview on home

// 在指定文件夹创建新 provider:
get create provider:user on home

// 生成国际化文件:
// 注: 你在 'assets/locales' 目录下的翻译文件应该是json格式的
get generate locales assets/locales

// 生成 model 类:
// 注: 'assets/models/' 目录下的模板文件应该是json格式的
// 注: on  == 输出文件夹
// Getx 会自动搜索 home 目录,
// 并把你的 model 放在那儿
get generate model on home with assets/models/user.json

//生成无 provider 的 model
get generate model on home with assets/models/user.json --skipProvider

//注: URL 必须返回json
get generate model on home from "https://api.github.com/users/CpdnCristiano"

// 为你的项目安装依赖:
get install camera

// 为你的项目安装多个依赖:
get install http path camera

// 为你的项目安装依赖(指定版本号):
get install path:1.6.4

// 你可以为多个依赖指定版本号

// 为你的项目安装一个dev依赖(dependencies_dev):
get install flutter_launcher_icons --dev

// 为你的项目移除一个依赖:
get remove http

// 为你的项目移除多个依赖:
get remove http path

// 更新 CLI:
get update
// 或 `get upgrade`

// 显示当前 CLI 版本:
get -v
// 或 `get --version`

// 帮助
get help
// 或 `get -h`
```

## 探索 CLI

让我们看看 CLI 都有啥命令吧

### 新建项目

```shell
  get create project
```

用来新建一个项目, 你可以在 [Flutter](https://github.com/flutter/flutter) 和 [get_server](https://pub.dev/packages/get_server)里选一个, 创建默认目录之后, 它会运行一个 `get init`

### 初始化

```shell
  get init
```

这条命令要慎用，它会覆盖 lib 文件夹下所有内容。
它允许你在两种结构中二选一, [getx_pattern](https://kauemurakami.github.io/getx_pattern/) 和 [clean](https://github.com/Katekko/ekko_app).

### 创建 Page

```shell
  get create page:name
```

该命令允许您创建模块，建议选择使用 getx_pattern 的用户使用，

创建 view, controller 和 binding 文件, 此外还可以自动添加路由。

你可以在一个模块内创建另一个模块。

```shell
  get create page:name on other_module
```

当你创建一个项目，并且用 `on` 创建一个页面， CLI 会使用[children pages](https://github.com/jonataslaw/getx/blob/master/CHANGELOG.md#3210---big-update).

### 创建 Screen

```shell
  get create screen:name
```

和 `create page` 类似, 但更适合使用 Clean 的人。

### 创建 controller

```shell
  get create controller:dialog on your_folder
```

在指定目录创建 controller

_带选项使用_
你可以创建一个模板文件, 用你喜欢的方式

_运行_

```shell
  get create controller:auth with examples/authcontroller.dart on your_folder
```

或者使用 URL
_运行_

```shell
  get create controller:auth with 'https://raw.githubusercontent.com/sm-packages/sm_get_cli/master/samples_file/controller.dart.template' on your_folder
```

输入:

```dart
@{import}

class @{controller} extends GetxController {
  final  email = ''.obs;
  final  password = ''.obs;
  void login() {
  }

}
```

输出:

```dart
import 'package:get/get.dart';

class AuthController extends GetxController {
  final email = ''.obs;
  final password = ''.obs;
  void login() {}
}
```

### 创建 view

```shell
  get create view:dialog on your_folder
```

在指定目录创建 view

### 生成国际化文件

在 assets/locales 目录创建 json 格式的语言文件

输入:

zh_CN.json

```json
{
  "buttons": {
    "login": "登录",
    "sign_in": "注册",
    "logout": "注销",
    "sign_in_fb": "用 Facebook 登录",
    "sign_in_google": "用 Google 登录",
    "sign_in_apple": "用 Apple 登录"
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

运行 :

```dart
get generate locales assets/locales
```

输出:

```dart
abstract class AppTranslation {

  static Map<String, Map<String, String>> translations = {
    'en_US' : Locales.en_US,
    'zh_CN' : Locales.zh_CN,
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
  static const zh_CN = {
   'buttons_login': 'Entrar',
   'buttons_sign_in': 'Cadastrar-se',
   'buttons_logout': 'Sair',
   'buttons_sign_in_fb': '用 Facebook 登录',
   'buttons_sign_in_google': '用 Google 登录',
   'buttons_sign_in_apple': '用 Apple 登录',
  };

}

```

现在只需要在 GetMaterialApp 中加入

```dart

    GetMaterialApp(
      ...
      translationsKeys: AppTranslation.translations,
      ...
    )
```

### 例：生成 model

创建json model 文件assets/models/user.json

输入:

```json
{
  "name": "",
  "age": 0,
  "friends": ["", ""]
}
```

运行:

```dart
get generate model on home with assets/models/user.json
```

输出:

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

### 拆分不同类型文件

有一天有个用户问我，是否可能修改一下最终文件名，他发现 `my_controller_name.controller.dart` 比 CLI 生成的默认文件 `my_controller_name_controller. dart` 更具有可读性，考虑到像他这样的用户，我加了个选项，可以让你选择你自己的分隔符，只需要在你的 pubsepc.yaml 或 `.get_cli.yaml` 里这样写

例子:

```yaml
get_cli:
  separator: "."
```

### 配置 Getx 路径样式

当你创建一个 Page 或 Screen 时，每个模块都会有 binding , controller, view 子目录。

如果你更想要一个平级文件结构，添加以下内容到你的`pubspec.yaml` 或 `.get_cli.yaml`:

```yml
get_cli:
    sub_folder: false
```

### 所有示例

可以在 `pubspec.yaml` 或 `.get_cli.yaml` 中配置。

如果在 `.get_cli.yaml` 中，则移除 `get_cli:`。

```yml
get_cli:
    # get 版本
    version: 5
    # 文件名分隔符
    separator: .
    # 是否生成子文件夹
    sub_folder: false
    # 使用自定义模板
    templates:
      path: assets/templates
      # page 和 view 等同
      # page: assets/templates/page_template.dart
      # controller: assets/templates/controller_template.dart
      # binding: assets/templates/binding_template.dart
    locales:
      input: translations
      output: lib/gen
    use_state: true
```

### 你的 import 乱不乱?

为了帮你管理你的 import 我加了个新命令: `get sort`, 除了帮你排序整理 import, 这条命令还帮你格式化 dart 文件。感谢 [dart_style](https://pub.dev/packages/dart_style).
 `get sort` 会用 [separator](#拆分不同类型文件) 重命名所有文件。
如果不想重命名文件，使用 `--skipRename` 。

如果你喜欢用相对路径写 import, 使用 `--relative` 选项. sm_get_cli 会自动转换。

### cli 国际化

CLI 现在有一套国际化系统。

如果你想把 CLI 翻译成你的语言:

1. 在 [tranlations](/translations) 目录创建一个你语言对应的json文件
2. 从 [file](/translations/en.json) 复制所有key, 然后翻译成你的语言
3. 发送你的 PR.

TODO:

- 自定义 model 支持
- 单元测试
- 优化生成结构
- 增加备份系统
