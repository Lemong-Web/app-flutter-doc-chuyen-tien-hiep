
// Model là một bản mô tả cấu trúc dữ liệu (data structure)
// Là cách lập trình viên nói với Flutter, dữ liệu của tôi trông như thế này
// Có Model rồi thì có thể truyền dũ liệu kiểu này

// Book book = Book.fromJson(json);
// print(book.name);

class Book {
  final String name;
  final String genre;

  const Book({
    required this.name,
    required this.genre
  });

  static Book fromJson(json) => Book(
    name: json['name'],
    genre: json['genre']
  );
}


