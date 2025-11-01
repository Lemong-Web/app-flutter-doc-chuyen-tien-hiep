import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_kiemhiep/repersentation/screens/listening_screen.dart';

class ReadingScreen extends StatefulWidget {
  final String chaptersID;
  final String contentText;
  final String author;
  final List content;
  final int initialPage;
  final String image;
  final String title;


  const ReadingScreen({
    super.key,
    required this.chaptersID, 
    required this.contentText,
    required this.author, required this.content, required this.initialPage, required this.image, required this.title,  
  });

  

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double fontSize = 14;
  double lineHeight = 1.5;
  Color currentBackground = Colors.white;
  String currentFont = 'Roboto'; 
  int _currentIndex = 0;
  PageController?_pageController;
  List<String> chapterTexts= [];

  void changeColorBlue() {
    setState(() {
       currentBackground = currentBackground == Colors.blue ? Colors.white : Colors.blue;

    });
  }
  void changeColorGreen() {
    setState(() {
       currentBackground = currentBackground == Colors.green ? Colors.white : Colors.green;

    });
  }
  void changeColorOrange() {
    setState(() {
       currentBackground = currentBackground == Colors.orange ? Colors.white : Colors.orange;

    });
  }
  void changeColorGrey() {
    setState(() {
       currentBackground = currentBackground == Colors.grey ? Colors.white : Colors.grey;

    });
  }
  void changeColorBrown() {
    setState(() {
       currentBackground = currentBackground == Colors.brown ? Colors.white : Colors.brown;

    });
  }

   // ignore: non_constant_identifier_names
  void _IncreseaFontSize() {
    setState(() {
      fontSize++;
    });
  }
  
  // ignore: non_constant_identifier_names
  void _DecreseaFontSize() {
    setState(() {
      fontSize--;
    });
  }

   void _toggleLineSpacing() {
    setState(() {
      lineHeight++;
    });
  }
  void _toggleLineSpacingDecrese() {
    setState(() {
      lineHeight--;
    });
  }
  void _changeFontsOpenSans() {
    setState(() {
      currentFont = currentFont == 'OpenSans' ? 'Roboto' : 'OpenSans';
    });
  }
  void _changeFontsRoboto() {
    setState(() {
      currentFont = currentFont == 'Roboto' ? 'Roboto' : 'Roboto';
    });
  }
  void _changeFontsBitcoin() {
    setState(() {
      currentFont = currentFont == 'BitcountGridSingle' ? 'Roboto' : 'BitcountGridSingle';
    });
  }
  void _changeFontsMontserrat() {
    setState(() {
      currentFont = currentFont == 'Montserrat' ? 'Roboto' : 'Montserrat';
    });
  }

