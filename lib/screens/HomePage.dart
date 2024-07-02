import 'package:flutter_screen_capture/flutter_screen_capture.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:time_tracker_app/controller/auth_controller.dart';
import 'package:time_tracker_app/controller/controller.dart';

class NewStopWatch extends StatelessWidget {
  final NewStopWatchController controller = Get.put(NewStopWatchController());
  final AuthController _authController = Get.put(AuthController());
  final userData = GetStorage();



  @override
  Widget build(BuildContext context) {
    final getPass = userData.read('email');
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 90.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(children: [
                      Text("Welcome".toUpperCase(),
            style: TextStyle(
                fontSize: 15.0,
                color: Color(0xFF003E62),
                fontWeight: FontWeight.w700)),
                      SizedBox(width: 10,),
                      Text("${getPass.split("@").first} ".toUpperCase(),
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Color(0xFF003E62),
                              fontWeight: FontWeight.bold)),
                    ],
                    ),
                    InkWell(
                    onTap: () => _authController.signOutUser(),
          child: Icon(Icons.logout_outlined)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Started at ",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF708496),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Obx(() =>
                          Text(
                            controller.startedAtTime.value.isEmpty
                                ? ''
                                : controller.startedAtTime.value,
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF6C8093),
                              fontWeight: FontWeight.bold,
                            ),
                          )
                      ),
                      SizedBox(width: 40),
                      Text(
                        "${DateFormat("MMM dd, yyyy").format(DateTime.now())}",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF708496),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 40),
                  Obx(() {
                    return Text(controller.elapsedTime.value,
                        style: TextStyle(
                            fontSize: 55.0,
                            color: Color(0xFF003E62),
                            fontWeight: FontWeight.bold));
                  }),

              SizedBox(height: 40.0),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 50,
                      child: FloatingActionButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        backgroundColor: Color(0xFFFD9E48),
                        onPressed: () => controller.startOrStop(),
                        child: Obx(
                              () =>
                              Text(
                                controller.startStop.value
                                    ? 'CLOCK IN'
                                    : "CLOCK OUT",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                        ),
                      ),
                    ),
                    SizedBox(width: 30),
                    Container(
                      width: 140,
                      height: 40,
                      child: FloatingActionButton(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: Color(0xFFA19AFB),
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        backgroundColor: Colors.white,
                        elevation: 0,
                        onPressed: () => controller.takeABreak(),
                        child: Text(
                          "Take a Break",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xFFA19AFB),
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Break Time Left',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF8DA0B5),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Obx(() =>
                            Text(
                              "${controller.breakTimeLeft.value} MINs",
                              style: TextStyle(
                                  color: Color(0xFF738698),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            )
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 40),
                SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.grey.shade300,
                          Colors.grey.shade50,
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Color(0xFFFAFAFA),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 38.0),
                    child: Column(
                      children: [
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Today",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF8DA0B5),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Total time",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF8DA0B5),
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Obx(() =>
                                      Text(controller.timeEntries.isEmpty
                                          ? ''
                                          : controller
                                          .calculateTotalElapsedTime(),
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0xFF8DA0B5),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 250,
                  color: Color(0xFFFAFAFA),
                  child: Obx(() => ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.timeEntries.length,
                      itemBuilder: (context, index) {
                        var entry =controller.timeEntries[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey.shade100,
                              border: Border.all(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            width: 100,
                            height: 80,
                            child: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0, vertical: 8),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Clock in',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                  color: Color(0xff687f8a),
                                                ),
                                              ),
                                              Text(
                                                entry.clockInTime,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Color(0xff33394e),
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 8),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Clock Out',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                  color: Color(0xff687f8a),
                                                ),
                                              ),
                                              Text(entry.clockOutTime ?? ' - ',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Color(0xff33394e),
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                              // Text(
                                              //   "${DateFormat("HH:mm").format(
                                              //       DateTime.now())}",
                                              //   style: TextStyle(
                                              //       fontSize: 18,
                                              //       color: Color(0xff33394e),
                                              //       fontWeight:
                                              //       FontWeight.bold),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 18.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text(entry.elapsedTime ?? ' - ',
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Color(0xff687f8a),
                                                    fontWeight:
                                                    FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              SizedBox(height: 350),
             Obx(() =>
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.screenshots.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CapturedScreenAreaView(
                                  area:
                                  controller.screenshots[index].area),
                              SizedBox(height: 20),
                              Text(
                                controller.startStop.value
                                    ? "Current Time ${controller
                                    .screenshots[index].dateTime
                                    .hour}:${controller.screenshots[index]
                                    .dateTime.minute}:${controller
                                    .screenshots[index].dateTime.second}"
                                    : '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )),
              SizedBox(height: 50),
              Obx(() =>
              controller.showClearButton.value
                  ? ElevatedButton(
                onPressed: controller.clearScreenshots,
                child: Text("Clear Screenshots"),
              )
                  : Container()),
            ],
          ),
        ),
        ],
      ),
    ),)
    ,
    );
  }
}
