# sm_get_cli Fork 维护契约

本文面向仓库维护者和 AI 编码代理，记录 `sm_get_cli` 相对官方
[`jonataslaw/get_cli`](https://github.com/jonataslaw/get_cli) 当前仍然生效、且经过确认的有意差异。
它不是提交清单，也不把格式化、示例快照或生成文件噪声当作 fork 能力。

## 维护规则

- 只记录当前仍然生效的有意差异。新增、修改或删除 fork 行为时，必须在同一提交更新对应条目。
- 上游已经提供等价行为和等价回归覆盖后，删除对应的 `等待上游吸收` 条目及本地实现。
- `长期保留` 表示 fork 的产品、发布或兼容性契约；除非维护策略改变，否则上游合并不能覆盖它。
- 解决冲突时以本文件列出的行为不变量为准，不能按“文件归上游或 fork 所有”或仅凭同名字段判断。
- 提交锚点用于追溯意图，不代替阅读当前代码、测试和上游实现。
- 仓库完整维护英文 `README.md`、简体中文 `README-zh_CN.md` 和巴西葡萄牙文 `README-pt_BR.md`。面向用户的能力必须在同一提交同步三种语言的入口、能力索引和详细说明；跨语言链接不能代替翻译。
- `FORK.md` 是维护者和 AI 编码代理的上游合并契约；`CHANGELOG.md` 记录当前未发布或已发布的用户可见影响。公开能力变化必须在同一提交同步代码、回归测试、三份 README、`FORK.md` 和 `CHANGELOG.md`。
- 根目录 `AGENTS.md` 负责要求任务在完成有意 fork 行为变更或上游合并前运行 `$fork-doc`，并复用本文件中仍有证据支持的决策。

## 精确上游基线

- Fork 分支：`master`
- 上游远端及默认分支：`upstream/master`
- 最新已合并上游的 merge commit：`24e1165a8fb81edfc62e12e69def018c28d068a6`
- 该 merge commit 的上游父提交：`300c65b9acb0b5725d0bb1f7a5064907d7cdf0f6`
- 本文审计范围：`300c65b9acb0b5725d0bb1f7a5064907d7cdf0f6..HEAD`

上述提交范围只覆盖已提交历史。执行后续审计时，仍须将 staged、unstaged 和 untracked 变化作为独立证据检查。

`upstream/master` 是移动引用，不是本文基线。本文编写时它恰好仍指向
`300c65b9acb0b5725d0bb1f7a5064907d7cdf0f6`，且没有待合并的上游提交；以后即使该引用前进，
也必须先完成一次新的上游合并，再用新 merge commit 的上游父提交更新本文基线。

## Fork 能力

### 1. 独立包、仓库与兼容协议

- **生命周期：** `长期保留`
- **原始意图：** 以 `sm-packages/sm_get_cli` 独立维护和发布 GetX CLI。`1.9.1-fork.1` 已发布到 pub.dev，并由同名 annotated tag 标记；pub.dev hosted 安装是标准用户渠道，Git 和 path 安装是受支持的显式开发渠道。
- **必须保持的不变量：** Dart 包名、仓库地址、package import、版本查询、更新检查和安装目标统一使用 `sm_get_cli`；命令名继续为 `get` 和 `getx`；用户项目配置继续使用 `get_cli:` 和 `.get_cli.yaml`；`lib/get_cli.dart` 继续兼容性重导出 `lib/sm_get_cli.dart`。`get --version` 和 `getx --version` 必须在 hosted、Git 和 path 全局激活后都显示包自身 `pubspec.yaml` 的版本，不能依赖快照与 activation lockfile 的相对目录布局。发布版本使用上游 `pubspec.yaml` 的版本作为基线并追加 `-fork.N`：上游版本变化时从 `fork.1` 开始，同一上游基线上的后续本地发布递增 `N`。pub.dev 尚未发布或暂时返回 404 时，自动更新检查必须安全跳过，不能因空版本崩溃。
- **当前代码和测试路径：** `pubspec.yaml`、`bin/get.dart`、`lib/sm_get_cli.dart`、`lib/get_cli.dart`、`lib/common/utils/pubspec/package_version.dart`、保留旧导入兼容的 `lib/common/utils/pubspec/pubspec_lock.dart`、`lib/common/utils/pub_dev/pub_dev_api.dart`、`lib/common/utils/shell/shel.utils.dart`、`lib/functions/version/version_update.dart`、`test/common/utils/pubspec/package_version_test.dart`、`integration_test/package_version_activation_test.dart`。版本解析有单元回归，path 与本地 Git 激活有隔离的双命令集成测试；hosted 候选仍须在发布后验收。
- **用户文档：** `README.md` 的 “Installation”、“Fork capability index” 和 “Runtime and compatibility contracts”；`README-zh_CN.md` 的“安装”、“Fork 能力索引”和“运行与兼容契约”；`README-pt_BR.md` 的 “Instalação”、“Índice de recursos do fork” 和 “Contratos de execução e compatibilidade”。
- **来源提交：** `b422403a9ad11ccf156fc23046fc3c2fcf65c1b0`、`8eca1a5c84e07552c9ada14d5b1d55c76ee0d119`。前者的中间仓库地址已经被后者的最终地址取代。版本定位修复使用 `git log -S'Isolate.resolvePackageUri' -- lib/common/utils/pubspec/package_version.dart` 定位来源提交。
- **合并审查：** 把包名、入口、两个 executable、pub.dev 查询、Git 更新 URL 和文档安装命令作为一个原子迁移面审查；先解决源码和模板，再重新生成派生输出。禁止只接受上游的 `get_cli` 包名而保留部分 `sm_get_cli` URL，反之亦然。
- **移除条件：** 只有在明确放弃独立 fork 身份或整体迁回官方包时才移除；这不是等待普通上游代码吸收的条目。
- **验证：** 运行 `dart analyze`、`dart test`、`dart test integration_test/package_version_activation_test.dart`、`dart pub publish --dry-run`；集成测试使用隔离的 `PUB_CACHE` 验证 path 和本地 Git 快照的 `get --version` 与 `getx --version`。发布后设置 `SM_GET_CLI_HOSTED_VERSION=<version>` 重跑同一集成测试，验收 hosted 包的两个命令。再搜索残留的运行时代码引用：`rg "package:get_cli|sm-packages/get_cli" bin lib pubspec.yaml`。

### 2. 状态生成与 GetX 4/5 生成语义

- **生命周期：** `长期保留`
- **原始意图：** 增加 `get create state`，允许 page、screen 和 controller 按 `use_state` 自动生成并接入 state；按配置的 GetX 主版本生成相应依赖绑定代码。
- **必须保持的不变量：** `use_state` 只在启用时生成 state；独立 state 命令能定位匹配 controller 并以防重复方式插入 import 和成员；`version: 5` 生成 `Bind.lazyPut` 返回列表语义，GetX 4 保持 `Get.lazyPut`/`void` 语义；未配置版本时当前兼容回退值仍为 4；文件分隔符配置不能破坏 state 接入。
- **当前代码和测试路径：** `lib/commands/impl/create/create.dart`、`lib/commands/impl/create/state/state.dart`、`lib/commands/impl/create/page/page.dart`、`lib/commands/impl/create/screen/screen.dart`、`lib/commands/impl/create/controller/controller.dart`、`lib/functions/controller/add_states.dart`、`lib/functions/controller/find_controllers.dart`、`lib/functions/binding/add_dependencies.dart`、`lib/common/utils/pubspec/pubspec_utils_extension.dart`、`lib/samples/impl/get_state.dart`、`lib/samples/impl/get_binding.dart`、`example/.get_cli.yaml`。目前没有针对该能力的自动化测试。
- **用户文档：** 三种维护语言 README 的能力索引、fork 配置段和命令速查段：`README.md`、`README-zh_CN.md`、`README-pt_BR.md`。
- **来源提交：** `9a3fedb872021b37b6be205505717be03e9b18dc`、`2d86acc790d7be73436d1e4a58734da9b4d6c87f`、`525df122a1f9defec9fc686a7a7c00bb9c354172`、`757701ad9a196dc52dae97dbf5559c6b047b9bdd`。
- **合并审查：** 将命令注册、state 模板、controller 插入、binding 插入、目录结构和配置读取作为一个能力审查。不能只保留命令入口而丢失注入逻辑，也不能把示例中的 `version: 5` 误认为运行时代码的默认值。
- **移除条件：** 只有产品明确取消 state 生成或 GetX 多版本生成策略时才移除；需要同步删除命令、模板、辅助函数、翻译键和本文条目。
- **验证：** 在一次性示例项目中分别使用 GetX 4 和 `version: 5`，启用 `use_state` 后运行 page、controller 和 state 创建命令，检查 state 文件、controller import/成员及 binding 形态；重复运行时不得重复插入。当前测试缺口必须在修改该能力时补齐或明确接受。

### 3. 可配置代码模板

- **生命周期：** `长期保留`
- **原始意图：** 允许项目通过 `get_cli.templates` 或 `.get_cli.yaml` 替换 page/view、controller、binding、state 及插入片段，并从 `templates.path` 自动发现 `.template` 文件。
- **必须保持的不变量：** 显式模板键优先；目录自动发现按文件名映射模板；`page` 缺失时可以回退到 `view`；`insert_state` 和 `insert_controller` 分别参与已有文件的增量修改；没有有效自定义模板时使用内置 sample。
- **当前代码和测试路径：** `lib/common/utils/pubspec/pubspec_utils_templates.dart`、`lib/commands/impl/create/page/page.dart`、`lib/commands/impl/create/screen/screen.dart`、`lib/commands/impl/create/controller/controller.dart`、`lib/commands/impl/create/view/view.dart`、`lib/commands/impl/create/state/state.dart`、`lib/functions/controller/add_states.dart`、`lib/functions/binding/add_dependencies.dart`、`lib/functions/replace_vars/replace_vars.dart`、`samples_file/`、`example/.get_cli.yaml`。目前没有针对模板解析和生成结果的自动化测试。
- **用户文档：** 三种维护语言 README 的能力索引与 fork 配置段：`README.md`、`README-zh_CN.md`、`README-pt_BR.md`；三份 README 的 controller 指南同时给出远程模板示例。
- **来源提交：** `3a4761a445de58c9783b92aaddc6ddb256fcfa18`、`9a3fedb872021b37b6be205505717be03e9b18dc`、`757701ad9a196dc52dae97dbf5559c6b047b9bdd`。
- **合并审查：** 同时检查配置解析、模板载入、变量替换和各生成命令的消费路径；不能因为上游修改内置 sample 就覆盖自定义模板优先级。
- **移除条件：** 只有明确取消项目级模板扩展点时才移除；删除时要同步移除配置文档和 `samples_file/` 中专用于该协议的模板。
- **验证：** 在一次性项目中同时测试显式模板路径和 `templates.path` 自动发现，生成 page、controller、binding、state，并验证自定义标记及变量替换结果；重复插入不得产生重复内容。当前没有自动回归覆盖。

### 4. 配置化多语言生成

- **生命周期：** `长期保留`
- **原始意图：** 让 `get generate locales` 从命令参数或项目配置读取输入、输出、文件名和类名，并支持嵌套 JSON 翻译结构。
- **必须保持的不变量：** `-i`/`-o` 显式参数优先于配置，配置优先于默认路径；只读取输入目录中的 JSON；嵌套键稳定展平；非法 JSON 必须失败；键名会原样生成 Dart 字段，因此用户输入必须是合法且非保留字的 Dart 标识符，不能把当前有限的字符拒绝逻辑描述为完整标识符校验；输出文件名和类名配置继续生效。
- **当前代码和测试路径：** `.get_cli.yaml`、`example/.get_cli.yaml`、`lib/common/utils/pubspec/pubspec_utils_extension.dart`、`lib/commands/impl/generate/locales/locales.dart`、`lib/samples/impl/generate_locales.dart`、`translations/`。目前没有针对配置优先级或生成结果的自动化测试。
- **用户文档：** 三种维护语言 README 的能力索引、fork 配置段和 locale 生成指南：`README.md`、`README-zh_CN.md`、`README-pt_BR.md`。
- **来源提交：** `ce6152bb94d6a74cfb46b06301fbb08b92fd8c4d`、`4556ac41f018bac0e9f77514e314f1123b460e47`、`757701ad9a196dc52dae97dbf5559c6b047b9bdd`。
- **合并审查：** 保留命令参数、`.get_cli.yaml` 和 `pubspec.yaml` 中 `get_cli:` 的兼容读取；生成文件冲突应从 `translations/` 及配置重新生成，不能手工拼接。
- **移除条件：** 只有明确取消配置化 locale 生成时才移除；不能仅因上游也有基础 locale 命令就删除，必须先验证参数优先级、嵌套键和自定义输出等价。
- **验证：** 在临时输出目录分别验证默认配置和 `-i`/`-o` 覆盖，检查自定义文件名、类名、嵌套键、引号和换行转义；再以非法 JSON，以及当前校验明确拒绝的首位数字、空白或特殊字符键验证失败路径。另以 Dart 保留字或含句点的键确认已知校验边界，不能把生成命令成功误判为输出源码有效。当前没有自动回归覆盖。

### 5. 嵌套页面路由与幂等去重

- **生命周期：** `等待上游吸收`
- **原始意图：** 修复 `app/modules` 下嵌套 page 的路由定位，并避免重复生成 `_Paths`、`Routes`、`GetPage` 和 import。
- **必须保持的不变量：** page 既能加入顶层 routes，也能加入父页面的 `children`；路径计算忽略约定的 `lib/app`、`modules` 前缀；同一 page 重复生成不会重复声明路由、页面或 import；没有 `children` 时能创建，已有时能追加。
- **当前代码和测试路径：** `lib/commands/impl/create/page/page.dart`、`lib/functions/routes/get_add_route.dart`、`lib/functions/routes/get_app_pages.dart`、`lib/functions/routes/get_support_children.dart`、`lib/extensions/dart_code.dart`、`example/lib/app/routes/app_pages.dart`、`example/lib/app/routes/app_routes.dart`。目前没有针对嵌套路由和去重的自动化测试。
- **用户文档：** 三种维护语言 README 的能力索引、运行契约和 page 创建指南：`README.md`、`README-zh_CN.md`、`README-pt_BR.md`。
- **来源提交：** `e2d26039591b88ac3bb3932d44562ff0d72e65d2`、`3f9d98ec475dd6c9be4bb11cbe2d8869c5725f92`；相关结构重构为 `757701ad9a196dc52dae97dbf5559c6b047b9bdd`。
- **合并审查：** 用生成结果比较顶层和嵌套两条路径，不要只比较函数名或单个正则；上游路由模型变化时优先移植幂等不变量，而不是强保留当前文本插入实现。
- **吸收条件：** 上游对顶层与嵌套 page 都提供等价路径处理、声明/import 去重及回归覆盖后，删除本地差异和本条目。
- **验证：** 在一次性 GetX 项目中创建顶层 page 和 `on` 父模块的嵌套 page，各重复执行一次，检查 routes/pages/import 每项仅出现一次且 child 位于正确父页面。当前没有自动回归覆盖。

### 6. Flutter 项目创建的参数与失败契约

- **生命周期：** `等待上游吸收`
- **原始意图：** 兼容当前 Flutter CLI：保留 Android Java/Kotlin 选择，移除失效的 iOS language 选择，以结构化参数处理含空格路径，并阻止失败的 `flutter create` 被当成成功。
- **必须保持的不变量：** 调用参数依次包含 `create`、`--no-pub`、`--android-language`、所选语言、`--org`、组织名和目标路径；参数不能通过 shell 字符串拼接；非零 `ProcessResult.exitCode` 必须抛出包含 stderr 和原始错误码的 `ProcessException`；不能重新加入失效的 `--ios-language`。
- **当前代码和测试路径：** `lib/commands/impl/create/project/project.dart`、`lib/common/utils/shell/shel.utils.dart`、`test/common/utils/shell/shell_utils_test.dart`。
- **用户文档：** 三种维护语言 README 的能力索引、运行契约和项目创建指南：`README.md`、`README-zh_CN.md`、`README-pt_BR.md`。
- **来源提交和合并解决：** `24e1165a8fb81edfc62e12e69def018c28d068a6` 在 `lib/common/utils/shell/shel.utils.dart` 有非空手工 remerge diff；`224920f078e89ad1d0c7066a690f007df1ed257c` 补齐结构化调用、非零失败传播和测试。
- **合并审查：** 上游再次修改 `flutter create` 参数时，先用当前安装的 `flutter create --help` 和实际临时项目验证；按受支持行为重建参数，不机械保留旧 flag。必须同时审查参数安全和失败传播。
- **吸收条件：** 上游使用当前 Flutter 支持的等价参数、对含空格路径安全，并在子进程非零时停止且有等价测试后，删除本地差异和本条目。
- **验证：** 运行 `dart test test/common/utils/shell/shell_utils_test.dart`；Flutter 升级或合并涉及该路径时，再运行 `flutter create --help` 和一次临时目录 smoke test。

### 7. CLI 已处理异常仍返回失败状态

- **生命周期：** `等待上游吸收`
- **原始意图：** 让脚本和 CI 能识别 CLI 失败，修复异常被记录后进程反而以 0 退出的问题。
- **必须保持的不变量：** `ExceptionHandler.handle` 处理任何异常时留下非零进程状态；不能用立即 `exit(0)` 截断日志或掩盖失败；正常命令仍返回 0；行为跨平台一致。
- **当前代码和测试路径：** `bin/get.dart`、`lib/exception_handler/exception_handler.dart`、`test/exception_handler/exception_handler_test.dart`、`test/fixtures/exception_handler_main.dart`。
- **用户文档：** 三种维护语言 README 的能力索引与运行契约：`README.md`、`README-zh_CN.md`、`README-pt_BR.md`。
- **来源提交：** `1a4cf23110ccf2081551b69f0ad92399ef1251f4`。
- **合并审查：** 沿 `bin/get.dart` 到 exception handler 检查完整失败路径，不能以“捕获了异常”推断退出状态正确；修改 handler 时保留子进程级测试。
- **吸收条件：** 上游所有已处理异常均以非零状态结束，并具有等价的跨进程回归测试后，删除本地差异和本条目。
- **验证：** 运行 `dart test test/exception_handler/exception_handler_test.dart`；扩展异常类型时增加相应 fixture 或 subprocess case，不能只做进程内断言。

### 8. Dart/Flutter 工具链兼容层

- **生命周期：** `等待上游吸收`
- **原始意图：** 适配较新的 Flutter/Dart 工具链和依赖主版本，同时按目标项目 SDK 约束选择 `dart_style` 的格式化语言版本。
- **必须保持的不变量：** SDK 约束兼容读取 `sdkConstraint` 和 `sdk` 两种表示；生成模型和格式化文件时按目标项目是否支持 Dart 3.7 tall style 选择语言版本；`dart_style 3`、`dcli 7`、`process_run 1.2` 及相关 API 用法保持一致；依赖升级不能悄悄改变生成代码语义。
- **当前代码和测试路径：** `pubspec.yaml`、`lib/common/utils/pubspec/pubspec_utils.dart`、`lib/common/utils/json_serialize/model_generator.dart`、`lib/functions/formatter_dart_file/frommatter_dart_file.dart`、`lib/functions/create/create_single_file.dart`。目前没有直接覆盖 SDK 约束回退、两种 formatter language version 或依赖 API 兼容性的自动化测试。
- **用户文档：** 三种维护语言 README 的能力索引与运行兼容契约：`README.md`、`README-zh_CN.md`、`README-pt_BR.md`。该能力无需用户额外配置。
- **来源提交和合并解决：** `d3fd528e3505269642a48224e78376b62ee271a5` 在 `pubspec.yaml` 有非空手工 remerge diff，选择了 `process_run 1.2` 并引入 `yaml_edit`；`70224b517edf4a3b60ab03123426b843c9b3e72d`、`56a080a81f590b9d8bf42c14d956acfdcd4378a7` 完成 SDK 约束回退及 `dart_style 3`、`dcli 7` 适配。
- **合并审查：** 区分真正的 API/输出兼容改动与大范围 formatter/JSON AST 文本噪声；依赖约束、API 调用和生成输出必须一起验证。不要仅因上游版本号更高就删除本地兼容逻辑。
- **吸收条件：** 上游支持相同或更新的工具链，SDK 约束读取和两类格式化输出等价，并有足够回归覆盖后，删除本地兼容差异和本条目。
- **验证：** 运行 `dart analyze`、`dart test`、`dart pub publish --dry-run`；用 SDK 约束分别低于和不低于 Dart 3.7 的两个临时 pubspec 比较生成/格式化结果。当前 formatter 分支仍缺少自动测试。

## 上游合并清单

1. 确认工作区、当前分支、worktree 和 remotes；先保存精确状态，不覆盖未提交工作。
2. 从当前分支 first-parent 历史定位最新上游 merge commit，检查两个父提交，确认哪一个是上游父提交。
3. 用该上游父提交作为 fork 审计基线；将移动的 `upstream/master` 仅视为下一次待合并候选。
4. 分别审查 `长期保留` 与 `等待上游吸收`：前者按不变量保留，后者逐项确认上游是否已提供等价行为和测试。
5. 对有手工冲突解决的 merge commit 使用 `git show --remerge-diff`；重点重验 Flutter 参数支持、结构化调用和失败传播。
6. 冲突解决以本文件的不变量为准。源码、模板和翻译源先解决；生成输出从对应源定义重新生成，不手工拼接生成文件。
7. 运行与被触及能力对应的针对性测试，再运行 `dart analyze`、`dart test`、格式检查及需要的 CLI smoke；发布面变化时额外运行 `dart pub publish --dry-run`。
8. 合并完成后，用新 merge commit 及其上游父提交更新“精确上游基线”，重新审计能力，并在同一提交同步代码、测试、`FORK.md`；公开能力还要同步三种维护语言的 README 入口、索引、详细说明和 `CHANGELOG.md`。

## 明确排除项与已知风险

- `example/` 是示例/生成快照，不作为独立 fork 能力；`example/lib/gen/locales.g.dart`、`example/lib/generated/locales.g.dart`、`example/lib/output/locales.g.dart` 是重复生成输出。
- `lib/core/locales.g.dart` 是 `translations/` 的生成结果。翻译源可能属于能力实现，但生成文件本身不构成独立能力。
- JSON AST、model generator、README 和多语言文件中的纯格式化改动不作为独立能力；只保留第 8 项列出的实际工具链语义。
- 已被 `8eca1a5c84e07552c9ada14d5b1d55c76ee0d119` 修正的 `sm-packages/get_cli` 中间 URL 不代表当前政策。
- `test/path/test.dart` 改名为可发现的 `test/path/replace_to_relative_test.dart` 属于测试基础设施修正，不是独立 fork 产品能力。
- 本文编写时没有未合并的 `upstream/master` 提交；以后出现的上游专属行为在实际合并前不能列为 fork 能力。
- 三份 README 的远程 controller 模板链接均指向现存的 `samples_file/controller.dart.template`；旧的 `.example` 缺陷已不再是当前风险。
- 当前 `[Unreleased]` 版本定位修复尚未包含在已发布的 `1.9.1-fork.1` 中；下次发布必须按同一上游基线递增 `fork.N`，并在发布验证成功后创建匹配的 annotated tag。
