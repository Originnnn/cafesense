import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:cafesense/core/theme/app_colors.dart';
import 'onboarding_four_page.dart';

class OnboardingTwoPage extends StatelessWidget {
  const OnboardingTwoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned.fill(child: _AmbientBackdrop()),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 540),
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(24, 12, 24, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Header(),
                      SizedBox(height: 10),
                      Expanded(child: _MoodSection()),
                      SizedBox(height: 10),
                      _PreviewSection(),
                      SizedBox(height: 18),
                      _FooterActions(),
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

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Row(
              children: [
                const Icon(Icons.coffee, color: AppColors.primary, size: 21),
                const SizedBox(width: 8),
                Text(
                  'Cafe Sense',
                  style: textTheme.titleLarge?.copyWith(
                    color: AppColors.primary,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.9,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              'Bước 02 / 02',
              style: textTheme.labelLarge?.copyWith(
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 11,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Text(
          'Chọn Tâm Trạng Của Bạn',
          style: textTheme.headlineLarge?.copyWith(
            color: AppColors.onSurface,
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 42,
            height: 1.08,
            letterSpacing: -1.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Text(
            'Tâm trạng của bạn cho chúng tôi biết tất cả về quán café hoàn hảo cho bạn',
            style: textTheme.bodyLarge?.copyWith(
              color: AppColors.secondary.withValues(alpha: 0.9),
              fontFamily: 'Inter',
              fontSize: 16,
              height: 1.55,
            ),
          ),
        ),
      ],
    );
  }
}

class _MoodSection extends StatelessWidget {
  const _MoodSection();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final double tileWidth = (width - 48 - 16) / 2;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          _MoodTile(
            width: tileWidth,
            height: 192,
            icon: Icons.menu_book,
            iconContainerColor: AppColors.tertiary.withValues(alpha: 0.10),
            title: 'Tập trung',
            subtitle: 'Focus & Work',
          ),
          _MoodTile(
            width: tileWidth,
            height: 224,
            icon: Icons.weekend,
            iconContainerColor: AppColors.secondary.withValues(alpha: 0.10),
            title: 'Thư giãn',
            subtitle: 'Relax & Chill',
          ),
          _MoodTile(
            width: tileWidth,
            height: 224,
            topOffset: -32,
            icon: Icons.forum,
            iconContainerColor: AppColors.primary.withValues(alpha: 0.10),
            title: 'Xã hội',
            subtitle: 'Social & Chat',
          ),
          _MoodTile(
            width: tileWidth,
            height: 192,
            icon: Icons.lightbulb,
            iconContainerColor: AppColors.tertiary.withValues(alpha: 0.10),
            title: 'Sáng tạo',
            subtitle: 'Creative Energy',
          ),
        ],
      ),
    );
  }
}

class _MoodTile extends StatelessWidget {
  const _MoodTile({
    required this.width,
    required this.height,
    required this.icon,
    required this.iconContainerColor,
    required this.title,
    required this.subtitle,
    this.topOffset = 0,
  });

  final double width;
  final double height;
  final double topOffset;
  final IconData icon;
  final Color iconContainerColor;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, topOffset),
      child: SizedBox(
        width: width,
        height: height,
        child: Material(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: iconContainerColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Icon(icon, color: AppColors.onSurface, size: 24),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontFamily: 'Plus Jakarta Sans',
                          color: AppColors.onSurface,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color:
                              AppColors.onSurfaceVariant.withValues(alpha: 0.7),
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewSection extends StatelessWidget {
  const _PreviewSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBNlSY_rEHOhhWVnZ6QW5b53olsWZvF7G2fcu8ITdod5nhjDubrgaEDkxlhTQEt0bGp3vygwgQlaAqTDbw0Ag_cVC0nw35cHORTBdboo082p1Yc1cjpgMjYAAOxputQSpYhHmKuZqpvsM9LxMeseNPd_LZ0A9aBlPmXUsyd7jdD8R2BAh5DvKQ7Oo4XI0RuJ0ymMkNJe0NLA3t2HefvWusxnn3Pifqh7x7e2h-nN1Ba5dB1zQV7LiU68zM8v6yYgxs-8Vmz3jof7mkl',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                return Container(
                  width: 80,
                  height: 80,
                  color: AppColors.primaryFixed,
                  alignment: Alignment.center,
                  child: const Icon(Icons.local_cafe, color: AppColors.primary),
                );
              },
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gợi ý tâm trạng',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.tertiary,
                        fontFamily: 'Inter',
                        fontSize: 10,
                        letterSpacing: 0.2,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '"Một góc nhỏ yên tĩnh với hương cà phê rang mộc..."',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurface,
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
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

class _FooterActions extends StatelessWidget {
  const _FooterActions();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const OnboardingFourPage(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColors.primaryContainer,
            foregroundColor: AppColors.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: const StadiumBorder(),
            textStyle: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          child: const Text('Tiếp Tục'),
        ),
        const SizedBox(height: 14),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: AppColors.secondary,
            textStyle: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          child: const Opacity(
            opacity: 0.6,
            child: Text('Bỏ qua'),
          ),
        ),
      ],
    );
  }
}

class _AmbientBackdrop extends StatelessWidget {
  const _AmbientBackdrop();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: AppColors.surface),
        const Positioned(
          top: -96,
          right: -96,
          child: _GlowOrb(size: 256, color: Color(0x0D364224)),
        ),
        const Positioned(
          left: -128,
          top: 280,
          child: _GlowOrb(size: 320, color: Color(0x0D553722)),
        ),
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 36, sigmaY: 36),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}
