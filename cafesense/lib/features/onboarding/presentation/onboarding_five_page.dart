import 'package:flutter/material.dart';

import 'package:cafesense/features/auth/presentation/login_page.dart';
import 'package:cafesense/core/theme/app_colors.dart';

class OnboardingFivePage extends StatelessWidget {
  const OnboardingFivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned.fill(child: _AmbientOrbs()),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                  child: Column(
                    children: [
                      SizedBox(height: 12),
                      _ProgressHeader(),
                      SizedBox(height: 8),
                      Expanded(child: _MainContent()),
                      _FooterAction(),
                      SizedBox(height: 22),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ProgressPill(width: 32),
        SizedBox(width: 10),
        _ProgressPill(width: 32),
        SizedBox(width: 10),
        _ProgressPill(width: 32),
        SizedBox(width: 10),
        _ProgressPill(width: 32),
        SizedBox(width: 10),
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            _ProgressPill(width: 48),
            Positioned(
              top: -18,
              child: Icon(Icons.check, color: AppColors.tertiary, size: 14),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProgressPill extends StatelessWidget {
  const _ProgressPill({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 6,
      decoration: BoxDecoration(
        color: AppColors.tertiary,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: Transform.rotate(
                        angle: 0.105,
                        child: Container(
                          margin: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryContainer
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(48),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Transform.rotate(
                        angle: -0.052,
                        child: Container(
                          margin: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.tertiaryContainer
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(62),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(44),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuD9y-Mok_FG-u9E9D3Eo9azuSc6oovnLMbcAtDnczq0ZgxY_Ff11yuD_1SkfmeXcgQ-sjUkw2i0ESJw1gEcEvTEfm-371frZet4DaKXUq-MvgLcvueMQaQxxkAtTjhp6gzjBjApumQ84f4Ple_yh7OvgpWOca4C0sYKtqG-sp20qfcvXLIVvAud_0Ui-sEnQprPyH2UgYHjgHjZim60x7esCq76Rh6ZoEt1bW87njsc64olZC2z94MWyUvtbEzfh8HUXohPOaa0u-Ha',
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) {
                                return Container(
                                    color: AppColors.surfaceContainer);
                              },
                            ),
                            const DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Color(0x66553722),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: -14,
                      bottom: -12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x22000000),
                              blurRadius: 18,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.tertiary,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(Icons.auto_awesome,
                                  color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Matching...',
                                  style: textTheme.labelLarge?.copyWith(
                                    color: AppColors.secondary,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w800,
                                    fontSize: 10,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '100% Personalised',
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: AppColors.onSurface,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 64),
            Column(
              children: [
                Text(
                  'Sẵn Sàng Khám Phá?',
                  textAlign: TextAlign.center,
                  style: textTheme.headlineLarge?.copyWith(
                    color: AppColors.primary,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w800,
                    fontSize: 56,
                    letterSpacing: -1.1,
                    height: 1.08,
                  ),
                ),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Text(
                    'Những gợi ý quán café được cá nhân hóa đang chờ bạn',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontFamily: 'Inter',
                      fontSize: 20,
                      height: 1.55,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}

class _FooterAction extends StatelessWidget {
  const _FooterAction();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const LoginPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: AppColors.primaryContainer,
              foregroundColor: AppColors.onPrimaryContainer,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
              shape: const StadiumBorder(),
              textStyle: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            icon: const Text(
              'Khám Phá Ngay',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            label: const Padding(
              padding: EdgeInsets.only(left: 6),
              child: Icon(Icons.arrow_forward, size: 22),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Bắt đầu hành trình tìm kiếm hương vị hoàn hảo của bạn',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                  fontFamily: 'Inter',
                  fontSize: 11,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }
}

class _AmbientOrbs extends StatelessWidget {
  const _AmbientOrbs();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: -80,
          top: -60,
          child: Container(
            width: 220,
            height: 220,
            decoration: const BoxDecoration(
              color: Color(0x0D364224),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          left: -100,
          bottom: -60,
          child: Container(
            width: 280,
            height: 280,
            decoration: const BoxDecoration(
              color: Color(0x0D553722),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
