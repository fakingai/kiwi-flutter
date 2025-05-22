# Postman API 文档说明

- 项目已集成 Postman 导出的服务端 API 文档，文件路径为：`doc/api/rag-api-server.postman_collection.json`
- 当需要查询、调用或了解后端 API 时，请优先在该文件中查找接口定义、请求参数和示例。
- Copilot 及开发者可直接参考此文件，获取所有服务端 API 的详细信息。

---

# Copilot 指令

## 项目概述
这是一个基于 Flutter 的项目，旨在实现 RAG (Retrieval Augmented Generation) PRO 功能。
项目遵循 Clean Architecture 设计模式，以确保代码的可维护性、可测试性和可扩展性。

## 架构分层
项目 `lib` 目录主要分为以下几个核心层：

-   **`app`**: 应用层，包含应用特有的业务逻辑和用例实现。
    -   `usecases`: 应用层用例的具体实现。
    -   `viewmodels`: (或 Presenters/Controllers) 视图模型，连接视图和业务逻辑。
    -   `widgets`: 应用级别的通用小组件。
-   **`data`**: 数据层，负责数据的获取、存储和管理。
    -   `datasources`: 数据源，分为本地数据源和远程数据源。
        -   `local`: 本地数据源接口和实现 (例如 SQLite, SharedPreferences)。
        -   `remote`: 远程数据源接口和实现 (例如 API 调用)。
    -   `models`: 数据传输对象 (DTOs)，用于在不同层之间传递数据。通常是 API 响应或数据库记录的直接映射。
    -   `repositories`: 数据仓库的实现，实现了领域层定义的仓库接口。
-   **`domain`**: 领域层，包含核心业务逻辑和实体。
    -   `entities`: 业务实体，代表核心业务对象。
    -   `repositories`: 数据仓库的抽象接口，定义了数据操作的契约。
    -   `usecases`: 领域层用例的抽象接口或纯业务逻辑。
-   **`presentation`**: 表示层，负责用户界面的展示和用户交互。
    -   `pages`: (或 Screens) 页面/屏幕组件。
    -   `widgets`: 页面特有的小组件。
    -   `bloc`: (或 Cubit/Provider/GetX Controllers) 状态管理逻辑。
-   **`core`**: 核心工具和通用功能。
    -   `error`: 错误处理机制 (例如 Failure 类, 异常)。
    -   `di`: 依赖注入配置。
    -   `navigation`: 路由管理。
    -   `theme`: 应用主题和样式。
    -   `utils`: 通用工具类和辅助函数。
    -   `constants`: 应用常量。

## 开发规范
-   **命名规范**:
    -   文件名和类名使用驼峰式命名法 (PascalCase)。
    -   方法名和变量名使用小驼峰式命名法 (camelCase)。
    -   常量使用全大写和下划线 (UPPER_SNAKE_CASE)。
-   **注释**:
    -   所有公开的类、方法和重要代码块都需要添加详细的中文注释。
    -   注释应清晰说明其功能、参数、返回值和注意事项。
-   **日志记录**:
    -   在关键的业务逻辑执行路径、重要状态变更、外部交互（如API调用）、以及错误处理中，应使用 `AppLogger` 记录日志。
    -   根据日志内容的重要性选择合适的日志级别：`AppLogger.debug` 用于调试信息，`AppLogger.info` 用于常规流程信息，`AppLogger.warning` 用于潜在问题，`AppLogger.error` 用于已捕获的错误，`AppLogger.fatal` 用于严重错误。
    -   日志信息应包含足够的上下文，便于问题排查和行为分析。
-   **代码风格**:
    -   遵循 Flutter 官方推荐的代码风格。
    -   使用 `flutter format .` 进行代码格式化。
-   **状态管理**:
    -   根据模块需求选择合适的状态管理方案 (例如 BLoC/Cubit, Provider, Riverpod, GetX)。
    -   在 `presentation` 层的 `bloc` (或相应状态管理文件夹) 中实现。
