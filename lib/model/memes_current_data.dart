class MemeData {
  late List<Meme> memes;

  MemeData({
    required this.memes,
  });

  factory MemeData.fromJson(Map<String, dynamic> json) {
    return MemeData(
      memes: List<Meme>.from(json['memes'].map((x) => Meme.fromJson(x))),
    );
  }
}

class Meme {
  late String id;
  late String name;
  late String url;
  late int width;
  late int height;
  late int boxCount;
  late int captions;

  Meme({
    required this.id,
    required this.name,
    required this.url,
    required this.width,
    required this.height,
    required this.boxCount,
    required this.captions,
  });

  factory Meme.fromJson(Map<String, dynamic> json) {
    return Meme(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      width: json['width'],
      height: json['height'],
      boxCount: json['box_count'],
      captions: json['captions'],
    );
  }
}
