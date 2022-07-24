import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_101/model/entity/content.dart';
import 'package:flutter_101/screens/content_view_screen.dart';
import 'package:flutter_101/service/content_service.dart';
import 'package:flutter_101/utils/global.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ContentScreen extends StatefulWidget {
  const ContentScreen(): super();

  static const String ROUTE_ID = 'content_screen';

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {

  static const storage = FlutterSecureStorage();

  ContentService contentService = ContentService();

  late bool firstFlag;

  late List<Content> contentList;

  @override
  void initState() {
    super.initState();

    firstFlag = false;

    contentList = [];
  }

  onRefresh(bool isVisible) {
    if (isVisible && !firstFlag) {
      firstFlag = true;

      contentList = [];

      _findAllContent();
    } else if (!isVisible) {
      firstFlag = false;
    }
  }

  _findAllContent() {
    contentService.findAllByIsActive().then((value) {
      setState(() {
        if (value.isNotEmpty) {
          contentList = value;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key(ContentScreen.ROUTE_ID),
      onVisibilityChanged: (VisibilityInfo info) {
        bool isVisible = info.visibleFraction != 0;
        onRefresh(isVisible);
      },
      child: Scaffold(
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
                padding: const EdgeInsets.only(top: 40, bottom: 60, left: 20, right: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(
                      image: AssetImage("lib/asset/imgs/mother.png"),
                      height: 150,
                      width: 150,
                    ),
                    const SizedBox(height: 10.0,),
                    const Center(
                      child: Text(
                        "ความรู้เพิ่มเติมเกี่ยวกับคุณแม่ตั้งครรภ์",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    const SizedBox(height: 5.0,),
                    const Center(
                      child: Text(
                        "ความรู้เพิ่มเติมเกี่ยวกับคุณแม่ตั้งครรภ์ เรื่องอาหารการกินและการออกกำลังกาย ที่เหมาะสมในแต่ละช่วงเวลาของคุณแม่",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    // SizedBox(height: 20.0,),
                    GridView.builder(
                      primary: false,
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: contentList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                              child: Column(
                                children: [
                                  Image.network(
                                      "${Global.rootURL}/uploads/${contentList[index].imageCoverPath}",
                                      height: 100.0,
                                      fit: BoxFit.cover,
                                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                        return Image.asset(
                                          'lib/asset/imgs/no-image.png',
                                          width: 100.0,
                                          height: 100.0,
                                          fit: BoxFit.cover,
                                        );
                                      }
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      child: Text(
                                        contentList[index].contentName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Text(
                                  //       '15 นาที',
                                  //       style: TextStyle(
                                  //         fontSize: 12,
                                  //       ),
                                  //     ),
                                  //     Text(
                                  //       'คลิปเสียง',
                                  //       style: TextStyle(
                                  //         fontSize: 12,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // )
                                ],
                              )
                          ),
                          onTap: () {
                            storage.write(key: "content_id", value: contentList[index].contentId.toString());

                            Navigator.of(context, rootNavigator: true).pushNamed(ContentViewScreen.ROUTE_ID);
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }

}