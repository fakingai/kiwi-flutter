import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/viewmodels/auth_viewmodel.dart';
import '../../core/utils/screen_utils.dart';

// 建议将这些常量迁移到 core/constants/colors.dart 等
const Color kPrimaryColor = Color(0xFF204080); // 企业主色
const Color kAccentColor = Color(0xFF4B6CB7); // 渐变色/高亮
const Color kCardBg = Color(0xFFF7F9FC);
const double kCardRadius = 20;
const double kButtonRadius = 12;
const double kInputRadius = 10;
const double kLogoSize = 64;
const double kTabBarHeight = 48;

/// 登录页面
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final pwdController = TextEditingController();
  bool showPwd = false;
  bool isLoginTab = true;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        isLoginTab = _tabController.index == 0;
      });
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    pwdController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AuthViewModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDesktop = ScreenUtils.isDesktopDevice();
    final cardWidth =
        isDesktop ? 440.0 : (screenWidth < 600 ? screenWidth * 0.95 : 380.0);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : null,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                isDark
                    ? [Color(0xFF23243A), Color(0xFF1A1B2F)]
                    : [Color(0xFFE8ECF5), Colors.white],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth < 600 ? 12 : 32,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: cardWidth,
                    padding: EdgeInsets.all(screenWidth < 600 ? 20 : 32),
                    decoration: BoxDecoration(
                      color: isDark ? Color(0xFF23243A) : kCardBg,
                      borderRadius: BorderRadius.circular(kCardRadius),
                      boxShadow: [
                        BoxShadow(
                          color:
                              isDark
                                  ? Colors.black.withOpacity(0.3)
                                  : Colors.blueGrey.withOpacity(0.08),
                          blurRadius: 32,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo
                        Container(
                          width: kLogoSize,
                          height: kLogoSize,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(kLogoSize / 2),
                            boxShadow: [
                              BoxShadow(
                                color: kPrimaryColor.withOpacity(0.18),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            // 如有企业logo图片可替换为Image.asset('assets/logo.png')
                            child: Icon(
                              Icons.apartment_rounded,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        // Tabs
                        Container(
                          height: kTabBarHeight,
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TabBar(
                            controller: _tabController,
                            indicator: BoxDecoration(
                              color: kPrimaryColor.withOpacity(0.13),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelColor: kPrimaryColor,
                            unselectedLabelColor: Colors.grey.shade500,
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 1.5,
                            ),
                            tabs: const [Tab(text: '登录'), Tab(text: '注册')],
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Tab Content - 使用 LayoutBuilder 动态计算高度
                        LayoutBuilder(
                          builder: (context, constraints) {
                            double formHeight =
                                isLoginTab
                                    ? (isDesktop
                                        ? 260
                                        : (screenHeight < 600 ? 220 : 250))
                                    : (isDesktop
                                        ? 340
                                        : (screenHeight < 600 ? 300 : 340));
                            return SizedBox(
                              height: formHeight,
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  buildLoginForm(vm, isDark),
                                  buildRegisterForm(vm, isDark),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),
                  Text(
                    'RAG服务 © 2025',
                    style: TextStyle(
                      color: isDark ? Colors.grey[600] : Colors.grey.shade400,
                      fontSize: 13,
                    ),
                  ),
                  SafeArea(child: SizedBox(height: 0)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLoginForm(AuthViewModel vm, bool isDark) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '邮箱',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: kPrimaryColor,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(fontSize: isSmallScreen ? 15 : 16),
          decoration: InputDecoration(
            hintText: '请输入企业邮箱',
            prefixIcon: const Icon(Icons.email_outlined, color: kPrimaryColor),
            contentPadding: EdgeInsets.symmetric(
              vertical: isSmallScreen ? 14 : 18,
            ),
            filled: true,
            fillColor: isDark ? Colors.grey[850] : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kInputRadius),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kInputRadius),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kInputRadius),
              borderSide: BorderSide(color: kPrimaryColor, width: 1.5),
            ),
          ),
        ),
        SizedBox(height: isSmallScreen ? 14 : 18),
        const Text(
          '密码',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: kPrimaryColor,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: pwdController,
          obscureText: !showPwd,
          style: TextStyle(fontSize: isSmallScreen ? 15 : 16),
          decoration: InputDecoration(
            hintText: '请输入密码',
            contentPadding: EdgeInsets.symmetric(
              vertical: isSmallScreen ? 14 : 18,
            ),
            prefixIcon: const Icon(Icons.lock_outline, color: kPrimaryColor),
            suffixIcon: IconButton(
              icon: Icon(
                showPwd ? Icons.visibility_off : Icons.visibility,
                color: kPrimaryColor,
              ),
              onPressed: () => setState(() => showPwd = !showPwd),
            ),
            filled: true,
            fillColor: isDark ? Colors.grey[850] : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kInputRadius),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kInputRadius),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kInputRadius),
              borderSide: BorderSide(color: kPrimaryColor, width: 1.5),
            ),
          ),
        ),
        if (vm.error != null && isLoginTab)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              vm.error!,
              style: const TextStyle(color: Colors.red, fontSize: 13),
            ),
          ),
        SizedBox(height: isSmallScreen ? 18 : 22),
        SizedBox(
          width: double.infinity,
          height: isSmallScreen ? 48 : 54,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kButtonRadius),
              ),
              elevation: 2,
              padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 16),
            ),
            onPressed:
                vm.isLoading
                    ? null
                    : () async {
                      await vm.login(emailController.text, pwdController.text);
                      if (mounted && vm.error == null) {
                        Navigator.pushReplacementNamed(context, '/main');
                      }
                    },
            child:
                vm.isLoading
                    ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                    : const Text(
                      '登录',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
        ),
      ],
    );
  }

  Widget buildRegisterForm(AuthViewModel vm, bool isDark) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final registerEmailController = TextEditingController();
    final registerPwdController = TextEditingController();
    final registerPwd2Controller = TextEditingController();
    // 提升到外部作用域
    bool showRegisterPwd = false;
    bool showRegisterPwd2 = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '邮箱',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: registerEmailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(fontSize: isSmallScreen ? 15 : 16),
              decoration: InputDecoration(
                hintText: '请输入企业邮箱',
                contentPadding: EdgeInsets.symmetric(
                  vertical: isSmallScreen ? 14 : 18,
                ),
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: kPrimaryColor,
                ),
                filled: true,
                fillColor: isDark ? Colors.grey[850] : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kInputRadius),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kInputRadius),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kInputRadius),
                  borderSide: BorderSide(color: kPrimaryColor, width: 1.5),
                ),
              ),
            ),
            SizedBox(height: isSmallScreen ? 14 : 18),
            const Text(
              '密码',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: registerPwdController,
              obscureText: !showRegisterPwd,
              style: TextStyle(fontSize: isSmallScreen ? 15 : 16),
              decoration: InputDecoration(
                hintText: '设置登录密码',
                contentPadding: EdgeInsets.symmetric(
                  vertical: isSmallScreen ? 14 : 18,
                ),
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: kPrimaryColor,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    showRegisterPwd ? Icons.visibility_off : Icons.visibility,
                    color: kPrimaryColor,
                  ),
                  onPressed:
                      () => setState(() => showRegisterPwd = !showRegisterPwd),
                ),
                filled: true,
                fillColor: isDark ? Colors.grey[850] : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kInputRadius),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kInputRadius),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kInputRadius),
                  borderSide: BorderSide(color: kPrimaryColor, width: 1.5),
                ),
              ),
            ),
            SizedBox(height: isSmallScreen ? 14 : 18),
            const Text(
              '确认密码',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: registerPwd2Controller,
              obscureText: !showRegisterPwd2,
              style: TextStyle(fontSize: isSmallScreen ? 15 : 16),
              decoration: InputDecoration(
                hintText: '再次输入密码',
                contentPadding: EdgeInsets.symmetric(
                  vertical: isSmallScreen ? 14 : 18,
                ),
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: kPrimaryColor,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    showRegisterPwd2 ? Icons.visibility_off : Icons.visibility,
                    color: kPrimaryColor,
                  ),
                  onPressed:
                      () =>
                          setState(() => showRegisterPwd2 = !showRegisterPwd2),
                ),
                filled: true,
                fillColor: isDark ? Colors.grey[850] : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kInputRadius),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kInputRadius),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kInputRadius),
                  borderSide: BorderSide(color: kPrimaryColor, width: 1.5),
                ),
              ),
            ),
            if (vm.error != null && !isLoginTab)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  vm.error!,
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                ),
              ),
            SizedBox(height: isSmallScreen ? 18 : 22),
            SizedBox(
              width: double.infinity,
              height: isSmallScreen ? 48 : 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kButtonRadius),
                  ),
                  elevation: 2,
                  padding: EdgeInsets.symmetric(
                    vertical: isSmallScreen ? 12 : 16,
                  ),
                ),
                onPressed:
                    vm.isLoading
                        ? null
                        : () async {
                          await vm.register(
                            registerEmailController.text,
                            registerPwdController.text,
                          );
                          if (mounted && vm.error == null) {
                            Navigator.pushReplacementNamed(context, '/main');
                          }
                        },
                child:
                    vm.isLoading
                        ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Text(
                          '注册',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            ),
          ],
        );
      },
    );
  }
}
