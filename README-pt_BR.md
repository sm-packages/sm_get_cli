# sm_get_cli

## Idiomas da documentação

| pt_BR - este arquivo | [en_US](README.md) | [zh_CN](README-zh_CN.md) |
| --- | --- | --- |

Um fork da CLI do GetX™ mantido pela comunidade para criar aplicações Flutter e Server. O projeto upstream é [`jonataslaw/get_cli`](https://github.com/jonataslaw/get_cli); as diferenças públicas deste fork estão resumidas abaixo.

## Instalação

Instale a versão publicada no pub.dev:

```shell
dart pub global activate sm_get_cli
```

Verifique se o diretório `bin` do pub cache está no `PATH`. O pacote instala os executáveis `get` e `getx`:

```shell
get --version
getx --version
```

Também é possível ativar versões de desenvolvimento pelo Git ou por um caminho local:

```shell
dart pub global activate --source git https://github.com/sm-packages/sm_get_cli.git
dart pub global activate --source path .
```

Ao migrar do `get_cli`, mantenha os comandos `get`/`getx`, a chave de configuração `get_cli:` e o arquivo `.get_cli.yaml`. Somente o nome do pacote Dart e da ativação muda para `sm_get_cli`.

## Índice de recursos do fork

| Recurso | Contrato para o usuário |
| --- | --- |
| Pacote independente e comandos compatíveis | Publicado como `sm_get_cli`; mantém `get`, `getx`, `get_cli:` e `.get_cli.yaml`. Todas as origens de ativação suportadas informam a versão do pacote. |
| Geração de state e saída para GetX 4/5 | `get create state` e `use_state` geram e conectam arquivos de state; `version` seleciona o código de binding compatível. |
| Templates definidos pelo projeto | Arquivos explícitos ou um diretório de `.template` podem substituir templates de page, controller, binding, state e trechos de inserção. |
| Geração de traduções configurável | Entrada e saída podem ser configuradas ou substituídas por parâmetros do comando; nome do arquivo e nome da classe são definidos pela configuração. |
| Geração de rotas aninhadas | `get create page:name on parent` adiciona rotas filhas sem duplicar rotas, pages ou imports. |
| Criação segura de projetos Flutter | Usa as opções atuais de linguagem Android e argumentos estruturados para caminhos com espaços; uma falha interrompe a inicialização. |
| Status de falha confiável | Falhas tratadas pela CLI mantêm um código de saída diferente de zero para scripts e CI. |
| Compatibilidade atual com Dart e Flutter | O fork acompanha as APIs atuais de formatação e processos sem alterar o contrato do código gerado. |

## Configuração do fork

Coloque estas chaves em `get_cli:` no `pubspec.yaml` ou diretamente no nível principal de `.get_cli.yaml`. Quando os dois arquivos definem configurações, o mapa `get_cli:` do `pubspec.yaml` tem prioridade.

```yaml
get_cli:
  # O padrão usa a semântica de geração do GetX 4.
  version: 5
  # O padrão é false. Pages, screens e controllers também geram state.
  use_state: true
  templates:
    # Descobre arquivos *.template neste diretório, sem percorrer subdiretórios.
    path: assets/templates
    # Chaves explícitas têm prioridade sobre os arquivos descobertos.
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

O valor padrão de `version` é `4`, e o de `use_state` é `false`. Execute `get create state:session on home` para criar um state explicitamente e conectá-lo a um controller correspondente. Para templates, `page` usa `view` como fallback; sem um template personalizado válido, a CLI usa os modelos internos.

A geração de traduções lê somente arquivos JSON. Os parâmetros explícitos `-i` e `-o` substituem a configuração; a entrada padrão é `assets/locales`, o arquivo gerado padrão é `locales.g.dart` e a classe padrão é `AppTranslation`:

```shell
get generate locales -i translations -o lib/gen
```

As chaves de tradução são emitidas sem alteração como nomes de campos Dart; use identificadores Dart válidos e que não sejam palavras reservadas, como `welcome_message`. JSON inválido encerra a geração. O validador atual rejeita dígitos na primeira posição, espaços em branco e alguns caracteres especiais, mas não normaliza nem valida completamente os identificadores Dart.

## Contratos de execução e compatibilidade

- Repetir a geração de uma page principal ou aninhada não deve duplicar constantes de rota, entradas `GetPage`, rotas filhas ou imports.
- A criação de projetos Flutter aceita Kotlin ou Java para Android. A opção de linguagem iOS removida pelo Flutter não é enviada; um resultado diferente de zero em `flutter create` interrompe a inicialização restante.
- Exceções capturadas pela CLI mantêm um código de saída diferente de zero. A automação pode tratar `0` como sucesso e qualquer outro valor como falha.
- A compatibilidade com a toolchain é automática. O projeto precisa apenas atender à restrição de SDK no `pubspec.yaml`, sem configuração adicional.

## Referência rápida de comandos

```shell
// Para criar um projeto de flutter no diretório atual:
// Nota: Por padrão, o nome da pasta será o nome do projeto
// Você pode nomear o projeto com `get create project: my_project`
// Se o nome tiver espaços, use `get create project:" my cool project "`
get create project

// Para gerar uma estrutura em um projeto existente:
get init

// Para criar uma Page:
// (Pages tem controller, view, and binding)
// Nota: você pode usar qualquer nome, ex: `get create page:login`
// Nota: use essa opcão se a estrutura escolhida for Getx_pattern
get create page:home

// Para criar uma Screen:
// (Screen tem controller, view, and binding)
// Nota: você pode usar qualquer nome, ex: `get create Screen:login`
// Nota: use essa opcão se a estrutura escolhida for CLEAN (by Arktekko)
get create screen:home

// Para criar um novo controller em uma pasta específica:
// Observação: você não precisa fazer referência à pasta,
// Getx irá procurar automaticamente pela pasta pessoal
// e adicione seu controlador lá.
get create controller:dialogcontroller on home

// Para criar um state e conectá-lo a um controller correspondente:
get create state:session on home

// Para criar uma nova view em uma pasta específica:
// Observação: você não precisa fazer referência à pasta,
// Getx irá procurar automaticamente pela pasta pessoal
// e inserir sua View lá.
get create view:dialogview on home

// Para criar um novo Provider em uma pasta específica:
get create provider:user on home

// Para gerar um arquivo de localização:
// Nota: diretório 'assets/locales' com seus arquivos de tradução em formato json
get generate locales assets/locales

// Para gerar um modelo de classe:
// Nota: 'assets/models/user.json' é o diretório do seu arquivo modelo no formato .json
// Nota: on  == pasta onde seu arquivo será gerado
// Getx irá procurar automaticamente pela pasta inicial
// e inserir sua classe modelo lá.
get generate model on home with assets/models/user.json

// Para gerar um modelo sem Provider:
get generate model on home with assets/models/user.json --skipProvider

// Nota: a URL deve retorna um arquivo formato em json
get generate model on home from "https://api.github.com/users/CpdnCristiano"

// Para instalar um pacote em seu projeto (dependencies):
get install camera

// Para instalar vários pacotes em seu projeto:
get install http path camera

// Para instalar um pacote com uma versão específica:
get install path:1.6.4

// Você também pode especificar as versões e vários pacotes

// Para instalar um pacote dev em seu projeto (dependencies_dev):
get install flutter_launcher_icons --dev

// Para remover um pacote do seu projeto:
get remove http

// Para remover vários pacotes do seu projeto:
get remove http path

// Para atualizar a CLI:
get update
// ou `get upgrade`

// Mostra a versão CLI atual:
get -v
// ou `get --version`

// Para obter ajudar
get help
```

## Explorando a CLI

Bora explorar os comandos existentes na CLI

### Criar projeto

```shell
  get create project
```

Usando esse comando parar gerar um novo projeto, você pode escolher entre [Flutter](https://github.com/flutter/flutter) e [get_server](https://pub.dev/packages/get_server), depois de criar o diretório padrão, será executado o comando `get init`

### Iniciar

```shell
  get init
```

Use este comando com cuidado, pois ele sobrescreverá todos os arquivos na pasta lib.
Ele permite que você escolha entre duas estruturas, [getx_pattern](https://kauemurakami.github.io/getx_pattern/) e [clean](https://github.com/Katekko/ekko_app).

### Criar uma Page

```shell
  get create page:name
```

Este comando permite criar módulos, é recomendado para usuários que optaram por usar getx_pattern.

Cria a View, o Controller e os arquivos de Binding, além de adicionar automaticamente a rota.

Você pode criar um módulo dentro de outro módulo.

```shell
  get create page:name on other_module
```

Agora ao criar um novo projeto e usar `on` para criar uma página, a CLI criará uma [Page filha](https://github.com/jonataslaw/getx/blob/master/CHANGELOG.md#3210---big-update).

### Criar uma Screen

```shell
  get create screen:name
```

Semelhante ao `create page`, mas adequado para aqueles que usam Clean

### Criar um Controller

```shell
  get create controller:dialog on your_folder
```

Cria um Controller em uma pasta específica.

_Usando com opção_, agora você pode criar um arquivo de modelo, da maneira que preferir.

_execute no terminal_

```shell
  get create controller:auth with examples/authcontroller.dart on your_folder
```

ou com uma URL _execute_

```shell
  get create controller:auth with 'https://raw.githubusercontent.com/sm-packages/sm_get_cli/master/samples_file/controller.dart.template' on your_folder
```

input

```dart
@{import}

class @{controller} extends GetxController {
  final  email = ''.obs;
  final  password = ''.obs;
  void login() {
  }

}
```

output

```dart
import 'package:get/get.dart';

class AuthController extends GetxController {
  final email = ''.obs;
  final password = ''.obs;
  void login() {}
}
```

## Criar uma View

```shell
  get create view:dialog on your_folder
```

Cria uma View em uma pasta específica

## Gerar arquivos de idioma

Crie os arquivos de idioma json na pasta assets/locales.

input: <br/>

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

en_EN.json

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

Rode no terminal :

```dart
get generate locales assets/locales
```

output:

```dart
abstract class AppTranslation {

  static Map<String, Map<String, String>> translations = {
    'en_EN' : Locales.en_EN,
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

  static const en_EN = {
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

Agora basta adicionar a seguinte linha em GetMaterialApp:

```dart
    GetMaterialApp(
      ...
      translationsKeys: AppTranslation.translations,
      ...
    )
```

### Gerar um modelo exemplo

Cria um arquivo modelo em json em assets/models/user.json<br/>

input: <br/>

```json
{
  "name": "",
  "age": 0,
  "friends": ["", ""]
}
```

Execute no terminal:

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

### Separador no formato do arquivo

Um dia um usuário me perguntou se era possível mudar o nome final do arquivo, ele achou mais legível usar: `my_controller_name.controller.dart`, ao invés do padrão gerado pelo cli:`my_controller_name_controller. dart` pensando em usuários como ele adicionamos a opção de você escolher seu próprio separador, basta adicionar esta informação em seu pubsepc.yaml

Exemplo:

```yaml
get_cli:
  separator: "."
```

### Seus imports estão desorganizadas?

Para ajudá-lo a organizar seus imports, um novo comando foi criado: `get sort`, além de organizar suas importações, o comando também formatará seu arquivo dart. graças a [dart_style](https://pub.dev/packages/dart_style).
Ao usar `get sort`, todos os arquivos são renomeados, com o [separador](#separador-no-formato-do-arquivo).
Para não renomear, use o sinalizador `--skipRename`.

Você é um daqueles que prefere usar imports relativos em vez de imports de projeto, use a opção `--relative`. o sm_get_cli irá converter para você.

### Internacionalização da cli

CLI agora tem um sistema de internacionalização.

para traduzir o cli para o seu idioma:

1. crie um novo arquivo json com o seu idioma, na pasta [translations](/translations)
2. Copie as chaves do [arquivo](/translations/en.json) e traduza os valores
3. envie seu PR.

A fazer:

- Suporte para customModels
- Incluir testes unitários
- Melhorar a estrutura gerada
- Adicionar um sistema de backup
