import 'package:flutter/material.dart';

/// 企业风格主题色定义
class AppColors {
  // 主色（蓝色，企业风格）
  static const Color primary = Color(0xFF0E5CA7); // 企业蓝
  static const Color primaryLight = Color(0xFF4B89DA); // 浅企业蓝
  static const Color primaryDark = Color(0xFF054078); // 深企业蓝
  static const Color primaryContainer = Color(0xFFE6F0FF); // 主色容器
  static const Color primaryContainerDark = Color(0xFF1D3A57); // 深色主题主色容器

  // 辅助色
  static const Color secondary = Color(0xFF2DA5BE); // 清爽青色，企业辅助色
  static const Color secondaryLight = Color(0xFF5ED4EC); // 浅辅助色
  static const Color secondaryDark = Color(0xFF0E7A8D); // 深辅助色
  static const Color secondaryContainer = Color(0xFFE0F7FA); // 辅助色容器
  static const Color secondaryContainerDark = Color(0xFF1C3E44); // 深色主题辅助色容器

  // 状态色
  static const Color success = Color(0xFF2E7D32); // 成功绿色
  static const Color successLight = Color(0xFFE8F5E9); // 成功浅背景
  static const Color warning = Color(0xFFF29D38); // 警告橙色
  static const Color warningLight = Color(0xFFFFF8E1); // 警告浅背景
  static const Color error = Color(0xFFD32F2F); // 错误红色
  static const Color errorLight = Color(0xFFFFEBEE); // 错误浅背景
  static const Color info = Color(0xFF0288D1); // 信息蓝色
  static const Color infoLight = Color(0xFFE1F5FE); // 信息浅背景
  static const Color neutral = Color(0xFF607D8B); // 中性色
  static const Color neutralLight = Color(0xFFECEFF1); // 中性浅色

  // 背景色
  static const Color backgroundLight = Color(0xFFF8F9FC); // 浅灰背景，更专业
  static const Color backgroundDark = Color(0xFF121418); // 深背景，更专业
  static const Color backgroundAltLight = Color(0xFFEEF2F6); // 次级背景色
  static const Color backgroundAltDark = Color(0xFF1E2227); // 次级背景色

  // 表面色
  static const Color surfaceLight = Color(0xFFFFFFFF); // 卡片/表单背景
  static const Color surfaceDark = Color(0xFF1D2129); // 卡片/表单深色
  static const Color surfaceVariantLight = Color(0xFFF0F2F5); // 次级表面
  static const Color surfaceVariantDark = Color(0xFF252A33); // 次级表面（深色）
  static const Color surfaceHighlightLight = Color(0xFFF5F9FF); // 高亮表面
  static const Color surfaceHighlightDark = Color(0xFF2D3239); // 高亮表面（深色）

  // 文本色
  static const Color textLight = Color(0xFF18253A); // 主要文本色，深灰蓝
  static const Color textSecondaryLight = Color(0xFF5F6B7A); // 次要文本色
  static const Color textTertiaryLight = Color(0xFF8996A5); // 第三级文本色
  static const Color textDark = Color(0xFFEDF0F5); // 主要文本色（深色主题）
  static const Color textSecondaryDark = Color(0xFFABB4C2); // 次要文本色（深色主题）
  static const Color textTertiaryDark = Color(0xFF798291); // 第三级文本色（深色主题）

  // 边框和分隔线
  static const Color divider = Color(0xFFDCE0E5); // 更柔和的分隔线
  static const Color dividerDark = Color(0xFF343B45); // 深色模式分隔线
  static const Color border = Color(0xFFCFD6DE); // 边框色
  static const Color borderDark = Color(0xFF3A424E); // 深色边框色

  // 交互状态色
  static const Color hoverLight = Color(0x0A000000); // 悬停状态叠加
  static const Color hoverDark = Color(0x0AFFFFFF); // 深色悬停状态叠加
  static const Color pressedLight = Color(0x1A000000); // 按下状态叠加
  static const Color pressedDark = Color(0x1AFFFFFF); // 深色按下状态叠加
  static const Color selectedLight = Color(0x1A0E5CA7); // 选中状态叠加
  static const Color selectedDark = Color(0x1A4B89DA); // 深色选中状态叠加

