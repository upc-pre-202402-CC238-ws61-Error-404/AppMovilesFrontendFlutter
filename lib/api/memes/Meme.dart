class Meme {
  String postLink;
  String subreddit;
  String title;
  String url;
  bool nsfw;
  bool spoiler;
  String author;
  int ups;
  List<String> preview;

  Meme({
    required this.postLink,
    required this.subreddit,
    required this.title,
    required this.url,
    required this.nsfw,
    required this.spoiler,
    required this.author,
    required this.ups,
    required this.preview,
  });

  factory Meme.fromJson(Map<String, dynamic> json) {
    return Meme(
      postLink: json['postLink'],
      subreddit: json['subreddit'],
      title: json['title'],
      url: json['url'],
      nsfw: json['nsfw'],
      spoiler: json['spoiler'],
      author: json['author'],
      ups: json['ups'],
      preview: List<String>.from(json['preview']),
    );
  }
}
