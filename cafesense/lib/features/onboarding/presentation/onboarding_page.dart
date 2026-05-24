import 'package:flutter/material.dart';

import 'package:cafesense/core/theme/app_colors.dart';
import 'onboarding_two_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _featureSectionKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToFeatureSection() {
    final BuildContext? context = _featureSectionKey.currentContext;
    if (context == null) {
      return;
    }

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeOutCubic,
      alignment: 0.05,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final bool isDesktop = size.width >= 980;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned.fill(child: _AmbientBackground()),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1240),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          isDesktop ? 44 : 20,
                          isDesktop ? 18 : 14,
                          isDesktop ? 44 : 20,
                          0,
                        ),
                        child: _HeroSection(
                          isDesktop: isDesktop,
                          onLearnMore: _scrollToFeatureSection,
                        ),
                      ),
                      const SizedBox(height: 24),
                      KeyedSubtree(
                        key: _featureSectionKey,
                        child: _FeatureSection(isDesktop: isDesktop),
                      ),
                      const SizedBox(height: 18),
                      const _FooterRail(),
                      const SizedBox(height: 12),
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

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.isDesktop, required this.onLearnMore});

  final bool isDesktop;
  final VoidCallback onLearnMore;

  @override
  Widget build(BuildContext context) {
    if (!isDesktop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: _HeroCopy(onLearnMore: onLearnMore),
          ),
          const SizedBox(height: 24),
          const _ImageComposition(isDesktop: false),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 10,
          child: Padding(
            padding: const EdgeInsets.only(right: 42, left: 10, top: 48),
            child: _HeroCopy(onLearnMore: onLearnMore),
          ),
        ),
        const Expanded(
          flex: 11,
          child: Padding(
            padding: EdgeInsets.only(top: 8),
            child: _ImageComposition(isDesktop: true),
          ),
        ),
      ],
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({required this.onLearnMore});

  final VoidCallback onLearnMore;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool isDesktop = MediaQuery.sizeOf(context).width >= 980;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.coffee, color: AppColors.primary, size: 24),
            const SizedBox(width: 8),
            Text(
              'Cafe Sense',
              style: textTheme.titleLarge?.copyWith(
                color: AppColors.primary,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w800,
                letterSpacing: -0.8,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          'Tìm Quán Café\n',
          style: textTheme.headlineLarge?.copyWith(
            color: AppColors.onSurface,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w800,
            fontSize: isDesktop ? 66 : 44,
            height: 1.03,
            letterSpacing: -2.2,
          ),
        ),
        RichText(
          text: TextSpan(
            style: textTheme.headlineLarge?.copyWith(
              color: AppColors.onSurface,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w800,
              fontSize: isDesktop ? 66 : 44,
              height: 1.03,
              letterSpacing: -2.2,
            ),
            children: const [
              TextSpan(
                text: 'Hoàn Hảo',
                style: TextStyle(
                  color: AppColors.primary,
                  fontStyle: FontStyle.italic,
                ),
              ),
              TextSpan(text: '\nChỉ Trong Vài Giây'),
            ],
          ),
        ),
        const SizedBox(height: 22),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(
            'Để Cafe Sense ghép tâm trạng của bạn với quán café lý tưởng thông qua trải nghiệm khám phá giác quan độc đáo.',
            style: textTheme.bodyLarge?.copyWith(
              color: AppColors.secondary,
              fontSize: isDesktop ? 20 : 16,
              height: 1.6,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        const OnboardingTwoPage(),
                  ),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryContainer,
                foregroundColor: AppColors.onPrimary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                textStyle: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
                shape: const StadiumBorder(),
              ),
              child: const Text('Bắt Đầu Ngay'),
            ),
            OutlinedButton(
              onPressed: onLearnMore,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.onSurface,
                side: const BorderSide(color: AppColors.outlineVariant),
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                textStyle: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
                shape: const StadiumBorder(),
              ),
              child: const Text('Tìm Hiểu Thêm'),
            ),
          ],
        ),
      ],
    );
  }
}

