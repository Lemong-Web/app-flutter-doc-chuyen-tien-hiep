import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_kiemhiep/repersentation/screens/detail_screen.dart';

class Bookshelf extends StatefulWidget {
  const Bookshelf({super.key});

  @override
  State<Bookshelf> createState() => _BookshelfState();
}

class _BookshelfState extends State<Bookshelf> {
  final ScrollController _scrollController = ScrollController();
  final int _itemsPerPage = 9;
  int _currentMax = 9;
  bool _isLoading = false;

  List<Map<String, dynamic>> allItems = [];

  @override
  void initState() {
    super.initState();
    _loadJsonData();
  }

  Future<void> _loadJsonData() async {
    final String response = await rootBundle.loadString('assets/data/stories.json');
    final List<dynamic> data = json.decode(response);

    setState(() {
      allItems = data.map((e) => Map<String, dynamic>.from(e)).toList();
    });
  }

  void _loadMoreItem() async {
    if (_isLoading) return;
    if (_currentMax >= allItems.length) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 1));



    setState(() {
      _currentMax = (_currentMax + _itemsPerPage > allItems.length)
          ? allItems.length
          : _currentMax + _itemsPerPage;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset('assets/image/wallpaper.jpg', fit: BoxFit.cover),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 70),
                child: Center(
                  child: Text(
                    'Truyện Tiên Hiệp Hay',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 70),
                child: IconButton(
                  onPressed: () {
                   Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.yellow),
                ),
              ),
            ],
          ),

          Expanded(
            child: allItems.isEmpty
            ? const Center(
               child: CircularProgressIndicator(
                color: Colors.black,
               ),
            ) 
            : NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent - 200 &&
                    !_isLoading) {
                  _loadMoreItem();
                }
                return true;
              },
              child: GridView.builder(
                controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.6,
                ),
                itemCount: _currentMax,
                itemBuilder: (context, index) {
                  final item = allItems[index];
                  return Row1Widet(
                    image: item['image']!,
                    bottomTitle: item['title']!,
                    chapters: item['chapters']!,
                    summary: item['summary'] ?? 'Tóm tắt đang được cập nhật',
                    author: item['author'] ?? 'Sưu Tầm Thể Loại', 
                    content: item['content'] ?? [],
                    
                  );
                },
              ),
            ),
          ),
          if (_isLoading)
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(color: Colors.black),
              ),
            ),
        ],
      ),
    );
  }
}

class Row1Widet extends StatelessWidget {
  final String image;
  final String bottomTitle;
  final String chapters;
  final String summary;
  final String author;
  final List<dynamic> content;


  const Row1Widet({
    super.key,
    required this.image,
    required this.bottomTitle,
    required this.chapters,
    required this.summary, 
    required this.author, required this.content, 
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailScreen(
                image: image,
                title: bottomTitle,
                chapterNumbers: chapters,
                summary: summary,
                author: author,
                content: content
              )),
            );
          },
          child: Image.asset(image, width: 100, height: 150, fit: BoxFit.cover),
        ),
        Text(bottomTitle, style: TextStyle(color: Colors.black)),
        Text(chapters, style: TextStyle(color: Colors.black)),
      ],
    );
  }
}
