class BookModel {
  final String? id;
  final String author;
  final String title;
  final String year;

  BookModel({
    this.id,
    required this.author,
    required this.title,
    required this.year,
  });

  static BookModel fromMap({required Map<String, dynamic> map}) {
    return BookModel(
      id: map['_id'],
      author: map['author'] ?? '',
      title: map['title'] ?? '',
      year: map['year'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'author': author,
      'title': title,
      'year': year,
    };
  }
}
