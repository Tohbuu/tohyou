import 'package:flutter/material.dart';

import '../../../core/design/app_colors.dart';
import '../../../core/design/app_radius.dart';
import '../../../core/design/app_spacing.dart';
import '../../../core/design/app_typography.dart';
import '../../../core/design/components/tohyou_button.dart';
import '../../../core/design/components/tohyou_chip.dart';
import '../../../core/design/components/tohyou_icon_button.dart';
import '../../../core/design/components/tohyou_poster_card.dart';
import '../../../core/design/components/tohyou_section.dart';
import '../../../core/design/components/tohyou_surface.dart';

class ShowcaseScreen extends StatelessWidget {
  const ShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 700;

            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.all(
                    isCompact
                        ? TohyouSpacing.lg
                        : TohyouSpacing.xxl,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _buildHeader(context, isCompact),
                  ),
                ),

                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isCompact
                        ? TohyouSpacing.lg
                        : TohyouSpacing.xxl,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _buildHero(context, isCompact),
                  ),
                ),

                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    isCompact
                        ? TohyouSpacing.lg
                        : TohyouSpacing.xxl,
                    TohyouSpacing.xxl,
                    isCompact
                        ? TohyouSpacing.lg
                        : TohyouSpacing.xxl,
                    0,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: TohyouSection(
                      title: 'Continue Watching',
                      subtitle: 'Pick up where you left off',
                      onMore: () {},
                      child: _buildPosterRow(
                        context,
                        _continueWatching,
                      ),
                    ),
                  ),
                ),

                SliverPadding(
                  padding: EdgeInsets.all(
                    isCompact
                        ? TohyouSpacing.lg
                        : TohyouSpacing.xxl,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: TohyouSection(
                      title: 'Recently Added',
                      subtitle: 'New titles in your environment',
                      onMore: () {},
                      child: _buildPosterRow(
                        context,
                        _recentlyAdded,
                      ),
                    ),
                  ),
                ),

                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    isCompact
                        ? TohyouSpacing.lg
                        : TohyouSpacing.xxl,
                    0,
                    isCompact
                        ? TohyouSpacing.lg
                        : TohyouSpacing.xxl,
                    TohyouSpacing.xxxl,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _buildPrimitiveShowcase(context),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isCompact,
  ) {
    return Row(
      children: [
        Text(
          'TOHYOU',
          style: TohyouTypography.title.copyWith(
            color: TohyouColors.textPrimary,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),

        const Spacer(),

        if (!isCompact)
          const TohyouIconButton(
            icon: Icons.search,
            tooltip: 'Search',
            onPressed: null,
          ),

        const TohyouIconButton(
          icon: Icons.notifications_none,
          tooltip: 'Notifications',
          onPressed: null,
        ),

        const TohyouIconButton(
          icon: Icons.settings_outlined,
          tooltip: 'Settings',
          onPressed: null,
        ),
      ],
    );
  }

  Widget _buildHero(
    BuildContext context,
    bool isCompact,
  ) {
    return TohyouSurface(
      padding: EdgeInsets.all(
        isCompact
            ? TohyouSpacing.xl
            : TohyouSpacing.xxl,
      ),
      color: TohyouColors.surfaceElevated,
      child: isCompact
          ? _buildCompactHero()
          : _buildDesktopHero(),
    );
  }

  Widget _buildDesktopHero() {
    return Row(
      children: [
        Expanded(
          child: _heroText(),
        ),

        const SizedBox(width: TohyouSpacing.xxl),

        const _HeroVisual(),
      ],
    );
  }

  Widget _buildCompactHero() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _heroText(),

        const SizedBox(height: TohyouSpacing.xl),

        const _HeroVisual(),
      ],
    );
  }

  Widget _heroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TohyouChip(
          label: 'LOCAL-FIRST',
          icon: Icons.devices_outlined,
          accent: TohyouColors.cyan,
        ),

        const SizedBox(height: TohyouSpacing.lg),

        Text(
          'Your media.\nYour environment.',
          style: TohyouTypography.display.copyWith(
            color: TohyouColors.textPrimary,
          ),
        ),

        const SizedBox(height: TohyouSpacing.md),

        Text(
          'Anime and manga organized around you — '
          'with your library, progress, downloads, '
          'and experience living on your device.',
          style: TohyouTypography.body.copyWith(
            color: TohyouColors.textSecondary,
          ),
        ),

        const SizedBox(height: TohyouSpacing.xl),

        Row(
          children: [
            TohyouButton(
              label: 'Explore Library',
              icon: Icons.library_books_outlined,
              onPressed: () {},
            ),

            const SizedBox(width: TohyouSpacing.md),

            TohyouButton(
              label: 'Search',
              icon: Icons.search,
              secondary: true,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPosterRow(
    BuildContext context,
    List<_ShowcaseTitle> titles,
  ) {
    return SizedBox(
      height: 320,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: titles.length,
        separatorBuilder: (_, _) => const SizedBox(
          width: TohyouSpacing.lg,
        ),
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

  Widget _buildPrimitiveShowcase(BuildContext context) {
    return TohyouSurface(
      child: Wrap(
        spacing: TohyouSpacing.md,
        runSpacing: TohyouSpacing.md,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const TohyouChip(
            label: 'Watching',
            icon: Icons.play_arrow_rounded,
          ),
          const TohyouChip(
            label: 'Reading',
            icon: Icons.menu_book_outlined,
            accent: TohyouColors.cyan,
          ),
          const TohyouChip(
            label: 'Completed',
            icon: Icons.check_circle_outline,
            accent: TohyouColors.success,
          ),
          TohyouButton(
            label: 'Primary',
            onPressed: () {},
          ),
          TohyouButton(
            label: 'Secondary',
            secondary: true,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _HeroVisual extends StatelessWidget {
  const _HeroVisual();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TohyouRadius.xl),
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

class _ShowcaseTitle {
  const _ShowcaseTitle({
    required this.title,
    required this.subtitle,
    this.progress,
  });

  final String title;
  final String subtitle;
  final double? progress;
}

const _continueWatching = [
  _ShowcaseTitle(
    title: 'Frieren',
    subtitle: 'Episode 17',
    progress: 0.72,
  ),
  _ShowcaseTitle(
    title: 'Cyberpunk',
    subtitle: 'Episode 5',
    progress: 0.43,
  ),
  _ShowcaseTitle(
    title: 'Violet Evergarden',
    subtitle: 'Episode 9',
    progress: 0.61,
  ),
  _ShowcaseTitle(
    title: 'Dungeon Meshi',
    subtitle: 'Episode 14',
    progress: 0.28,
  ),
];

const _recentlyAdded = [
  _ShowcaseTitle(
    title: 'New Anime',
    subtitle: 'Added today',
  ),
  _ShowcaseTitle(
    title: 'New Manga',
    subtitle: 'Added today',
  ),
  _ShowcaseTitle(
    title: 'Library Item',
    subtitle: 'Added yesterday',
  ),
  _ShowcaseTitle(
    title: 'Another Title',
    subtitle: 'Added yesterday',
  ),
];