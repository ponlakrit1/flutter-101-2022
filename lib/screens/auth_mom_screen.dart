import 'package:flutter/material.dart';
import 'package:flutter_101/service/mother_info_service.dart';
import 'package:flutter_101/utils/utils.dart';
import 'package:flutter_101/widget/custom_widget_tab.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthMomScreen extends StatefulWidget {
  const AuthMomScreen(): super();

  static const String ROUTE_ID = 'auth_mom_screen';

  @override
  _AuthMomScreenState createState() => _AuthMomScreenState();
}

class _AuthMomScreenState extends State<AuthMomScreen> {

  static const storage = FlutterSecureStorage();

  MotherInfoService motherInfoService = MotherInfoService();

  late TextEditingController usernameTextController;
  late TextEditingController passwordTextController;
  late bool passwordVisibility;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    usernameTextController = TextEditingController();
    passwordTextController = TextEditingController();
    passwordVisibility = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/asset/imgs/bg/bg-login.PNG"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Align(
                alignment: AlignmentDirectional(0, -1),
                child: Image(
                  image: AssetImage("lib/asset/imgs/mother.png"),
                  height: 180,
                  width: 180,
                ),
              ),
              const SizedBox(height: 50.0,),
              const Text(
                'คุณแม่ตั้งครรภ์',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.5,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20.0,),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    4, 0, 4, 15),
                child: Container(
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.black12,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        20, 0, 20, 0),
                    child: TextFormField(
                      controller: usernameTextController,
                      obscureText: false,
                      decoration: const InputDecoration(
                        hintText: 'ชื่อผู้ใช้งาน',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1,
                          ),
                          borderRadius:
                          BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1,
                          ),
                          borderRadius:
                          BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    4, 0, 4, 20),
                child: Container(
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.black12,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        20, 0, 20, 0),
                    child: TextFormField(
                      controller: passwordTextController,
                      obscureText: !passwordVisibility,
                      decoration: InputDecoration(
                        hintText: 'รหัสผ่าน',
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1,
                          ),
                          borderRadius:
                          BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1,
                          ),
                          borderRadius:
                          BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                        suffixIcon: InkWell(
                          onTap: () => setState(
                                () => passwordVisibility =
                            !passwordVisibility,
                          ),
                          child: Icon(
                            passwordVisibility
                                ? Icons.visibility_outlined
                                : Icons
                                .visibility_off_outlined,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0,),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: RaisedButton.icon(
                    icon: const Icon(
                      Icons.vpn_key,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'เข้าสู่ระบบ',
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
                      _onLogin(context);
                    }
                ),
              ),
            ],
          ),
        )
    );
  }

  _onLogin(BuildContext context) async {
    await motherInfoService.motherLogin(usernameTextController.text, passwordTextController.text).then((value) {
      storage.write(key: "username", value: usernameTextController.text);
      storage.write(key: "user_type", value: "MOM");

      pushNewScreen(
        context,
        screen: ProvidedStylesExample(
          menuScreenContext: context,
          userType: "MOM",
        ),
      );
    }, onError: (error, stackTrace) {
      if (error.toString() == 'Not found') {
        Utils.createToast("ชื่อผู้ใช้งานหรือรหัสผ่านไม่ถูกต้อง!", context);
      } else {
        Utils.createToast("เกิดข้อผิดพลาด!", context);
      }
    });
  }

}
