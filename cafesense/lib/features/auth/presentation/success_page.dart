import 'package:flutter/material.dart';

import "package:cafesense/core/theme/app_colors.dart";
import "package:cafesense/features/onboarding/presentation/welcome_screen.dart";

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const Positioned.fill(
            child: _BackgroundGlow(),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.menu,
                            color: AppColors.primary, size: 28),
                      ),
                      const Spacer(),
                      Text(
                        'Savour',
                        style: textTheme.headlineLarge?.copyWith(
                          color: AppColors.primary,
                          fontFamily: 'Epilogue',
                          fontSize: 58 / 2,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.6,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 120),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: Column(
                          children: [
                            const SizedBox(height: 14),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 168,
                                  height: 168,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0x24DAE8BE),
                                  ),
                                ),
                                Container(
                                  width: 128,
                                  height: 128,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.surfaceContainerLowest,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x1E364224),
                                        blurRadius: 24,
                                        offset: Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(Icons.check_circle,
                                      color: AppColors.tertiary, size: 72),
                                ),
                              ],
                            ),
                            const SizedBox(height: 42),
                            Text(
                              'Xác thực thành công!',
                              textAlign: TextAlign.center,
                              style: textTheme.headlineLarge?.copyWith(
                                color: AppColors.primary,
                                fontFamily: 'Epilogue',
                                fontSize: 60 / 2,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.8,
                              ),
                            ),
                            const SizedBox(height: 18),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 320),
                              child: Text(
                                'Tài khoản của bạn đã được xác thực. Hãy bắt đầu khám phá thế giới cà phê cùng Cafe Sense nhé.',
                                textAlign: TextAlign.center,
                                style: textTheme.bodyLarge?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                  fontFamily: 'Inter',
                                  fontSize: 18,
                                  height: 1.55,
                                ),
                              ),
                            ),
                            const SizedBox(height: 38),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            const WelcomeScreen()),
                                    (Route<dynamic> route) => false,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: AppColors.primaryContainer,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18)),
                                  textStyle: const TextStyle(
                                    fontFamily: 'Epilogue',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                child: const Text('Khám phá ngay'),
                              ),
                            ),
                            const SizedBox(height: 54),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Transform.rotate(
                                angle: 0.18,
                                child: Container(
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3B3B3B),
                                    borderRadius: BorderRadius.circular(22),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x1A000000),
                                        blurRadius: 18,
                                        offset: Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: Image.network(
                                      'https://lh3.googleusercontent.com/aida-public/AB6AXuDtzZy_ArV-xgz_oov4tikE1tTS8kr3atP7qR8iM_eB5Y6Ex7IJnZINOPIV_kRQYGxCHQ9Q1e21lpLurt7NjBcCTvHs0FmitM0G67AIGe7SJJqkumMvL3Vfj4kK9O8zvmNnLiZGf09eibRddXhNQMDhjJheyzFS5sAopw-Vu8r6AaQbRocVW_qo8Tgdh3-zkBE7OjXBRCKtV0ERlSHHYOfk6no4yxCHAskkATLPOapv0YQ9BpGDqH3cG7JHMmWT9BIjy4omYe6bNp',
                                      fit: BoxFit.cover,
                                      errorBuilder: (BuildContext context,
                                          Object error,
                                          StackTrace? stackTrace) {
                                        return Container(
                                            color: AppColors.surfaceContainer);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color:
                      AppColors.surfaceContainerLowest.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A553722),
                      blurRadius: 30,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _BottomItem(
                        icon: Icons.local_cafe,
                        label: 'BOUTIQUE',
                        active: false),
                    _BottomItem(
                        icon: Icons.auto_awesome,
                        label: 'ROASTS',
                        active: false),
                    _BottomItem(
                        icon: Icons.auto_stories,
                        label: 'JOURNAL',
                        active: false),
                    _BottomItem(
                        icon: Icons.person, label: 'PROFILE', active: true),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  const _BottomItem(
      {required this.icon, required this.label, required this.active});

  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final Color foreground = active ? Colors.white : const Color(0xFFB4ACA6);
    final Color background =
        active ? AppColors.primaryContainer : Colors.transparent;

    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: foreground, size: active ? 28 : 24),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: foreground,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundGlow extends StatelessWidget {
  const _BackgroundGlow();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -10,
          left: -10,
          child: Container(
            width: 280,
            height: 280,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0x0D553722),
            ),
          ),
        ),
        Positioned(
          bottom: -20,
          right: -20,
          child: Container(
            width: 320,
            height: 320,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0x0C364224),
            ),
          ),
        ),
      ],
    );
  }
}
