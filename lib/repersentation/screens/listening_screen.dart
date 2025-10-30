import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart' show FlutterTts;

class ListeningScreen extends StatefulWidget {
  final String chaptersID;
  final String contentText;
  final String author;
  final List content;
  final int initialPage;
  final String image;
  final String title;
  
  const ListeningScreen({
    super.key,
    required this.chaptersID, 
    required this.contentText, 
    required this.author, 
    required this.content, 
    required this.initialPage, 
    required this.image, required this.title});
  
  @override
  State<ListeningScreen> createState() => _ListeningScreenState();
  
}

class _ListeningScreenState extends State<ListeningScreen> {
  PageController ?_pageController;
  List<String> chapterTexts= [];
  final FlutterTts flutterTts = FlutterTts();
  int currentIndex = 0;
  int currentPosition = 0;
  int currentSentenceIndex = 0; // Lưu index câu hiện tại
  int currentCharPosition = 0; // Lưu vị trí kí tự hiện đại
  bool isPause = false; // Trạng thái pause
  double currentValue = 0.6;
  List<String> settingsvoice = ['Giọng Việt', 'Giọng Anh'];
  String ? selectedVoice = 'Giọng Việt';
  List<String> _textQueue = [];
  bool _isReading = false;

  Future<void> _speakLongText(String text, {int startPosition = 0}) async {
    await flutterTts.stop();

    String textToSpeach = startPosition > 0 ? text.substring(startPosition) : text;
    _textQueue = text.split(RegExp(r'(?<=[.!?…]) '));
    currentCharPosition = startPosition;
    _isReading = true;
    _speakNext();
  }

  void _speakNext() async {
    if (!_isReading || _textQueue.isEmpty || isPause) {
    return;
  }
  String nextSentence = _textQueue.removeAt(0);
  currentSentenceIndex++;
  // Cập nhật vị trí ký tự hiện tại
  currentCharPosition += nextSentence.length + 1; // + 1 cho khoảng trắng
  await flutterTts.speak(nextSentence);

  flutterTts.setCompletionHandler(() {
    if (mounted) {
      _speakNext();
    }
  });
}

 void _pauseSpeaking() {
  flutterTts.pause();
  isPause =true;
}
 void _resumeSpeaking() {
  if (isPause && _textQueue.isNotEmpty) {
    isPause = false;
    flutterTts.setCompletionHandler(() {
      _speakNext();
    });
    _speakNext();
  }
 }

@override
void dispose() {
  flutterTts.stop();  
  _pageController?.dispose(); 
  super.dispose();
}

void _resetPage() {
  flutterTts.stop();
  isPause = false;
  currentCharPosition = 0;
  currentSentenceIndex = 0;
  _textQueue.clear();

  final currentPage = _pageController?.page?.round() ?? widget.initialPage;
  _speakLongText(chapterTexts[currentPage], startPosition: 0);

  setState(() {
    _isReading = true;
  });
}
  void _setBaseValue (StateSetter setModalSheet) {
    setModalSheet(() {
      currentValue = 0.6;
    });
    _setSpeachRate();
  }

  void _setSpeachRate() async {
    flutterTts.setSpeechRate(currentValue);
  }


  @override
  void initState() {
      super.initState();
      _pageController = PageController(initialPage: widget.initialPage);
      currentIndex = widget.initialPage;
      isPause = false;
      currentCharPosition = 0;
      currentSentenceIndex = 0;
      _initTts();
      _loadAllChapter();
      
      flutterTts.setProgressHandler((text, start, end, word) {
         if(mounted) {
          setState(() {
            currentPosition = start;
            currentCharPosition = start;   
          });
         }
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        applyVoice();
      });
    }

  Future<void> _loadAllChapter() async {
     for (var chapter in widget.content) {
      final text = await rootBundle.loadString(chapter['chaptersContent']);
      chapterTexts.add(text);
    }
    setState(() {
      _isReading = true;
    });
    _speakLongText(chapterTexts[widget.initialPage]);
  }

  Future<void>  _initTts() async {
  }

  void applyVoice() async {
    if(selectedVoice == 'Giọng Việt') {
      await flutterTts.setLanguage('vi-VN');
    } else if (selectedVoice == 'Giọng Anh') {
      await flutterTts.setLanguage('en-US');
    }

    await flutterTts.setSpeechRate(currentValue);

    if (_isReading) {
      await flutterTts.stop();
      _speakLongText(chapterTexts[currentIndex],
      startPosition: currentCharPosition,
      );
    }

    setState(() {});
  }

