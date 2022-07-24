import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_101/service/hospital_service.dart';
import 'package:flutter_101/service/mother_info_service.dart';
import 'package:flutter_101/service/staff_info_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PregnantData {
  PregnantData(this.month, this.amount);
  final String month;
  final int amount;
}

class StaffHomeScreen extends StatefulWidget {
  const StaffHomeScreen(): super();

  static const String ROUTE_ID = 'staff_home_screen';

  @override
  _StaffHomeScreenState createState() => _StaffHomeScreenState();
}

class _StaffHomeScreenState extends State<StaffHomeScreen> {

  static const storage = FlutterSecureStorage();

  StaffInfoService staffInfoService = StaffInfoService();
  HospitalService hospitalService = HospitalService();
  MotherInfoService motherInfoService = MotherInfoService();

  late bool firstFlag;

  late String staffName;
  late String hospitalName;
  late int staffAmount;
  late int motherAmount;

  late List<PregnantData> pregnantData10;
  late List<PregnantData> pregnantData11;
  late List<PregnantData> pregnantData20;
  late List<PregnantData> pregnantData21;

  @override
  void initState() {
    super.initState();

    firstFlag = false;

    staffName = "";
    hospitalName = "";
    staffAmount = 0;
    motherAmount = 0;

    pregnantData10 = [];
    pregnantData11 = [];
    pregnantData20 = [];
    pregnantData21 = [];
  }

  onRefresh(bool isVisible) {
    if (isVisible && !firstFlag) {
      firstFlag = true;

      staffName = "";
      hospitalName = "";
      staffAmount = 0;
      motherAmount = 0;

      pregnantData10 = [];
      pregnantData11 = [];
      pregnantData20 = [];
      pregnantData21 = [];

      _findStaffName();
      _findStaffCount();
      _findMotherCount();
      _findMotherGraph();
    } else if (!isVisible) {
      firstFlag = false;
    }
  }

  _findStaffName() {
    storage.read(key: "username").then((username) => {
      staffInfoService.staffLogin(username!).then((staff) {
        setState(() {
          staffName = "${staff.firstname} ${staff.lastname}";
        });

        // FIND HOSPITAL NAME
        hospitalService.findHospitalById(staff.hospitalId).then((hospital) {
          setState(() {
            hospitalName = hospital.hospitalName;
          });
        });
      })
    });
  }

  _findStaffCount() {
    staffInfoService.findStaffAmountByStaffLevel(3).then((value) {
      setState(() {
        staffAmount = value.amount;
      });
    });
  }

  _findMotherCount() {
    motherInfoService.findMotherAmount().then((value) {
      setState(() {
        motherAmount = value.amount;
      });
    });
  }

  _findMotherGraph() {
    motherInfoService.findMotherGraph().then((value) {
      setState(() {
        List<String> motherGraph1Month = [];
        List<String> motherGraph2Month = [];

        List<int> motherGraph1Value0 = [];
        List<int> motherGraph1Value1 = [];
        List<int> motherGraphStackValue0 = [];
        List<int> motherGraphStackValue1 = [];

        int stackAmount0 = 0;
        int stackAmount1 = 0;

        if (value.isNotEmpty) {
          for(var i = 0; i < value.length; i++){
            motherGraph1Month.add(value[i].monthNo.toString());
            motherGraph2Month.add(value[i].monthNo.toString());

            motherGraph1Value0.add(value[i].amount0);
            motherGraph1Value1.add(value[i].amount1);

            stackAmount0 += value[i].amount0;
            stackAmount1 += value[i].amount1;

            motherGraphStackValue0.add(stackAmount0);
            motherGraphStackValue1.add(stackAmount1);
          }
        }

        // PREGNANT_STATUS = 0
        for(var i = 0; i < motherGraph1Month.length; i++){
          pregnantData10.add(PregnantData(motherGraph1Month[i], motherGraph1Value0[i]));
        }
        for(var i = 0; i < motherGraph1Month.length; i++){
          pregnantData11.add(PregnantData(motherGraph1Month[i], motherGraph1Value1[i]));
        }

        // PREGNANT_STATUS = 1
        for(var i = 0; i < motherGraph1Month.length; i++){
          pregnantData20.add(PregnantData(motherGraph2Month[i], motherGraphStackValue0[i]));
        }
        for(var i = 0; i < motherGraph1Month.length; i++){
          pregnantData21.add(PregnantData(motherGraph2Month[i], motherGraphStackValue1[i]));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key(StaffHomeScreen.ROUTE_ID),
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
                image: AssetImage("lib/asset/imgs/bg/bg-staff-main.PNG"),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 60),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          staffName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          hospitalName,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Card(
                                color: const Color(0xFFF44771),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                elevation: 5,
                                child: Container(
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                                        child: Column(
                                          children: [
                                            const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "จำนวน อสม.",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10.0,),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "$staffAmount",
                                                style: const TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                    )
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Card(
                                color: const Color(0xFF332A7C),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                elevation: 5,
                                child: Container(
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                                        child: Column(
                                          children: [
                                            const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "จำนวน คุณแม่",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10.0,),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "$motherAmount",
                                                style: const TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                    )
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0,),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "มารดาตั้งครรภ์/คลอดบุตร รายใหม่",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0,),
                      SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          series: <LineSeries<PregnantData, String>>[
                            LineSeries<PregnantData, String>(
                                dataSource: pregnantData10,
                                xValueMapper: (PregnantData data, _) => data.month,
                                yValueMapper: (PregnantData data, _) => data.amount
                            ),
                            LineSeries<PregnantData, String>(
                                dataSource: pregnantData11,
                                xValueMapper: (PregnantData data, _) => data.month,
                                yValueMapper: (PregnantData data, _) => data.amount
                            )
                          ]
                      ),
                      const SizedBox(height: 20.0,),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "มารดาตั้งครรภ์/คลอดบุตร สะสม",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0,),
                      SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          series: <LineSeries<PregnantData, String>>[
                            LineSeries<PregnantData, String>(
                                dataSource: pregnantData20,
                                xValueMapper: (PregnantData data, _) => data.month,
                                yValueMapper: (PregnantData data, _) => data.amount
                            ),
                            LineSeries<PregnantData, String>(
                                dataSource: pregnantData21,
                                xValueMapper: (PregnantData data, _) => data.month,
                                yValueMapper: (PregnantData data, _) => data.amount
                            )
                          ]
                      ),
                    ],
                  )
              ),
            ),
          )
      ),
    );
  }

}