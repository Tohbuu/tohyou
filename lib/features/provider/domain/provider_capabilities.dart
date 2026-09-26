class ProviderCapabilities {
  const ProviderCapabilities({
    this.search = false,
    this.details = false,
    this.episodes = false,
    this.streaming = false,
    this.chapters = false,
    this.pages = false,
  });

  final bool search;
  final bool details;
  final bool episodes;
  final bool streaming;
  final bool chapters;
  final bool pages;
}