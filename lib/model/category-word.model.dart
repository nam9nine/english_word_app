class Word {
  final int id;
  final String english;
  String? meaning;
  final String category;
  bool is_wrong = false;

  Word({required this.id, required this.english, this.meaning, required this.category, required this.is_wrong});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'english': english,
      'meaning': meaning,
      'category': category,
      'is_wrong': is_wrong ? 1 : 0,
    };
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      id: map['id'],
      english: map['english'],
      meaning: map['meaning'],
      category: map['category'],
      is_wrong: map['is_wrong'] == 1,
    );
  }
}