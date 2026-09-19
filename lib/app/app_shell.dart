import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/design/app_colors.dart';
import '../core/design/app_motion.dart';
import '../core/design/app_spacing.dart';

class TohyouAppShell extends StatelessWidget {
  const TohyouAppShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  void _goToBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 700;

        if (isCompact) {
          return _buildMobileLayout();
        }

        return _buildDesktopLayout();
      },
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _goToBranch,
        backgroundColor: TohyouColors.surface,
        indicatorColor: TohyouColors.accent.withValues(
          alpha: 0.16,
        ),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.library_books_outlined),
            selectedIcon: Icon(Icons.library_books),
            label: 'Library',
          ),
          NavigationDestination(
            icon: Icon(Icons.download_outlined),
            selectedIcon: Icon(Icons.download),
            label: 'Downloads',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Row(
        children: [
          _DesktopSidebar(
            currentIndex: navigationShell.currentIndex,
            onSelected: _goToBranch,
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: TohyouMotion.normal,
              switchInCurve: TohyouMotion.curve,
              child: navigationShell,
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopSidebar extends StatelessWidget {
  const _DesktopSidebar({
    required this.currentIndex,
    required this.onSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onSelected;

  static const _items = [
    (
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: 'Home',
    ),
    (
      icon: Icons.search_outlined,
      selectedIcon: Icons.search,
      label: 'Search',
    ),
    (
      icon: Icons.library_books_outlined,
      selectedIcon: Icons.library_books,
      label: 'Library',
    ),
    (
      icon: Icons.download_outlined,
      selectedIcon: Icons.download,
      label: 'Downloads',
    ),
    (
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      label: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      color: TohyouColors.surface,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: TohyouSpacing.lg),

            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: TohyouColors.accent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: TohyouSpacing.xxl),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: TohyouSpacing.md,
                ),
                itemCount: _items.length,
                separatorBuilder: (_, _) => const SizedBox(
                  height: TohyouSpacing.sm,
                ),
                itemBuilder: (context, index) {
                  final item = _items[index];
                  final selected = currentIndex == index;

                  return _SidebarItem(
                    icon: selected
                        ? item.selectedIcon
                        : item.icon,
                    label: item.label,
                    selected: selected,
                    onTap: () => onSelected(index),
                  );
                },
              ),
            ),

            const SizedBox(height: TohyouSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.selected || _hovered;

    return Tooltip(
      message: widget.label,
      waitDuration: const Duration(milliseconds: 500),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: TohyouMotion.fast,
            curve: TohyouMotion.curve,
            height: 58,
            decoration: BoxDecoration(
              color: active
                  ? TohyouColors.surfaceHighlight
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Icon(
                widget.icon,
                color: widget.selected
                    ? TohyouColors.accent
                    : TohyouColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}