class _ImageComposition extends StatelessWidget {
  const _ImageComposition({required this.isDesktop});

  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final double height = isDesktop ? 760 : 430;

    return SizedBox(
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: isDesktop ? 32 : 18,
            right: 0,
            top: 26,
            bottom: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.secondaryContainer.withValues(alpha: 0.42),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isDesktop ? 96 : 44),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isDesktop ? 96 : 44),
              ),
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuCVwgU4EqO5qkub7xJVxAdaU0c5nqOzxOSZYzIOK9tyLdA35fCUKU-N_dpawyD5NDt0FbQgR8F6sM0DeyCtrHtKZ72hR70-CpMyAOcZQxH9G68JDXCV157U5UXNmyfGULeSuq21tEONFmh7XEmH6Vd6NE2fRM40CPoqPhAgtE7oVESOiiUxQC7s7NLR_0q2sTnv2UAhNumkDXUuwT-Y1PTJjV1pE7PuHlrkOZr1bAMLexS-BUQVakQyHkhRbcw30ja54Bg890nVcv7-',
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  return Container(
                    color: AppColors.surfaceContainer,
                    alignment: Alignment.center,
                    child: const Icon(Icons.local_cafe,
                        color: AppColors.primary, size: 64),
                  );
                },
              ),
            ),
          ),
          if (isDesktop)
            Positioned(
              left: -56,
              top: 180,
              child: Container(
                width: 264,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.4),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 24,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: const _MoodBadge(),
              ),
            ),
        ],
      ),
    );
  }
}

class _MoodBadge extends StatelessWidget {
  const _MoodBadge();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.tertiaryContainer.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(26),
          ),
          child: const Icon(Icons.tune, color: AppColors.tertiary),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tâm trạng hiện tại',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 1.6,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tập trung & Yên tĩnh',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FeatureSection extends StatelessWidget {
  const _FeatureSection({required this.isDesktop});

  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final double horizontal = isDesktop ? 52 : 16;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(horizontal, 24, horizontal, 32),
      color: AppColors.surfaceContainerLow,
      child: const Wrap(
        spacing: 14,
        runSpacing: 14,
        children: [
          _FeatureCard(
            icon: Icons.filter_alt,
            title: 'Bộ Lọc Thông Minh',
            description:
                'Tìm kiếm theo độ ồn, ánh sáng và phong cách nội thất mà bạn yêu thích.',
          ),
          _FeatureCard(
            icon: Icons.auto_awesome,
            title: 'Đề Xuất Cá Nhân',
            description:
                'AI học hỏi gu thẩm mỹ của bạn để gợi ý những không gian mới lạ.',
          ),
          _FeatureCard(
            icon: Icons.sell,
            title: 'Ưu Đãi Đặc Quyền',
            description:
                'Nhận mã giảm giá và quà tặng riêng dành cho thành viên Cafe Sense.',
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.sizeOf(context).width >= 980;
    final double cardWidth = isDesktop
        ? (1240 - (52 * 2) - (14 * 2)) / 3
        : MediaQuery.sizeOf(context).width - 32;

    return SizedBox(
      width: cardWidth,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppColors.tertiary, size: 32),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.onSurface,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.secondary,
                      fontFamily: 'Inter',
                      fontSize: 14,
                      height: 1.6,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterRail extends StatelessWidget {
  const _FooterRail();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 34,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              width: 10,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              width: 10,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'TRẢI NGHIỆM BỞI CAFE SENSE TEAM',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.onSurfaceVariant,
                letterSpacing: 2.2,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

class _AmbientBackground extends StatelessWidget {
  const _AmbientBackground();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.background,
                Color(0xFFF8F5F2),
              ],
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(-0.88, -0.72),
              radius: 0.72,
              colors: [
                Color(0x14A67B5B),
                Colors.transparent,
              ],
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.92, -0.58),
              radius: 0.75,
              colors: [
                Color(0x12D2691E),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
