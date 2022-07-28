import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter_101/screens/mom/mom_evaluation_screen.dart';
import 'package:flutter_101/screens/staff/staff_home_screen.dart';
import 'package:flutter_101/screens/staff/staff_mom_screen.dart';
import 'package:flutter_101/screens/staff/staff_profile_screen.dart';
import 'package:flutter_101/screens/mom/mom_home_screen.dart';
import 'package:flutter_101/screens/content_screen.dart';
import 'package:flutter_101/screens/mom/mom_profile_screen.dart';

class GnavTab extends StatefulWidget {
  final BuildContext menuScreenContext;
  final String userType;

  const GnavTab({Key? key, required this.menuScreenContext, required this.userType}) : super(key: key);

  @override
  _GnavTabState createState() => _GnavTabState();
}

class _GnavTabState extends State<GnavTab> {
  int _selectedPage = 0;

  List<StatefulWidget> _pageOptions = [];
  List<GButton> _pageIcons = [];

  @override
  void initState() {
    if(widget.userType == "MOM"){
      _pageOptions = [
        const MomHomeScreen(),
        const MomEvaluationScreen(),
        const ContentScreen(),
        const MomProfileScreen(),
      ];

      _pageIcons = [
        GButton(
          icon: Icons.home,
          iconColor: Colors.grey[500],
          text: 'หน้าแรก',
        ),
        GButton(
          icon: Icons.analytics,
          iconColor: Colors.grey[500],
          text: 'แบบประเมิน',
        ),
        GButton(
          icon: Icons.article,
          iconColor: Colors.grey[500],
          text: 'ความรู้เพิ่มเติม',
        ),
        GButton(
          icon: Icons.account_circle,
          iconColor: Colors.grey[500],
          text: 'โปรไฟล์',
        )
      ];
    } else {
      _pageOptions = [
        const StaffHomeScreen(),
        const StaffMomScreen(),
        const ContentScreen(),
        const StaffProfileScreen(),
      ];

      _pageIcons = [
        GButton(
          icon: Icons.home,
          iconColor: Colors.grey[500],
          text: 'หน้าแรก',
        ),
        GButton(
          icon: Icons.supervised_user_circle,
          iconColor: Colors.grey[500],
          text: 'คุณแม่',
        ),
        GButton(
          icon: Icons.article,
          iconColor: Colors.grey[500],
          text: 'ความรู้เพิ่มเติม',
        ),
        GButton(
          icon: Icons.account_circle,
          iconColor: Colors.grey[500],
          text: 'โปรไฟล์',
        )
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pageOptions.elementAt(_selectedPage),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.0))
        ]),
        child: SafeArea(
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: GNav(
                gap: 1,
                activeColor: Colors.white,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                duration: Duration(milliseconds: 500),
                tabBackgroundColor: Color(0xFF75B3FD),
                tabs: _pageIcons,
                selectedIndex: _selectedPage,
                onTabChange: (int index) {
                  setState(() {
                    _selectedPage = index;
                  });
                }),
          ),
        ),
      ),
      backgroundColor: Colors.grey[900],
    );
  }
}