  // 特殊色
  static const Color brand = Color(0xFFF5A623); // 品牌强调色
}

/// 明亮主题
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: AppColors.primary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.primary,
    secondary: AppColors.secondary,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.secondary,
    tertiary: AppColors.brand,
    tertiaryContainer: AppColors.brand.withOpacity(0.15),
    onTertiaryContainer: AppColors.brand,
    background: AppColors.backgroundLight,
    surface: AppColors.surfaceLight,
    surfaceVariant: AppColors.surfaceVariantLight,
    error: AppColors.error,
    errorContainer: AppColors.errorLight,
    onErrorContainer: AppColors.error,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: AppColors.textLight,
    onBackground: AppColors.textLight,
    onSurfaceVariant: AppColors.textSecondaryLight,
    shadow: Colors.black.withOpacity(0.1),
    outline: AppColors.border,
    outlineVariant: AppColors.divider,
  ),
  scaffoldBackgroundColor: AppColors.backgroundLight,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.surfaceLight,
    foregroundColor: AppColors.textLight,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.textLight,
    ),
    shadowColor: Colors.black.withOpacity(0.05),
  ),
  cardTheme: CardTheme(
    color: AppColors.surfaceLight,
    elevation: 1,
    shadowColor: Colors.black.withOpacity(0.1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: AppColors.divider.withOpacity(0.5), width: 0.5),
    ),
    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
    clipBehavior: Clip.antiAlias,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceLight,
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.primary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.error, width: 1.5),
    ),
    hintStyle: TextStyle(color: AppColors.textTertiaryLight),
    labelStyle: TextStyle(color: AppColors.textSecondaryLight),
    prefixIconColor: AppColors.textSecondaryLight,
    suffixIconColor: AppColors.textSecondaryLight,
    errorStyle: TextStyle(color: AppColors.error, fontSize: 12, height: 1),
  ),
  dividerTheme: DividerThemeData(
    color: AppColors.divider,
    thickness: 0.5,
    space: 1,
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(
      color: AppColors.textLight,
      fontWeight: FontWeight.bold,
      fontSize: 32,
      letterSpacing: -0.5,
    ),
    displayMedium: TextStyle(
      color: AppColors.textLight,
      fontWeight: FontWeight.bold,
      fontSize: 28,
      letterSpacing: -0.5,
    ),
    displaySmall: TextStyle(
      color: AppColors.textLight,
      fontWeight: FontWeight.bold,
      fontSize: 24,
      letterSpacing: -0.25,
    ),
    headlineLarge: TextStyle(
      color: AppColors.textLight,
      fontWeight: FontWeight.w700,
      fontSize: 22,
      letterSpacing: -0.25,
    ),
    headlineMedium: TextStyle(
      color: AppColors.textLight,
      fontWeight: FontWeight.w600,
      fontSize: 20,
      letterSpacing: -0.25,
    ),
    headlineSmall: TextStyle(
      color: AppColors.textLight,
      fontWeight: FontWeight.w600,
      fontSize: 18,
      letterSpacing: -0.25,
    ),
    titleLarge: TextStyle(
      color: AppColors.textLight,
      fontWeight: FontWeight.w600,
      fontSize: 16,
      letterSpacing: 0,
    ),
    titleMedium: TextStyle(
      color: AppColors.textLight,
      fontWeight: FontWeight.w500,
      fontSize: 15,
      letterSpacing: 0,
    ),
    titleSmall: TextStyle(
      color: AppColors.textLight,
      fontWeight: FontWeight.w500,
      fontSize: 14,
      letterSpacing: 0,
    ),
    bodyLarge: TextStyle(
      color: AppColors.textLight,
      fontWeight: FontWeight.normal,
      fontSize: 16,
      letterSpacing: 0.25,
    ),
    bodyMedium: TextStyle(
      color: AppColors.textLight,
      fontWeight: FontWeight.normal,
      fontSize: 14,
      letterSpacing: 0.25,
    ),
    bodySmall: TextStyle(
      color: AppColors.textSecondaryLight,
      fontWeight: FontWeight.normal,
      fontSize: 12,
      letterSpacing: 0.25,
    ),
    labelLarge: TextStyle(
      color: AppColors.textLight,
      fontWeight: FontWeight.w500,
      fontSize: 14,
      letterSpacing: 0.5,
    ),
    labelMedium: TextStyle(
      color: AppColors.textLight,
      fontWeight: FontWeight.normal,
      fontSize: 12,
      letterSpacing: 0.5,
    ),
    labelSmall: TextStyle(
      color: AppColors.textSecondaryLight,
      fontWeight: FontWeight.normal,
      fontSize: 11,
      letterSpacing: 0.5,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.primary.withOpacity(0.4);
        }
        return AppColors.primary;
      }),
      foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled)) {
          return Colors.white.withOpacity(0.6);
        }
        return Colors.white;
      }),
      overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.pressed)) {
          return AppColors.pressedLight;
        }
        if (states.contains(MaterialState.hovered)) {
          return AppColors.hoverLight;
        }
        return Colors.transparent;
      }),
      minimumSize: MaterialStateProperty.all(const Size(0, 44)),
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 16),
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      elevation: MaterialStateProperty.resolveWith<double>((states) {
        if (states.contains(MaterialState.disabled)) {
          return 0;
        }
        if (states.contains(MaterialState.pressed)) {
          return 0;
        }
        if (states.contains(MaterialState.hovered)) {
          return 2;
        }
        return 1;
      }),
      shadowColor: MaterialStateProperty.all(Colors.black.withOpacity(0.15)),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled)) {
          return Colors.transparent;
        }
        if (states.contains(MaterialState.pressed)) {
          return AppColors.selectedLight;
        }
        if (states.contains(MaterialState.hovered)) {
          return AppColors.surfaceHighlightLight;
        }
        return Colors.transparent;
      }),
      foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.primary.withOpacity(0.4);
        }
        return AppColors.primary;
      }),
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      minimumSize: MaterialStateProperty.all(const Size(0, 44)),
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 16),
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      side: MaterialStateProperty.resolveWith<BorderSide>((states) {
        if (states.contains(MaterialState.disabled)) {
          return BorderSide(color: AppColors.primary.withOpacity(0.3));
        }
        return BorderSide(color: AppColors.primary);
      }),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.transparent),
      foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.primary.withOpacity(0.4);
        }
        return AppColors.primary;
      }),
      overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.pressed)) {
          return AppColors.selectedLight;
        }
        if (states.contains(MaterialState.hovered)) {
          return AppColors.hoverLight;
        }
        return Colors.transparent;
      }),
      minimumSize: MaterialStateProperty.all(const Size(0, 44)),
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 16),
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  ),
  iconTheme: IconThemeData(color: AppColors.textLight, size: 24),
  tabBarTheme: TabBarTheme(
    labelColor: AppColors.primary,
    unselectedLabelColor: AppColors.textSecondaryLight,
    indicatorColor: AppColors.primary,
    indicatorSize: TabBarIndicatorSize.tab,
    dividerColor: AppColors.divider,
    labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
    unselectedLabelStyle: const TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 14,
    ),
  ),
  dialogTheme: DialogTheme(
    backgroundColor: AppColors.surfaceLight,
    elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    titleTextStyle: TextStyle(
      color: AppColors.textLight,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    contentTextStyle: TextStyle(color: AppColors.textLight, fontSize: 14),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith<Color>((
      Set<MaterialState> states,
    ) {
      if (states.contains(MaterialState.disabled)) {
        return AppColors.textSecondaryLight.withOpacity(0.5);
      }
      if (states.contains(MaterialState.selected)) {
        return AppColors.primary;
      }
      return Colors.white;
    }),
    trackColor: MaterialStateProperty.resolveWith<Color>((
      Set<MaterialState> states,
    ) {
      if (states.contains(MaterialState.disabled)) {
        return AppColors.divider;
      }
      if (states.contains(MaterialState.selected)) {
        return AppColors.primary.withOpacity(0.5);
      }
      return AppColors.textSecondaryLight.withOpacity(0.3);
    }),
    trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.resolveWith<Color>((
      Set<MaterialState> states,
    ) {
      if (states.contains(MaterialState.disabled)) {
        return AppColors.textSecondaryLight.withOpacity(0.3);
      }
      if (states.contains(MaterialState.selected)) {
        return AppColors.primary;
      }
      return Colors.transparent;
    }),
    checkColor: MaterialStateProperty.all(Colors.white),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    side: MaterialStateBorderSide.resolveWith((states) {
      if (states.contains(MaterialState.disabled)) {
        return BorderSide(color: AppColors.textSecondaryLight.withOpacity(0.3));
      }
      if (states.contains(MaterialState.selected)) {
        return BorderSide.none;
      }
      return BorderSide(color: AppColors.border);
    }),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.surfaceVariantLight,
    selectedColor: AppColors.primaryContainer,
    disabledColor: AppColors.surfaceVariantLight.withOpacity(0.5),
    labelStyle: TextStyle(fontSize: 12, color: AppColors.textLight),
    secondaryLabelStyle: TextStyle(fontSize: 12, color: AppColors.textLight),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    side: BorderSide.none,
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: AppColors.surfaceLight,
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide(color: AppColors.divider, width: 0.5),
    ),
    textStyle: TextStyle(color: AppColors.textLight, fontSize: 14),
  ),
);

