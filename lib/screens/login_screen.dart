import 'package:flutter/material.dart';
import 'package:flutter_101/screens/auth_mom_screen.dart';
import 'package:flutter_101/screens/auth_volunteer_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen(): super();

  static const String ROUTE_ID = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

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
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: RaisedButton.icon(
                  icon: const Icon(
                    Icons.supervised_user_circle,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'คุณแม่',
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
                    _onLogin('MOM');
                  }
              ),
            ),
            const SizedBox(height: 30.0,),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: RaisedButton.icon(
                  icon: const Icon(
                    Icons.account_box,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'เจ้าหน้าที่',
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
                    _onLogin('STAFF');
                  }
              ),
            ),
          ],
        ),
      )
    );
  }

  _onLogin(String role) {
    if (role == 'MOM') {
      Navigator.pushNamed(context, AuthMomScreen.ROUTE_ID);
    } else if (role == 'STAFF') {
      Navigator.pushNamed(context, AuthVolunteerScreen.ROUTE_ID);
    }
  }

}
