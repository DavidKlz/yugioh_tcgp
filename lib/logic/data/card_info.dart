import 'card_set.dart';

class CardInfo {
  int id;
  String name;
  List<String>? typeline;
  String type;
  String humanReadableCardType;
  String desc;
  String? race;
  int? atk;
  int? def;
  int? level;
  String? attribute;
  List<CardSet> cardSets;
  String imageUrl;
  String thumbUrl;

  CardInfo({
    required this.id,
    required this.name,
    required this.typeline,
    required this.type,
    required this.humanReadableCardType,
    required this.desc,
    required this.race,
    required this.atk,
    required this.def,
    required this.level,
    required this.attribute,
    required this.cardSets,
    required this.imageUrl,
    required this.thumbUrl,
  });

  factory CardInfo.fromJson(Map<String, dynamic> json) => CardInfo(
        id: json["id"],
        name: json["name"],
        typeline: json["typeline"] != null ? (json["typeline"] as List<dynamic>).map((e) => e.toString()).toList() : [],
        type: json["type"],
        humanReadableCardType: json["humanReadableCardType"],
        desc: json["desc"],
        race: json["race"],
        atk: json["atk"],
        def: json["def"],
        level: json["level"],
        attribute: json["attribute"],
        cardSets: (json["card_sets"] as List<dynamic>).map((e) => CardSet.fromJson(e)).toList(),
        imageUrl: (json["card_images"] as List<dynamic>).first["image_url"],
        thumbUrl: (json["card_images"] as List<dynamic>).first["image_url_small"],
      );
}
