import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design/app_colors.dart';
import '../../../core/design/app_spacing.dart';
import '../../../core/design/app_typography.dart';
import '../../../core/design/components/tohyou_button.dart';
import '../../../core/design/components/tohyou_header.dart';
import '../../../core/design/components/tohyou_poster_card.dart';
import '../../../core/design/components/tohyou_section.dart';
import '../../../core/design/components/tohyou_surface.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 700;

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                compact
                    ? TohyouSpacing.lg
                    : TohyouSpacing.xxl,
                compact
                    ? TohyouSpacing.lg
                    : TohyouSpacing.xxl,
                compact
                    ? TohyouSpacing.lg
                    : TohyouSpacing.xxl,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: TohyouHeader(
                  title: 'TOHYOU',
                  subtitle: 'Your personal media environment',
                ),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.all(
                compact
                    ? TohyouSpacing.lg
                    : TohyouSpacing.xxl,
              ),
              sliver: SliverToBoxAdapter(
                child: _WelcomeSection(
                  compact: compact,
                ),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: compact
                    ? TohyouSpacing.lg
                    : TohyouSpacing.xxl,
              ),
              sliver: SliverToBoxAdapter(
                child: TohyouSection(
                  title: 'Continue Watching',
                  subtitle: 'Pick up where you left off',
                  onMore: () {},
                  child: _buildPosterRow(
                    _continueWatching,
                  ),
                ),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.all(
                compact
                    ? TohyouSpacing.lg
                    : TohyouSpacing.xxl,
              ),
              sliver: SliverToBoxAdapter(
                child: TohyouSection(
                  title: 'Recently Added',
                  subtitle: 'New titles in your environment',
                  onMore: () {},
                  child: _buildPosterRow(
                    _recentlyAdded,
                  ),
                ),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                compact
                    ? TohyouSpacing.lg
                    : TohyouSpacing.xxl,
                0,
                compact
                    ? TohyouSpacing.lg
                    : TohyouSpacing.xxl,
                TohyouSpacing.xxxl,
              ),
              sliver: SliverToBoxAdapter(
                child: _buildLibrarySummary(compact),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPosterRow(
    List<_HomeTitle> titles,
  ) {
    return SizedBox(
      height: 310,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: titles.length,
        separatorBuilder: (_, _) {
          return const SizedBox(
            width: TohyouSpacing.lg,
          );
        },
        itemBuilder: (context, index) {
          final title = titles[index];

          return TohyouPosterCard(
            title: title.title,
            subtitle: title.subtitle,
            progress: title.progress,
            onTap: () {},
          );
        },
      ),
    );
  }

  Widget _buildLibrarySummary(bool compact) {
    return TohyouSurface(
      child: Wrap(
        spacing: TohyouSpacing.xxl,
        runSpacing: TohyouSpacing.lg,
        children: const [
          _SummaryItem(
            value: '24',
            label: 'Anime',
          ),
          _SummaryItem(
            value: '37',
            label: 'Manga',
          ),
          _SummaryItem(
            value: '08',
            label: 'Watching',
          ),
          _SummaryItem(
            value: '12',
            label: 'Reading',
          ),
        ],
      ),
    );
  }
}

class _WelcomeSection extends StatelessWidget {
  const _WelcomeSection({
    required this.compact,
  });

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good evening.',
          style: TohyouTypography.headline.copyWith(
            color: TohyouColors.textPrimary,
          ),
        ),

        const SizedBox(height: TohyouSpacing.sm),

        Text(
          'Your media, your space.',
          style: TohyouTypography.body.copyWith(
            color: TohyouColors.textSecondary,
          ),
        ),

        const SizedBox(height: TohyouSpacing.xl),

        Wrap(
          spacing: TohyouSpacing.md,
          runSpacing: TohyouSpacing.md,
          children: [
            TohyouButton(
              label: 'Explore Library',
              icon: Icons.library_books_outlined,
              onPressed: () {
                context.go('/library');
              },
            ),
            TohyouButton(
              label: 'Search',
              icon: Icons.search,
              secondary: true,
              onPressed: () {
                context.go('/search');
              },
            ),
          ],
        ),
      ],
    );

    return TohyouSurface(
      padding: EdgeInsets.all(
        compact
            ? TohyouSpacing.xl
            : TohyouSpacing.xxl,
      ),
      color: TohyouColors.surfaceElevated,
      child: compact
          ? content
          : Row(
              children: [
                Expanded(
                  child: content,
                ),
                const SizedBox(
                  width: TohyouSpacing.xxl,
                ),
                const _WelcomeVisual(),
              ],
            ),
    );
  }
}

class _WelcomeVisual extends StatelessWidget {
  const _WelcomeVisual();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TohyouColors.accentDeep,
            TohyouColors.violet,
            TohyouColors.cyan,
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.auto_awesome,
          size: 56,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TohyouTypography.headline.copyWith(
            color: TohyouColors.accent,
          ),
        ),
        const SizedBox(height: TohyouSpacing.xs),
        Text(
          label,
          style: TohyouTypography.caption.copyWith(
            color: TohyouColors.textMuted,
          ),
        ),
      ],
    );
  }
}

class _HomeTitle {
  const _HomeTitle({
    required this.title,
    required this.subtitle,
    this.progress,
  });

  final String title;
  final String subtitle;
  final double? progress;
}

const _continueWatching = [
  _HomeTitle(
    title: 'Frieren',
    subtitle: 'Episode 17',
    progress: 0.72,
  ),
  _HomeTitle(
    title: 'Cyberpunk',
    subtitle: 'Episode 5',
    progress: 0.43,
  ),
  _HomeTitle(
    title: 'Violet Evergarden',
    subtitle: 'Episode 9',
    progress: 0.61,
  ),
  _HomeTitle(
    title: 'Dungeon Meshi',
    subtitle: 'Episode 14',
    progress: 0.28,
  ),
];

const _recentlyAdded = [
  _HomeTitle(
    title: 'New Anime',
    subtitle: 'Added today',
  ),
  _HomeTitle(
    title: 'New Manga',
    subtitle: 'Added today',
  ),
  _HomeTitle(
    title: 'Library Item',
    subtitle: 'Added yesterday',
  ),
  _HomeTitle(
    title: 'Another Title',
    subtitle: 'Added yesterday',
  ),
];