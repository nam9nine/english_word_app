class Word {
  final int id;
  final String english;
  String? meaning;
  final String category;
  bool isWrong = false;

  Word({required this.id, required this.english, this.meaning, required this.category, required this.isWrong});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'english': english,
      'meaning': meaning,
      'category': category,
      'isWrong': isWrong ? 1 : 0,
    };
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      id: map['id'],
      english: map['english'],
      meaning: map['meaning'],
      category: map['category'],
      isWrong: map['isWrong'] == 1,
    );
  }
}