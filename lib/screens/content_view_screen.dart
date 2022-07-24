import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_101/model/entity/content.dart';
import 'package:flutter_101/service/content_service.dart';
import 'package:flutter_101/utils/global.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';

class ContentViewScreen extends StatefulWidget {
  const ContentViewScreen(): super();

  static const String ROUTE_ID = 'content_view_screen';

  @override
  _ContentViewScreenState createState() => _ContentViewScreenState();
}

class _ContentViewScreenState extends State<ContentViewScreen> {

  static const storage = FlutterSecureStorage();
  late VideoPlayerController _controller;

  ContentService contentService = ContentService();

  late bool firstFlag;

  late String contentName;
  late String contentDetail;
  late String imageCoverPath;
  late String currentLang;
  late String currentLangAudio;
  late String currentLangVideo;

  late AudioPlayer player;
  late bool playAudioFlag;

  late Content contentItem;

  @override
  void initState() {
    super.initState();

    firstFlag = false;

    contentName = "";
    contentDetail = "";
    imageCoverPath = "";
    currentLang = "";
    currentLangAudio = "";
    currentLangVideo = "";

    playAudioFlag = false;

    _controller = VideoPlayerController.network("");
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  onRefresh(bool isVisible) {
    if (isVisible && !firstFlag) {
      firstFlag = true;

      contentName = "";
      contentDetail = "";
      imageCoverPath = "";
      currentLang = "";
      currentLangAudio = "";
      currentLangVideo = "";

      playAudioFlag = false;

      _findByContentId();
    } else if (!isVisible) {
      firstFlag = false;
    }
  }

  _findByContentId() {
    storage.read(key: "content_id").then((value) {
      contentService.findById(int.parse(value!)).then((value) {
        setState(() {
          contentItem = value;

          contentName = value.contentName;
          contentDetail = value.contentDetail;
          imageCoverPath = value.imageCoverPath;
          currentLang = "TH";
          currentLangAudio = value.audioThPath;
          currentLangVideo = value.videoThPath;

          _playVideo();
        });
      });
    });
  }

  _onChangeLanguage(String lang){
    setState(() {
      currentLang = lang;

      _playVideo();
    });

    Navigator.of(context).pop();
  }

  _playAudio() async {
    if (currentLang == "TH") {
      currentLangAudio = contentItem.audioThPath;
    } else if (currentLang == "HMONG") {
      currentLangAudio = contentItem.audioHmongPath;
    } else if (currentLang == "KAREN") {
      currentLangAudio = contentItem.audioKarenPath;
    } else if (currentLang == "YAO") {
      currentLangAudio = contentItem.audioYaoPath;
    } else if (currentLang == "LISU") {
      currentLangAudio = contentItem.audioLisuPath;
    } else if (currentLang == "LAHU") {
      currentLangAudio = contentItem.audioLahuPath;
    } else if (currentLang == "AKHA") {
      currentLangAudio = contentItem.audioAkhaPath;
    }

    setState(() {
      print(currentLangAudio);

      playAudioFlag = true;

      if (currentLangAudio != "") {
        player = AudioPlayer();
        player.setUrl("${Global.rootURL}/uploads/$currentLangAudio");
        player.play();
      }
    });
  }

  _stopAudio() {
    setState(() {
      playAudioFlag = false;

      player.stop();
    });
  }

  _playVideo() {
    if (currentLang == "TH") {
      currentLangVideo = contentItem.videoThPath;
    } else if (currentLang == "HMONG") {
      currentLangVideo = contentItem.videoHmongPath;
    } else if (currentLang == "KAREN") {
      currentLangVideo = contentItem.videoKarenPath;
    } else if (currentLang == "YAO") {
      currentLangVideo = contentItem.videoYaoPath;
    } else if (currentLang == "LISU") {
      currentLangVideo = contentItem.videoLisuPath;
    } else if (currentLang == "LAHU") {
      currentLangVideo = contentItem.videoLahuPath;
    } else if (currentLang == "AKHA") {
      currentLangVideo = contentItem.videoAkhaPath;
    }

    setState(() {
      print(currentLangVideo);

      if (currentLangVideo != "") {
        _controller = VideoPlayerController.network(
          "${Global.rootURL}/uploads/$currentLangVideo",
        )..initialize().then((_) {
          setState(() {});
        });
        _controller.setLooping(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key(ContentViewScreen.ROUTE_ID),
      onVisibilityChanged: (VisibilityInfo info) {
        bool isVisible = info.visibleFraction != 0;
        onRefresh(isVisible);
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFFE8F3FF),
            elevation: 0,
            iconTheme: const IconThemeData(
              color: Colors.black54, //change your color here
            ),
          ),
          body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/asset/imgs/bg/bg-content.PNG"),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 0, bottom: 60, left: 20, right: 20),
                child: Column(
                  children: [
                    Image.network(
                        "${Global.rootURL}/uploads/$imageCoverPath",
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          return Image.asset(
                            'lib/asset/imgs/no-image.png',
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          );
                        }
                    ),
                    const SizedBox(height: 20.0,),
                    Text(
                      contentName,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    const SizedBox(height: 10.0,),
                    Text(
                      contentDetail,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10.0,),
                    Visibility(
                      visible: (currentLangAudio != "" && !playAudioFlag) ? true : false,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: RaisedButton.icon(
                            icon: const Icon(
                              Icons.audiotrack,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'เล่นเสียง',
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 1.5,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: const Color(0xFF8EC1FD),
                            onPressed: () {
                              _playAudio();
                            }
                        ),
                      ),
                    ),
                    Visibility(
                      visible: playAudioFlag,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: RaisedButton.icon(
                            icon: const Icon(
                              Icons.stop,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'หยุด',
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 1.5,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: const Color(0xFF8EC1FD),
                            onPressed: () {
                              _stopAudio();
                            }
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0,),
                    currentLangVideo != ""
                        ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ) : Container(),
                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width * 0.7,
                    //   child: RaisedButton.icon(
                    //       icon: Icon(
                    //         Icons.play_arrow,
                    //         color: Colors.white,
                    //       ),
                    //       label: Text(
                    //         'เล่นคลิป',
                    //         style: TextStyle(
                    //           color: Colors.white,
                    //           letterSpacing: 1.5,
                    //           fontSize: 18,
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //       ),
                    //       padding: EdgeInsets.all(10.0),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //       color: Color(0xFF8EC1FD),
                    //       onPressed: () {
                    //         _playVideo();
                    //       }
                    //   ),
                    // ),
                    const SizedBox(height: 50.0,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: RaisedButton.icon(
                          icon: const Icon(
                            Icons.wifi_protected_setup,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'เปลี่ยนภาษา',
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1.5,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          padding: const EdgeInsets.all(10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: const Color(0xFF8EC1FD),
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: GridView.count(
                                      primary: false,
                                      shrinkWrap: true,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 5,
                                      crossAxisCount: 2,
                                      children: [
                                        GestureDetector(
                                          child: Column(
                                            children: const [
                                              Image(
                                                image: AssetImage("lib/asset/imgs/lang/th.png"),
                                                height: 75,
                                                width: 75,
                                              ),
                                              Text('ไทย')
                                            ],
                                          ),
                                          onTap: () {
                                            _onChangeLanguage('TH');
                                          },
                                        ),
                                        GestureDetector(
                                          child: Column(
                                            children: const [
                                              Image(
                                                image: AssetImage("lib/asset/imgs/lang/hmong.png"),
                                                height: 75,
                                                width: 75,
                                              ),
                                              Text('ม้ง')
                                            ],
                                          ),
                                          onTap: () {
                                            _onChangeLanguage('HMONG');
                                          },
                                        ),
                                        GestureDetector(
                                          child: Column(
                                            children: const [
                                              Image(
                                                image: AssetImage("lib/asset/imgs/lang/karen.png"),
                                                height: 75,
                                                width: 75,
                                              ),
                                              Text('กะเหรี่ยง')
                                            ],
                                          ),
                                          onTap: () {
                                            _onChangeLanguage('KAREN');
                                          },
                                        ),
                                        GestureDetector(
                                          child: Column(
                                            children: const [
                                              Image(
                                                image: AssetImage("lib/asset/imgs/lang/yao.png"),
                                                height: 75,
                                                width: 75,
                                              ),
                                              Text('เย้า')
                                            ],
                                          ),
                                          onTap: () {
                                            _onChangeLanguage('YAO');
                                          },
                                        ),
                                        GestureDetector(
                                          child: Column(
                                            children: const [
                                              Image(
                                                image: AssetImage("lib/asset/imgs/lang/lisu.png"),
                                                height: 75,
                                                width: 75,
                                              ),
                                              Text('ลีซู')
                                            ],
                                          ),
                                          onTap: () {
                                            _onChangeLanguage('LISU');
                                          },
                                        ),
                                        GestureDetector(
                                          child: Column(
                                            children: const [
                                              Image(
                                                image: AssetImage("lib/asset/imgs/lang/lahu.png"),
                                                height: 75,
                                                width: 75,
                                              ),
                                              Text('ลาหู่')
                                            ],
                                          ),
                                          onTap: () {
                                            _onChangeLanguage('LAHU');
                                          },
                                        ),
                                        GestureDetector(
                                          child: Column(
                                            children: const [
                                              Image(
                                                image: AssetImage("lib/asset/imgs/lang/akha.png"),
                                                height: 75,
                                                width: 75,
                                              ),
                                              Text('อาข่า')
                                            ],
                                          ),
                                          onTap: () {
                                            _onChangeLanguage('AKHA');
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                }
                            );
                          }
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }

}