
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_kiemhiep/repersentation/screens/reading_screen.dart';
import 'package:flutter_application_kiemhiep/repersentation/widgets/dash_line_widget.dart';

class DetailScreen extends StatefulWidget {
  final String image;
  final String title;
  final String chapterNumbers;
  final String summary;
  final String author;
  final List content;

  const DetailScreen({
     super.key,
     required this.image,
     required this.title,
     required this.chapterNumbers,
     required this.summary,
     required this.author,
     required this.content,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String summaryContent = 'Đang tải tóm tăt..';
  List<Map<String, dynamic>> content = [];

  @override
  void initState() {
    super.initState();
    _loadSummary();
    _loadChapterId();
  }

  Future<void> _loadSummary() async {
    try {
      final String response = await rootBundle.loadString(widget.summary);
      setState(() {
        summaryContent = response;
      });
    } catch (e) {
      setState(() {
        summaryContent = 'Không thể tải tóm tắt truyện';
      });
    }
  }
  
  void _loadChapterId() {
    setState(() {
      content = List<Map<String, dynamic>>.from(widget.content);
    });
  }
 
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/image/wallpaper.jpg',
                 fit: BoxFit.cover
              ),
              IconButton(
                onPressed: (){
                    Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: Row(
                  children: [
                    SizedBox(width: 80,),
                    Image.asset(
                      width: 100,
                      height: 150,
                      widget.image,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 20),
                    Column(
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          )
                        ),
                        SizedBox(height: 30),
                        Text(
                          'Tác Giả: ${widget.author}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
            Text(
            'Giới Thiệu',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 100,
            child: SingleChildScrollView(
              child: Text(
                summaryContent
              ),
            ),
          ),

          SizedBox(height: 10),
          DashLineWidget(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: AlignmentGeometry.centerLeft,
              child: Text(
                "Tổng Số Chương: ${widget.chapterNumbers}"
              ),
            ),
          ),
        
        
          DashLineWidget(),
          Expanded(
            child: ListView.builder(
              itemCount: widget.content.length,
              itemBuilder: (context, index) {
                final content = widget.content[index];
                return ListTile(
                  title: Text('Chương: ${content['chaptersID']}'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () async {
                    String contentText = await rootBundle.loadString(content['chaptersContent']);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ReadingScreen(
                      chaptersID: content['chaptersID'],
                      contentText: contentText, 
                      author: widget.author, 
                      content: widget.content,
                      initialPage: index,
                      image: widget.image,
                      title: widget.title
                    ))); 
                  }
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}

