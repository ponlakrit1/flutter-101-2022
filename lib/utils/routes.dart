import 'package:flutter_101/screens/content_view_screen.dart';
import 'package:flutter_101/screens/landing_screen.dart';
import 'package:flutter_101/screens/auth_mom_screen.dart';
import 'package:flutter_101/screens/auth_volunteer_screen.dart';
import 'package:flutter_101/screens/login_screen.dart';
import 'package:flutter_101/screens/mom/sub/mom_profile_edit_screen.dart';
import 'package:flutter_101/screens/mom/sub/mom_question_screen.dart';
import 'package:flutter_101/screens/staff/sub/staff_evaluation_screen.dart';
import 'package:flutter_101/screens/staff/sub/staff_mom_profile_screen.dart';
import 'package:flutter_101/screens/staff/sub/staff_profile_edit_screen.dart';
import 'package:flutter_101/screens/staff/sub/staff_question_screen.dart';

class Routes {

  static routes() {
    return {
      LandingScreen.ROUTE_ID: (context) => const LandingScreen(),
      LoginScreen.ROUTE_ID: (context) => const LoginScreen(),
      AuthMomScreen.ROUTE_ID: (context) => const AuthMomScreen(),
      AuthVolunteerScreen.ROUTE_ID: (context) => const AuthVolunteerScreen(),
      StaffProfileEditScreen.ROUTE_ID: (context) => const StaffProfileEditScreen(),
      MomProfileEditScreen.ROUTE_ID: (context) => const MomProfileEditScreen(),
      ContentViewScreen.ROUTE_ID: (context) => const ContentViewScreen(),
      StaffEvaluationScreen.ROUTE_ID: (context) => const StaffEvaluationScreen(),
      StaffQuestionScreen.ROUTE_ID: (context) => const StaffQuestionScreen(),
      MomQuestionScreen.ROUTE_ID: (context) => const MomQuestionScreen(),
      StaffMomProfileScreen.ROUTE_ID: (context) => const StaffMomProfileScreen(),
    };
  }

  static String initScreen() {
    // return LandingScreen.ROUTE_ID;
    return LoginScreen.ROUTE_ID;
  }
}
