import 'anime.dart';
import 'episode.dart';
import 'provider.dart';
import 'stream_source.dart';

abstract interface class AnimeProvider implements Provider {
  Future<List<Anime>> search(String query);

  Future<Anime?> getDetails(String id);

  Future<List<Episode>> getEpisodes(String animeId);

  Future<List<StreamSource>> getStreams(String episodeId);
}
