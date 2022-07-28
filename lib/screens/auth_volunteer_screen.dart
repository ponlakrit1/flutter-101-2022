import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_101/widget/gnav_tab.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_101/service/staff_info_service.dart';
import 'package:flutter_101/utils/utils.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:flutter_101/widget/custom_widget_tab.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthVolunteerScreen extends StatefulWidget {
  const AuthVolunteerScreen(): super();

  static const String ROUTE_ID = 'auth_volunteer_screen';

  @override
  _AuthVolunteerScreenState createState() => _AuthVolunteerScreenState();
}

class _AuthVolunteerScreenState extends State<AuthVolunteerScreen> {

  static const storage = FlutterSecureStorage();

  StaffInfoService staffInfoService = StaffInfoService();

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  void initState() {
    super.initState();
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
                'อาสาสมัครสาธารณสุขประจำหมู่บ้าน',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.5,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30.0,),
              SignInButton(
                Buttons.Google,
                text: "เข้าสู่ระบบด้วย Google",
                onPressed: () {
                  _onLoginWithGoogle(context);
                },
              ),
              Platform.isIOS ? SignInButton(
                Buttons.Apple,
                text: "เข้าสู่ระบบด้วย Apple",
                onPressed: () {
                  _onLoginWithApple();
                },
              ) : Container()
            ],
          ),
        )
    );
  }

  _onLoginWithGoogle(BuildContext context) async {
    try{
      await _googleSignIn.signIn();
      await staffInfoService.staffLogin(_googleSignIn.currentUser!.email).then((value) {
        storage.write(key: "username", value: _googleSignIn.currentUser!.email);
        storage.write(key: "user_type", value: "STAFF");

        pushNewScreen(
          context,
          screen: GnavTab(
            menuScreenContext: context,
            userType: "STAFF",
          ),
        );
      }, onError: (error, stackTrace) {
        if (error.toString() == 'Exception: Not found') {
          Utils.createToast("ชื่อผู้ใช้งานหรือรหัสผ่านไม่ถูกต้อง!", context);
        } else {
          Utils.createToast("เกิดข้อผิดพลาด!", context);
        }
      });
    } catch (err){
      Utils.createToast("เกิดข้อผิดพลาดกับ google sign in!", context);
    }
  }

  _onLoginWithApple() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    print(credential);
  }

}
