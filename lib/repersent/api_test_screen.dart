import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_x/model/book_model.dart';
import 'package:http/http.dart' as http;

class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({super.key});

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  // List tạo 1 danh sách các đối tượng
  // Book là model đã định nghĩa
  // books  là danh sách chứa nhiều Book
  // Khi ApiTestScreen khởi tạo, books sẽ ngay lập tức nhận dữ liệu từ getBooks().
  Future<List<Book>> booksFuture = getBooks();
  
  // static nghĩa là hàm ko cần tạo đối tượng mới gọi được
  // Hàm này được dùng để tạo dữ liệu mẫu hoặc đọc dữ liệu từ API
  // static List<Book> getBooks() {


   static Future <List<Book>> getBooks() async {
    const url = 'http://10.0.2.2:3000/Book';
    final response = await http.get(Uri.parse(url));

    final body = json.decode(response.body);
    print('response body: $body');
    // data.map()Duyệt qua từng phần tử trong danh sách data.
    // Book.fromJson: Gọi hàm fromJson của model Book để chuyển mỗi phần tử (Map) thành một đối tượng Book.
    // Xác định kiểu dữ liệu kết quả mong muốn là Book.
    // toList() Biến kết quả từ dạng Iterable<Book> thành List<Book> (danh sách thực sự).
    return body.map<Book>(Book.fromJson).toList();
  }
   
      Widget buildBook(List<Book> books) =>ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];

          return Card(
            child: ListTile(
              title: Text(book.name),
              subtitle: Text(book.genre),
            ),
          );
        },
      );
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JSON Data'),
      ),
      body: Center(
        child: FutureBuilder(
          future: booksFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              final books = snapshot.data!;

              return buildBook(books);
            } else {
              return const Text('No book data');
            }
          }
        ),
      ) 
    );
  }
}