import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';

import '../../../core/database/app_database.dart';
import '../../../core/design/components/tohyou_button.dart';
import '../../../core/design/components/tohyou_poster_card.dart';
import '../../../core/design/components/tohyou_section.dart';
import '../../../core/design/components/tohyou_surface.dart';
import '../data/library_repository.dart';
import '../domain/library_entry.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late final AppDatabase _database;
  late final LibraryRepository _repository;

  List<LibraryEntry> _entries = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();

    _database = AppDatabase();
    _repository = LibraryRepository(_database);

    _loadLibrary();
  }

  Future<void> _loadLibrary() async {
    try {
      final entries = await _repository.getLibrary();

      if (!mounted) {
        return;
      }

      setState(() {
        _entries = entries;
        _loading = false;
        _error = null;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _loading = false;
        _error = error.toString();
      });
    }
  }

  Future<void> _addTestMedia() async {
    try {
      final now = DateTime.now();

      final mediaId = await _database.into(_database.mediaTable).insert(
            MediaTableCompanion.insert(
              title: 'Frieren: Beyond Journey\'s End',
              type: 'anime',
              description: const Value(
                'Temporary local database verification media.',
              ),
              coverUrl: const Value(null),
              sourceId: const Value('local-test-frieren'),
              sourceName: const Value('local'),
              createdAt: now,
              updatedAt: now,
            ),
          );

      await _repository.addToLibrary(
        mediaId: mediaId,
        status: 'watching',
        progress: 3,
        total: 28,
      );

      await _loadLibrary();
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add media: $error'),
        ),
      );
    }
  }

  Future<void> _removeEntry(LibraryEntry entry) async {
    final removed = await _repository.removeFromLibrary(entry.id);

    if (!removed) {
      return;
    }

    await _loadLibrary();
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TohyouSurface(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TohyouSection(
              title: 'Library',
              subtitle: 'Your local anime and manga collection.',
              child: Align(
                alignment: Alignment.centerRight,
                child: TohyouButton(
                  label: 'Add Test Media',
                  icon: Icons.add,
                  onPressed: _loading ? null : _addTestMedia,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Text(
          'Unable to load your library.\n\n$_error',
          textAlign: TextAlign.center,
        ),
      );
    }

    if (_entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.library_books_outlined,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Your library is empty.',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Add media to begin building your local collection.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        mainAxisExtent: 360,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _entries.length,
      itemBuilder: (context, index) {
        final entry = _entries[index];

        return _LibraryCard(
          entry: entry,
          onRemove: () => _removeEntry(entry),
        );
      },
    );
  }
}

class _LibraryCard extends StatelessWidget {
  const _LibraryCard({
    required this.entry,
    required this.onRemove,
  });

  final LibraryEntry entry;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            children: [
              TohyouPosterCard(
                title: entry.title,
                subtitle: entry.type.toUpperCase(),
                imageUrl: entry.coverUrl,
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  tooltip: 'Remove from library',
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          entry.status.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: entry.total == null || entry.total == 0
              ? null
              : entry.progress / entry.total!,
        ),
        const SizedBox(height: 4),
        Text(
          entry.total == null
              ? '${entry.progress}'
              : '${entry.progress} / ${entry.total}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}