final class HitsterSongUrl {
  static final regex = RegExp('www.hitstergame.com/[a-z]{2}/[0-9]{5}');

  late String url;
  late String id;
  late String regionCode;

  HitsterSongUrl._(
      {required this.url, required this.id, required this.regionCode});

  factory HitsterSongUrl.parse(String url) {
    if (!regex.hasMatch(url)) {
      throw "Invalid url provided. Expected: ${regex.pattern} / Actual: $url";
    }

    final hitsterUrlParts = url.split("/");
    final id = hitsterUrlParts[2];
    final regionCode = hitsterUrlParts[1];
    return HitsterSongUrl._(url: url, id: id, regionCode: regionCode);
  }
}
