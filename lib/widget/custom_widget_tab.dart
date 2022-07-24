import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_101/screens/mom/mom_evaluation_screen.dart';
import 'package:flutter_101/screens/staff/staff_home_screen.dart';
import 'package:flutter_101/screens/staff/staff_mom_screen.dart';
import 'package:flutter_101/screens/staff/staff_profile_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:flutter_101/screens/mom/mom_home_screen.dart';
import 'package:flutter_101/screens/content_screen.dart';
import 'package:flutter_101/screens/mom/mom_profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProvidedStylesExample extends StatefulWidget {
  final BuildContext menuScreenContext;
  final String userType;

  const ProvidedStylesExample({Key? key, required this.menuScreenContext, required this.userType}) : super(key: key);

  @override
  _ProvidedStylesExampleState createState() => _ProvidedStylesExampleState();
}

class _ProvidedStylesExampleState extends State<ProvidedStylesExample> {

  static const storage = FlutterSecureStorage();

  late PersistentTabController _controller;
  late bool _hideNavBar;

  late SharedPreferences prefs;
  late String _userType = "";

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _hideNavBar = false;

    storage.read(key: "user_type").then((value) {
      _userType = value!;
    });
  }

  // Screen
  List<Widget> _buildScreens() {
    if(widget.userType == "MOM"){
      return [
        const MomHomeScreen(),
        const MomEvaluationScreen(),
        const ContentScreen(),
        const MomProfileScreen(),
      ];
    } else {
      return [
        const StaffHomeScreen(),
        const StaffMomScreen(),
        const ContentScreen(),
        const StaffProfileScreen(),
      ];
    }
  }

  // Icon
  List<PersistentBottomNavBarItem> _navBarsItems() {
    if(widget.userType == "MOM"){
      return [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          title: ("หน้าแรก"),
          activeColorPrimary: const Color(0xFF75B3FD),
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.analytics),
          title: ("แบบประเมิน"),
          activeColorPrimary: const Color(0xFF75B3FD),
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.article),
          title: ("ความรู้เพิ่มเติม"),
          activeColorPrimary: const Color(0xFF75B3FD),
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.account_circle),
          title: ("โปรไฟล์"),
          activeColorPrimary: const Color(0xFF75B3FD),
          inactiveColorPrimary: Colors.grey,
        ),
      ];
    } else {
      return [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          title: ("หน้าแรก"),
          activeColorPrimary: const Color(0xFF75B3FD),
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.supervised_user_circle),
          title: ("คุณแม่"),
          activeColorPrimary: const Color(0xFF75B3FD),
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.article),
          title: ("ความรู้เพิ่มเติม"),
          activeColorPrimary: const Color(0xFF75B3FD),
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.account_circle),
          title: ("โปรไฟล์"),
          activeColorPrimary: const Color(0xFF75B3FD),
          inactiveColorPrimary: Colors.grey,
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
            ? 0.0
            : kBottomNavigationBarHeight,
        hideNavigationBarWhenKeyboardShows: true,
        margin: const EdgeInsets.all(0.0),
        popActionScreens: PopActionScreensType.all,
        bottomScreenMargin: 0.0,
        onWillPop: (context) async {
          return false;
        },
        selectedTabScreenContext: (context) {
          var testContext = context!;
        },
        hideNavigationBar: _hideNavBar,
        decoration: const NavBarDecoration(
          colorBehindNavBar: Color(0xFF75B3FD),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0)),),
        popAllScreensOnTapOfSelectedTab: true,
        itemAnimationProperties: const ItemAnimationProperties(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
        NavBarStyle.style9, // Choose the nav bar style with this property
      ),
    );
  }
}

class CustomNavBarWidget extends StatelessWidget {
  final int selectedIndex;
  final List<PersistentBottomNavBarItem> items;
  final ValueChanged<int> onItemSelected;

  const CustomNavBarWidget({
    Key? key,
    required this.selectedIndex,
    required this.items,
    required this.onItemSelected,
  });

  Widget _buildItem(PersistentBottomNavBarItem item, bool isSelected) {
    return Container(
      alignment: Alignment.center,
      height: kBottomNavigationBarHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: IconTheme(
              data: IconThemeData(
                  size: 26.0,
                  color: isSelected
                      ? (item.activeColorSecondary ?? item.activeColorPrimary)
                      : item.inactiveColorPrimary ?? item.activeColorPrimary),
              child: isSelected ? item.icon : item.inactiveIcon ?? item.icon,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Material(
              type: MaterialType.transparency,
              child: FittedBox(
                  child: Text(
                    item.title!,
                    style: TextStyle(
                        color: isSelected
                            ? (item.activeColorSecondary ?? item.activeColorPrimary)
                            : item.inactiveColorPrimary,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0),
                  )),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        height: kBottomNavigationBarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.map((item) {
            int index = items.indexOf(item);
            return Flexible(
              child: GestureDetector(
                onTap: () {
                  onItemSelected(index);
                },
                child: _buildItem(item, selectedIndex == index),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}