import 'package:appmovilesfrontendflutter/api/memes/Meme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
/**
 * {
    "postLink": "https://redd.it/1gpmmyt",
    "subreddit": "dankmemes",
    "title": "God works in mysterious ways... (or maybe it's my mind!)",
    "url": "https://i.redd.it/zswn1vfdjh0e1.png",
    "nsfw": false,
    "spoiler": false,
    "author": "bluebutterfly_13",
    "ups": 42,
    "preview": [
    "https://preview.redd.it/zswn1vfdjh0e1.png?width=108&crop=smart&auto=webp&s=2723b29672c2209247ec4925241eb4cfe1e97eb1",
    "https://preview.redd.it/zswn1vfdjh0e1.png?width=216&crop=smart&auto=webp&s=a257257511dae88be503975661e086c5ef60f8da",
    "https://preview.redd.it/zswn1vfdjh0e1.png?width=320&crop=smart&auto=webp&s=1953c2aba8a2b7b512ce924c79b7e6d28616477d",
    "https://preview.redd.it/zswn1vfdjh0e1.png?width=640&crop=smart&auto=webp&s=02738d25678cb66d7eb194955a879a9c23cff03e",
    "https://preview.redd.it/zswn1vfdjh0e1.png?width=960&crop=smart&auto=webp&s=59a928037601c5a4da92242758c3188934e72869",
    "https://preview.redd.it/zswn1vfdjh0e1.png?width=1080&crop=smart&auto=webp&s=9b1c3c2a1487a9192fdf2cf2503b57d9b7a96604"
    ]
    }
 */
class MemeService{

  Future<Meme> getMeme() async{
    final response = await http.get(Uri.parse('https://meme-api.com/gimme'),);

    if (response.statusCode == 200) {
      final Map< String,dynamic> jsonMap = json.decode(response.body);
      return Meme.fromJson(jsonMap);
    } else {
      print('Failed to get meme. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load meme');
    }

  }

}