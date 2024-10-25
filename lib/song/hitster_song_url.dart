final class HitsterSongUrl {
  static final gameVersions = HitsterGame.allVersions();

  late String url;
  late String id;
  late String regionCode;
  late HitsterGameVersion version;

  HitsterSongUrl._(
      {required this.url,
      required this.id,
      required this.regionCode,
      required this.version});

  factory HitsterSongUrl.parse(String url) {
    for (var version in gameVersions) {
      if (version.regex.hasMatch(url)) {
        return extractFromUrl(url, version.version);
      }
    }
    throw "Invalid url provided.";
  }

  static HitsterSongUrl extractFromUrl(String url, HitsterGameVersion version) {
    final hitsterUrlParts = url.split("/");
    final regionCode = hitsterUrlParts[1];
    final id = hitsterUrlParts[hitsterUrlParts.length - 1];
    return HitsterSongUrl._(
        url: url, id: id, regionCode: regionCode, version: version);
  }
}

class HitsterGame {
  RegExp regex;
  HitsterGameVersion version;
  HitsterGame._(this.regex, this.version);

  factory HitsterGame.frV1() => HitsterGame._(
      RegExp("www.hitstergame.com/[a-z]{2}/[0-9]{5}"), HitsterGameVersion.frV1);
  factory HitsterGame.frV2() => HitsterGame._(
      RegExp("www.hitstergame.com/[a-z]{2}/[a-z]{4}[0-9]{4}/[0-9]{5}"),
      HitsterGameVersion.frV2);

  static List<HitsterGame> allVersions() => [
        HitsterGame.frV1(),
        HitsterGame.frV2(),
      ];
}

enum HitsterGameVersion { frV1, frV2 }
