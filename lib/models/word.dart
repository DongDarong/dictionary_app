class Word {
  final int id;
  final String englishWord;
  final String partOfSpeech;
  final String englishPhonetic;
  final String khmerPhonetic;
  final String khmerDef;

  Word({
    required this.id,
    required this.englishWord,
    required this.partOfSpeech,
    required this.englishPhonetic,
    required this.khmerPhonetic,
    required this.khmerDef,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'],
      englishWord: json['englishWord'],
      partOfSpeech: json['partOfSpeech'],
      englishPhonetic: json['englishPhonetic'],
      khmerPhonetic: json['khmerPhonetic'],
      khmerDef: json['khmerDef'],
    );
  }
}
