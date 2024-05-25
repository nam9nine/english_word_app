class Word {
  final int id;
  final String name;
  final String meaning;
  final String category;
  String? is_wrong;
  Word({required this.id, required this.name, required this.meaning, required this.category, this.is_wrong});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'meaning': meaning,
      'category': category,
      'is_wrong' : is_wrong,
    };
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
        id: map['id'],
        name: map['name'],
        meaning: map['meaning'],
        category: map['category'],
        is_wrong: map['is_wrong'],
    );
  }
}