/// 暗黑主题
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: AppColors.primaryLight,
    primaryContainer: AppColors.primaryContainerDark,
    onPrimaryContainer: AppColors.primaryLight,
    secondary: AppColors.secondary,
    secondaryContainer: AppColors.secondaryContainerDark,
    onSecondaryContainer: AppColors.secondaryLight,
    tertiary: AppColors.brand,
    tertiaryContainer: AppColors.brand.withOpacity(0.2),
    onTertiaryContainer: AppColors.brand,
    background: AppColors.backgroundDark,
    surface: AppColors.surfaceDark,
    surfaceVariant: AppColors.surfaceVariantDark,
    error: AppColors.error,
    errorContainer: AppColors.error.withOpacity(0.2),
    onErrorContainer: AppColors.error,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: AppColors.textDark,
    onBackground: AppColors.textDark,
    onSurfaceVariant: AppColors.textSecondaryDark,
    shadow: Colors.black.withOpacity(0.3),
    outline: AppColors.borderDark,
    outlineVariant: AppColors.dividerDark,
  ),
  scaffoldBackgroundColor: AppColors.backgroundDark,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.surfaceDark,
    foregroundColor: AppColors.textDark,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.textDark,
    ),
    shadowColor: Colors.black.withOpacity(0.2),
  ),
  cardTheme: CardTheme(
    color: AppColors.surfaceDark,
    elevation: 1,
    shadowColor: Colors.black.withOpacity(0.3),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        color: AppColors.dividerDark.withOpacity(0.5),
        width: 0.5,
      ),
    ),
    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
    clipBehavior: Clip.antiAlias,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceVariantDark,
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.borderDark),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.borderDark),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.primaryLight, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.error, width: 1.5),
    ),
    hintStyle: TextStyle(color: AppColors.textTertiaryDark),
    labelStyle: TextStyle(color: AppColors.textSecondaryDark),
    prefixIconColor: AppColors.textSecondaryDark,
    suffixIconColor: AppColors.textSecondaryDark,
    errorStyle: TextStyle(color: AppColors.error, fontSize: 12, height: 1),
  ),
  dividerTheme: DividerThemeData(
    color: AppColors.dividerDark,
    thickness: 0.5,
    space: 1,
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(
      color: AppColors.textDark,
      fontWeight: FontWeight.bold,
      fontSize: 32,
      letterSpacing: -0.5,
    ),
    displayMedium: TextStyle(
      color: AppColors.textDark,
      fontWeight: FontWeight.bold,
      fontSize: 28,
      letterSpacing: -0.5,
    ),
    displaySmall: TextStyle(
      color: AppColors.textDark,
      fontWeight: FontWeight.bold,
      fontSize: 24,
      letterSpacing: -0.25,
    ),
    headlineLarge: TextStyle(
      color: AppColors.textDark,
      fontWeight: FontWeight.w700,
      fontSize: 22,
      letterSpacing: -0.25,
    ),
    headlineMedium: TextStyle(
      color: AppColors.textDark,
      fontWeight: FontWeight.w600,
      fontSize: 20,
      letterSpacing: -0.25,
    ),
    headlineSmall: TextStyle(
      color: AppColors.textDark,
      fontWeight: FontWeight.w600,
      fontSize: 18,
      letterSpacing: -0.25,
    ),
    titleLarge: TextStyle(
      color: AppColors.textDark,
      fontWeight: FontWeight.w600,
      fontSize: 16,
      letterSpacing: 0,
    ),
    titleMedium: TextStyle(
      color: AppColors.textDark,
      fontWeight: FontWeight.w500,
      fontSize: 15,
      letterSpacing: 0,
    ),
    titleSmall: TextStyle(
      color: AppColors.textDark,
      fontWeight: FontWeight.w500,
      fontSize: 14,
      letterSpacing: 0,
    ),
    bodyLarge: TextStyle(
      color: AppColors.textDark,
      fontWeight: FontWeight.normal,
      fontSize: 16,
      letterSpacing: 0.25,
    ),
    bodyMedium: TextStyle(
      color: AppColors.textDark,
      fontWeight: FontWeight.normal,
      fontSize: 14,
      letterSpacing: 0.25,
    ),
    bodySmall: TextStyle(
      color: AppColors.textSecondaryDark,
      fontWeight: FontWeight.normal,
      fontSize: 12,
      letterSpacing: 0.25,
    ),
    labelLarge: TextStyle(
      color: AppColors.textDark,
      fontWeight: FontWeight.w500,
      fontSize: 14,
      letterSpacing: 0.5,
    ),
    labelMedium: TextStyle(
      color: AppColors.textDark,
      fontWeight: FontWeight.normal,
      fontSize: 12,
      letterSpacing: 0.5,
    ),
    labelSmall: TextStyle(
      color: AppColors.textSecondaryDark,
      fontWeight: FontWeight.normal,
      fontSize: 11,
      letterSpacing: 0.5,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.primaryLight.withOpacity(0.4);
        }
        return AppColors.primaryLight;
      }),
      foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled)) {
          return Colors.white.withOpacity(0.6);
        }
        return Colors.white;
      }),
      overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.pressed)) {
          return AppColors.pressedDark;
        }
        if (states.contains(MaterialState.hovered)) {
          return AppColors.hoverDark;
        }
        return Colors.transparent;
      }),
      minimumSize: MaterialStateProperty.all(const Size(0, 44)),
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 16),
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      elevation: MaterialStateProperty.resolveWith<double>((states) {
        if (states.contains(MaterialState.disabled)) {
          return 0;
        }
        if (states.contains(MaterialState.pressed)) {
          return 0;
        }
        if (states.contains(MaterialState.hovered)) {
          return 2;
        }
        return 1;
      }),
      shadowColor: MaterialStateProperty.all(Colors.black.withOpacity(0.25)),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled)) {
          return Colors.transparent;
        }
        if (states.contains(MaterialState.pressed)) {
          return AppColors.selectedDark;
        }
        if (states.contains(MaterialState.hovered)) {
          return AppColors.surfaceHighlightDark;
        }
        return Colors.transparent;
      }),
      foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.primaryLight.withOpacity(0.4);
        }
        return AppColors.primaryLight;
      }),
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      minimumSize: MaterialStateProperty.all(const Size(0, 44)),
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 16),
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      side: MaterialStateProperty.resolveWith<BorderSide>((states) {
        if (states.contains(MaterialState.disabled)) {
          return BorderSide(color: AppColors.primaryLight.withOpacity(0.3));
        }
        return BorderSide(color: AppColors.primaryLight);
      }),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.transparent),
      foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.primaryLight.withOpacity(0.4);
        }
        return AppColors.primaryLight;
      }),
      overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.pressed)) {
          return AppColors.selectedDark;
        }
        if (states.contains(MaterialState.hovered)) {
          return AppColors.hoverDark;
        }
        return Colors.transparent;
      }),
      minimumSize: MaterialStateProperty.all(const Size(0, 44)),
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 16),
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  ),
  iconTheme: IconThemeData(color: AppColors.textDark, size: 24),
  tabBarTheme: TabBarTheme(
    labelColor: AppColors.primaryLight,
    unselectedLabelColor: AppColors.textSecondaryDark,
    indicatorColor: AppColors.primaryLight,
    indicatorSize: TabBarIndicatorSize.tab,
    dividerColor: AppColors.dividerDark,
    labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
    unselectedLabelStyle: const TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 14,
    ),
  ),
  dialogTheme: DialogTheme(
    backgroundColor: AppColors.surfaceDark,
    elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    titleTextStyle: TextStyle(
      color: AppColors.textDark,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    contentTextStyle: TextStyle(color: AppColors.textDark, fontSize: 14),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith<Color>((
      Set<MaterialState> states,
    ) {
      if (states.contains(MaterialState.disabled)) {
        return AppColors.textSecondaryDark.withOpacity(0.5);
      }
      if (states.contains(MaterialState.selected)) {
        return AppColors.primaryLight;
      }
      return Colors.white;
    }),
    trackColor: MaterialStateProperty.resolveWith<Color>((
      Set<MaterialState> states,
    ) {
      if (states.contains(MaterialState.disabled)) {
        return AppColors.dividerDark;
      }
      if (states.contains(MaterialState.selected)) {
        return AppColors.primaryLight.withOpacity(0.5);
      }
      return AppColors.textSecondaryDark.withOpacity(0.3);
    }),
    trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.resolveWith<Color>((
      Set<MaterialState> states,
    ) {
      if (states.contains(MaterialState.disabled)) {
        return AppColors.textSecondaryDark.withOpacity(0.3);
      }
      if (states.contains(MaterialState.selected)) {
        return AppColors.primaryLight;
      }
      return Colors.transparent;
    }),
    checkColor: MaterialStateProperty.all(Colors.white),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    side: MaterialStateBorderSide.resolveWith((states) {
      if (states.contains(MaterialState.disabled)) {
        return BorderSide(color: AppColors.textSecondaryDark.withOpacity(0.3));
      }
      if (states.contains(MaterialState.selected)) {
        return BorderSide.none;
      }
      return BorderSide(color: AppColors.borderDark);
    }),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.surfaceVariantDark,
    selectedColor: AppColors.primaryContainerDark,
    disabledColor: AppColors.surfaceVariantDark.withOpacity(0.5),
    labelStyle: TextStyle(fontSize: 12, color: AppColors.textDark),
    secondaryLabelStyle: TextStyle(fontSize: 12, color: AppColors.textDark),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    side: BorderSide.none,
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: AppColors.surfaceDark,
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide(color: AppColors.dividerDark, width: 0.5),
    ),
    textStyle: TextStyle(color: AppColors.textDark, fontSize: 14),
  ),
);

// 主题说明：
// - 明亮主题以蓝色为主色，搭配浅灰、白色背景，文本为深色。
// - 暗黑主题以深蓝为主色，搭配深灰背景，文本为浅色。
// - 主题色彩符合企业风格，适配多端。
// - 组件状态设计全面，包括禁用、悬停、按下、选中等状态。