-   **依赖注入**:
    -   使用 `get_it` 或其他依赖注入库进行依赖管理，配置在 `core/di`。
-   **错误处理**:
    -   使用 `Either` 类型或自定义的 `Failure` 类来处理用例中的错误和成功场景。
-   **测试**:
    -   为领域层和数据层的逻辑编写单元测试。
    -   为表示层的组件编写小组件测试。

## Copilot 使用技巧
-   在编写新模块或类时，可以先定义好接口和预期的功能，然后让 Copilot 协助生成初步的实现代码。
-   对于重复性的代码模式 (例如模型的 `fromJson`, `toJson` 方法)，可以提供一个示例，让 Copilot 学习并应用到其他模型。
-   在遇到不确定的 API 或库用法时，可以尝试向 Copilot 提问或让其生成示例代码。
-   定期审查 Copilot 生成的代码，确保其符合项目规范和最佳实践。

## 模块创建示例
当需要创建一个新的功能模块，例如 "用户认证" (Auth)，可以按照以下步骤：

1.  **Domain Layer**:
    -   `lib/domain/entities/user_entity.dart` (用户实体)
    -   `lib/domain/repositories/auth_repository.dart` (认证仓库接口)
    -   `lib/domain/usecases/login_usecase.dart` (登录用例接口/逻辑)
    -   `lib/domain/usecases/register_usecase.dart` (注册用例接口/逻辑)
2.  **Data Layer**:
    -   `lib/data/models/user_model.dart` (用户数据模型，继承/实现 UserEntity)
    -   `lib/data/datasources/remote/auth_remote_datasource.dart` (远程认证数据源接口及实现)
    -   `lib/data/repositories/auth_repository_impl.dart` (认证仓库实现)
3.  **App Layer / Presentation Layer**:
    -   `lib/app/viewmodels/auth_viewmodel.dart` (认证视图模型)
    -   `lib/presentation/pages/login_page.dart` (登录页面)
    -   `lib/presentation/pages/register_page.dart` (注册页面)
    -   `lib/presentation/bloc/auth_bloc/auth_bloc.dart` (认证状态管理)
4.  **Core Layer**:
    -   在 `core/di/` 中注册新的依赖项。
    -   在 `core/navigation/` 中添加新的路由。

请遵循以上指南进行开发。

# 多端适配说明

本项目旨在支持多端运行，包括 iOS、Android、Windows、Mac、Linux 及 Web 平台。在实现 UI 界面、调用第三方库、以及与操作系统交互时，需充分考虑各平台的适配性和兼容性。

- **UI 适配**：
    - 优先使用 Flutter 官方推荐的跨平台组件，避免依赖仅支持单一平台的控件。
    - 针对不同平台的 UI 差异，可通过 `Platform.isXXX` 判断平台，进行条件渲染或样式调整。
    - 注意响应式布局，确保在不同尺寸和分辨率下界面正常显示。
- **第三方库选择**：
    - 选择支持多端的第三方库，优先考虑官方推荐或社区活跃的库。
    - 如需使用仅支持部分平台的库，需在文档和代码中明确标注，并做好平台兼容处理。
- **操作系统交互**：
    - 涉及原生能力（如文件系统、相机、通知等）时，优先使用 Flutter 官方插件或支持多端的插件。
    - 如需自定义平台通道（Platform Channel），需分别实现各端的原生代码，并保持接口一致。
- **平台特性处理**：
    - 针对 Web 端，注意避免直接调用原生 API，可使用 `kIsWeb` 进行平台判断。
    - 针对桌面端（Windows/Mac/Linux），注意窗口管理、文件路径等与移动端的差异。
- **测试与验证**：
    - 新功能开发完成后，需在所有目标平台上进行测试，确保功能和体验一致。
    - 对于平台相关的 bug 或兼容性问题，需及时记录并修复。

请在开发过程中，始终关注多端适配，确保项目在各平台均能稳定运行并提供一致的用户体验。