  void _openBottomSheet(BuildContext context) {
     showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          height: 450,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Back Ground', 
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  )),
                ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                   ElevatedButton(
                    onPressed: changeColorBlue,
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(18),
                      backgroundColor: Colors.blue
                    ),
                    child: Text('Aa')
                   ),
                   ElevatedButton(
                    onPressed: changeColorGreen,
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(18),
                      backgroundColor: Colors.green
                    ),
                    child: Text('Aa')
                  ),
                  ElevatedButton(
                    onPressed: changeColorOrange,
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(18),
                      backgroundColor: Colors.orange
                    ),
                    child: Text('Aa')
                  ),
                  ElevatedButton(
                    onPressed: changeColorGrey,
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(18),
                      backgroundColor: Colors.grey
                    ),
                    child: Text('Aa')
                  ),
                  ElevatedButton(
                    onPressed: changeColorBrown,
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(18),
                      backgroundColor: Colors.brown
                    ),
                    child: Text('Aa')
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Cỡ Chữ', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 80), 
                  IconButton(onPressed: _IncreseaFontSize, icon: Icon(Icons.add)),
                  SizedBox(width: 80),
                  IconButton(onPressed: _DecreseaFontSize, icon: Icon(Icons.remove))
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('Dãn dòng', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 70),
                  IconButton(onPressed: _toggleLineSpacing, icon: Icon(Icons.add)),
                  SizedBox(width: 70),
                  IconButton(onPressed: _toggleLineSpacingDecrese, icon: Icon(Icons.remove))
                ],
              ),
              SizedBox(height: 10),
              Align (
                alignment: Alignment.centerLeft,
                child: Text('Font Chữ', style: TextStyle(fontWeight: FontWeight.bold))
              ),
              Row(
                children: [
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: _changeFontsRoboto,
                        style: ElevatedButton.styleFrom(
                          elevation: 0 
                        ),
                        child: Text('ROBOTO')
                      ),
                      ElevatedButton(
                        onPressed: _changeFontsOpenSans,
                        style: ElevatedButton.styleFrom(
                          elevation: 0 
                        ),
                        child: Text('Open Sans'),
                      
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: _changeFontsBitcoin,
                        style: ElevatedButton.styleFrom(
                          elevation: 0 
                        ),
                        child: Text('BitcountGridSingle')
                      ),
                      ElevatedButton(
                        onPressed: _changeFontsMontserrat,
                        style: ElevatedButton.styleFrom(
                          elevation: 0 
                        ),
                        child: Text('Montserrat')
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        );
      }
    );
  }

    @override
    void initState() {
      super.initState();
      _pageController = PageController(initialPage: widget.initialPage);
      _loadAllChapter();
    }
  
  Future<void> _loadAllChapter() async {
    for (var chapter in widget.content) {
      final text = await rootBundle.loadString(chapter['chaptersContent']);
      chapterTexts.add(text);
    }
    setState(() {});
  }


  @override
  Widget build(BuildContext context) => Scaffold(
     key: _scaffoldKey,
    // Tránh lỗi range error
     body: chapterTexts.isEmpty
     ? const Center(child: CircularProgressIndicator()) 
     : PageView.builder(
      controller: _pageController,
      itemCount: widget.content.length,
      itemBuilder: (context, index) {
        final chapter = widget.content[index];
        return Scaffold(
          backgroundColor: currentBackground,
          body: Column(
          children: [
            SafeArea(
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back
                  )
                ),
                SizedBox(width: 80),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TRUYỆN TIÊN HIỆP' ,style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    Text('Tác Giả: ${widget.author}')
                    ],
                  ),
                  SizedBox(width: 80),
                ]
              ),
            ),

            Align (
              alignment: AlignmentGeometry.centerLeft,
              child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text('Chương:  ${chapter['chaptersID']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            ),  
            ),
            Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Text(
                  chapterTexts[index],
                  style: TextStyle(
                    fontSize: fontSize,
                    height: lineHeight,
                    fontFamily: currentFont,
                  )),
                ),
              ),
            ),

            BottomNavigationBar(
              currentIndex: _currentIndex,
               onTap: (index) async{
                setState(() {
                  _currentIndex = index;
                });
                
                if (index == 0) {
                  _scaffoldKey.currentState?.openDrawer();
                }
                if (index == 1)  {
                  // _pageController cố đọc index của trang hiện tại
                  // ? null-aware operator
                  // round chuyển sô
                  // ?? widget.initialPage đề phong trường hợp Null
                  final currentPage = _pageController?.page?.round() ?? widget.initialPage;
                  final content = widget.content[index];
                  String  contentText  =  await rootBundle.loadString(content['chaptersContent']);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ListeningScreen(
                    chaptersID: content['chaptersID'],
                    contentText: contentText,
                    author: widget.author, 
                    initialPage: currentPage, 
                    image: widget.image, 
                    title: widget.title, 
                    content: widget.content
                      )
                  ));
                }
                if (index == 2) {
                  _openBottomSheet(context);
                } 
              },
              items: const [
                
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: 'List',
                ),
                 BottomNavigationBarItem(
                  icon: Icon(Icons.mic),
                  label: 'List',
                  
                ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.pan_tool),
                    label: 'Option'
                  ),
                ]
              )
            ]
          )
        );
      }
    ),
     drawer: Drawer(
        width: 300,
        child: Column(
          children: [
            SizedBox(
              height: 80,
              child: const DrawerHeader(
                decoration: BoxDecoration(
                ),
                child: Text('Danh sách chương')
              ),
            ),
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
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ReadingScreen(
                      chaptersID: content['chaptersID'],
                      contentText: contentText,
                      content: widget.content,
                      author: widget.author,
                      initialPage: index,
                      image: widget.image,
                      title: widget.title,
                      )));
                    }
                  );
                }
              )
            )
          ]
        ),
      )
    );
  }

