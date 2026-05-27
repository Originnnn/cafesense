import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafesense/features/onboarding/presentation/welcome_screen.dart';
import 'package:cafesense/features/auth/presentation/login_page.dart';
import 'package:cafesense/features/home/presentation/home_page.dart';
import 'package:cafesense/core/theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CafeSenseSplashPage extends StatefulWidget {
  const CafeSenseSplashPage({super.key});

  @override
  State<CafeSenseSplashPage> createState() => _CafeSenseSplashPageState();
}

class _CafeSenseSplashPageState extends State<CafeSenseSplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToOnboarding();
  }

  Future<void> _navigateToOnboarding() async {
    await Future<void>.delayed(const Duration(milliseconds: 2200));

    if (!mounted) {
      return;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;
    final bool isLoggedIn = user != null;
    final bool isOnboardingCompleted =
        prefs.getBool('isOnboardingCompleted') ?? false;

    Widget destination;
    if (!isLoggedIn) {
      destination = const LoginPage();
    } else if (!isOnboardingCompleted) {
      destination = const WelcomeScreen();
    } else {
      destination = const HomePage();
    }

    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (BuildContext context) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.splashTop,
              ),
            ),
          ),
          const Positioned.fill(child: _MeshBackdrop()),
          Positioned.fill(
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDr0wyieCeKkAyrWa2xurDy30S8sa6PgZEa4Ndfl3swPelVQFiOslcah-1TZkV-CInPY9KukzhW0X_sdXbBzifO4l-RNDmwVJkWLoQKzLNGxcl9l0Mw09BAQyvY-YQtzFe83W_PW8ijsDN75tDDOafc1TPqFiX45LCMKGEJywbMswnVK91cIM9SKepz87c_spM1B-M9vXtRjziVR3fFvqi-nh-25HIZVdM3aXCnu9VUmfYy0SJqkMM1zkVxBLl8mu4aVJpqaHjtu721',
              fit: BoxFit.cover,
              filterQuality: FilterQuality.low,
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                return const SizedBox.expand();
              },
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.18)),
          ),
          SafeArea(
            child: Stack(
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 24),
                          _LogoCluster(size: size),
                          const SizedBox(height: 8),
                          Text(
                            'Cafe Sense',
                            textAlign: TextAlign.center,
                            style:
                                (textTheme.headlineLarge ?? const TextStyle())
                                    .copyWith(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: size.width * 0.085,
                              color: AppColors.splashText,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1.6,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Thấu hiểu từng cung bậc vị giác',
                            textAlign: TextAlign.center,
                            style: (textTheme.bodyLarge ?? const TextStyle())
                                .copyWith(
                              fontFamily: 'Plus Jakarta Sans',
                              color:
                                  AppColors.splashText.withValues(alpha: 0.82),
                              fontSize: size.width * 0.042,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 64,
                  child: _FooterIndicator(),
                ),
                const Positioned(
                  right: 24,
                  bottom: 24,
                  child: Opacity(
                    opacity: 0.1,
                    child: Icon(
                      Icons.contrast,
                      color: AppColors.splashText,
                      size: 28,
                    ),
                  ),
                ),
                const Positioned(
                  top: 0,
                  right: 0,
                  child: _CornerAccent(
                    topRight: true,
                    margin: EdgeInsets.all(48),
                  ),
                ),
                const Positioned(
                  left: 0,
                  bottom: 0,
                  child: _CornerAccent(
                    topRight: false,
                    margin: EdgeInsets.all(48),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoCluster extends StatelessWidget {
  const _LogoCluster({required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    final double ringSize = size.width * 0.24;
    final double iconSize = size.width * 0.13;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          Container(
            width: ringSize,
            height: ringSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.onPrimaryContainer.withValues(alpha: 0.22),
                width: 1,
              ),
            ),
            child: Container(
              width: ringSize * 0.84,
              height: ringSize * 0.84,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.splashText.withValues(alpha: 0.08),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.coffee,
                  size: iconSize,
                  color: AppColors.splashText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterIndicator extends StatelessWidget {
  const _FooterIndicator();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Dot(delay: 0),
            _Dot(delay: 200),
            _Dot(delay: 400),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Authentic Craftsmanship',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontFamily: 'Inter',
                color: AppColors.splashText.withValues(alpha: 0.4),
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 3.2,
              ),
        ),
      ],
    );
  }
}

class _Dot extends StatefulWidget {
  const _Dot({required this.delay});

  final int delay;

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    Future<void>.delayed(Duration(milliseconds: widget.delay), () {
      if (!mounted) {
        return;
      }
      _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        final double easedValue = Curves.easeInOut.transform(_controller.value);
        return Opacity(
          opacity: 0.3 + (easedValue * 0.4),
          child: Transform.scale(
            scale: 0.85 + (easedValue * 0.2),
            child: child,
          ),
        );
      },
      child: Container(
        width: 6,
        height: 6,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: const BoxDecoration(
          color: AppColors.splashText,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _CornerAccent extends StatelessWidget {
  const _CornerAccent({required this.topRight, required this.margin});

  final bool topRight;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Transform.rotate(
        angle: topRight ? math.pi / 4 : -math.pi / 4,
        child: Container(
          width: 96,
          height: 1,
          color: AppColors.splashText.withValues(alpha: 0.2),
        ),
      ),
    );
  }
}

class _MeshBackdrop extends StatelessWidget {
  const _MeshBackdrop();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topLeft,
              radius: 1.05,
              colors: [
                Color(0x26FFFFFF),
                Colors.transparent,
              ],
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.bottomRight,
              radius: 1.0,
              colors: [
                Color(0x1A364224),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