  void _openBottomSheet (BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Tốc Độ: $currentValue'),
                  Slider( 
                    min: 0,
                    max: 1.0,
                    divisions: 20,
                    activeColor: Colors.green,
                    inactiveColor: Colors.green.withOpacity(0.3),
                    value: currentValue,
                    onChanged: (double newValue) {
                      setModalState ((){
                        currentValue = newValue;
                        _setSpeachRate();
                      });
                    }
                  ),
                  OutlinedButton(
                    onPressed: () {
                      _setBaseValue(setModalState);
                    },
                    child: Text('Mặc Định')
                  )
                ],
              ),
            );
          },
        );
      }
    );
  }
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back)
        ),
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _resetPage();
            },
            icon: Icon(Icons.refresh)
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => StatefulBuilder(
                  builder: (context, dialogSetState) {
                  return SimpleDialog(
                  title: const Text('Chọn giọng đọc'),
                  contentPadding: const EdgeInsets.all(20.0),
                  children: [
                    Column(
                      children: [
                        DropdownButton<String>(
                          value: selectedVoice,
                          onChanged: (v) {
                            dialogSetState(() {
                              selectedVoice = v;
                            });
                          },
                          items: settingsvoice.map<DropdownMenuItem<String>>((String voice) {
                            return DropdownMenuItem<String>(
                              value: voice,
                              child: Text(voice)
                            );
                          }). toList(),
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Hủy')
                            ),
                            ElevatedButton(
                              onPressed: () {
                                applyVoice();
                                Navigator.pop(context);
                              },
                              child: Text('Xác nhận')
                            )
                          ],
                        ),
                      ],
                    )
                  ]);        
                }
              )
            );
          },
        icon: Icon(Icons.settings_voice)
      ),
          
          Builder(
            builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();          
                },
              icon: Icon(Icons.list)
              );
            }
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: chapterTexts.isEmpty
      ? const Center(child: CircularProgressIndicator()) 
      : PageView.builder(
        controller: _pageController,
        onPageChanged: (page) async {
          setState(() {
            currentIndex = page;
          });
          
          if (_isReading) {
            await flutterTts.stop();
            isPause = false;
            currentCharPosition = 0;
            currentSentenceIndex = 0;
            _textQueue.clear();
            _speakLongText(chapterTexts[currentIndex]);
          }
        },

        itemCount: widget.content.length,
        itemBuilder: (context, index) {
          bool isLastPage = currentIndex >= widget.content.length - 1;
          bool isFirstPage = currentIndex == 0 ;
          final chapter = widget.content[index];
           return SafeArea(
            child: Stack(
              children: [
              Positioned.fill(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Image.asset(
                  widget.image,
                  fit: BoxFit.cover,
              ),
            ),
          ),
          
          Align(
            alignment: AlignmentGeometry.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Image.asset(
                widget.image,
                width: 150,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),

          Align(
            alignment: AlignmentGeometry.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 230),
              child: Text(widget.title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),

          Align(
            alignment: AlignmentGeometry.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 250),
              child: Text(
                'Chương: ${widget.content[index]['chaptersID']}',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),

              Positioned(
                top: 270,
                left: 0,
                right: 0,
                bottom: 110,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Text(chapterTexts[index], style: TextStyle( height: 2))
                  ),
                )
              ),
              
              Padding(
                padding: const EdgeInsets.only(bottom: 55),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.comment, size: 30, color: Colors.white)
                          ),
                            IconButton(
                              onPressed: () {
                                  _openBottomSheet(context);
                              },
                                icon: Icon(Icons.speed, size: 30, color: Colors.white)
                          ),  
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.share, size: 30, color: Colors.white)
                          ),
                        ],
                      ),
                    ),
                  ),
              
                Align(
                  alignment: Alignment.bottomCenter,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: isFirstPage
                            ? null
                            : () async {
                                await flutterTts.stop();
                                _pageController?.previousPage(
                                  duration: Duration(milliseconds: 300), 
                                  curve: Curves.easeInOut
                              );
                            },
                            icon: Icon(
                              Icons.arrow_circle_left,
                              size: 50,
                              color: isFirstPage ? Colors.white.withOpacity(0.3) :  Colors.white 
                            )
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (_isReading && !isPause) {
                                  _pauseSpeaking(); 
                                } else if (isPause){
                                 _resumeSpeaking();
                                } else {
                                   _speakLongText(chapterTexts[currentIndex], startPosition: currentCharPosition);
                                }
                              });
                            },
                            icon: Icon(
                              _isReading && !isPause
                              ? Icons.pause_circle
                              : (isPause ? Icons.play_circle : Icons.play_circle),
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                          
                          IconButton(
                            onPressed: isLastPage
                              ? null
                              : () async {
                                await flutterTts.stop();
                                _pageController?.nextPage(
                                  duration: Duration(milliseconds: 300 ),
                                  curve: Curves.easeInOut
                                );
                              },
                            icon: Icon(
                              Icons.arrow_circle_right,
                              size: 50,
                              color: isLastPage ? Colors.white.withOpacity(0.3) : Colors.white  
                            )
                          ),
                        ],
                      ),
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
                    title: Text('Chương ${content['chaptersID']}'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () async {
                    String contentText = await rootBundle.loadString(content['chaptersContent']);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ListeningScreen(
                      chaptersID: content['chaptersID'],
                      contentText: contentText,
                      content: widget.content,
                      author: widget.author,
                      initialPage: index,
                      image: widget.image,
                      title: widget.title,
                      )));
                    },
                  );
                }
              ) 
            )
          ],
        ),
      ),
    );
  }
}

