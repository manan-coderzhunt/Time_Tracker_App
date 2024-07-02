import 'dart:async';
import 'package:flutter_screen_capture/flutter_screen_capture.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TimeEntry {
  final String clockInTime;
  String? clockOutTime;
  String? elapsedTime;

  TimeEntry({
    required this.clockInTime,
    this.clockOutTime,
    this.elapsedTime,
  });
}

class Screenshot {
  final CapturedScreenArea area;
  final String captureTime;
  final DateTime dateTime;

  Screenshot(this.area, this.captureTime, this.dateTime);
}

class NewStopWatchController extends GetxController {
  final _plugin = ScreenCapture();
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final box = GetStorage();
  var screenshots = <Screenshot>[].obs;
  var watch = Stopwatch();
  Timer? timer;
  Timer? breakTimer;
  var startStop = true.obs;
  var showClearButton = false.obs;
  var elapsedTime = '00:00:00'.obs;
  var startedAtTime = ''.obs;
  var breakTimeLeft = 30.obs;
  var timeEntries = <TimeEntry>[].obs;
  var onBreak = false.obs;
  var breakPressCount = 0.obs;
  String? userEmail;

  @override
  void onInit() {
    super.onInit();
    loadLocalData();
  }

  void setUserEmail(String email) {
    userEmail = email;
    loadLocalData();
  }

  void loadLocalData() {
    if (userEmail != null && box.hasData(userEmail!)) {
      var storedEntries = box.read<List>(userEmail!);
      if (storedEntries != null) {
        timeEntries.assignAll(
          storedEntries.map((e) => TimeEntry(
            clockInTime: e['clockInTime'],
            clockOutTime: e['clockOutTime'],
            elapsedTime: e['elapsedTime'],
          )),
        );
      }
    }
  }

  void saveLocalData() {
    if (userEmail != null) {
      var entries = timeEntries.map((e) {
        return {
          'clockInTime': e.clockInTime,
          'clockOutTime': e.clockOutTime,
          'elapsedTime': e.elapsedTime,
        };
      }).toList();
      box.write(userEmail!, entries);
    }
  }

  updateTime(Timer timer) {
    if (watch.isRunning) {
      elapsedTime.value = transformMilliSeconds(watch.elapsedMilliseconds);
    }
  }

  ScreenTimerUpdate(Timer timer) {
    _captureFullScreen();
  }

  startOrStop() {
    if (startStop.value) {
      startWatch();
      NewScreenTimer();
    } else {
      stopWatch();
    }
  }

  startWatch() {
    startStop.value = false;
    if (watch.isRunning) {
      watch.stop();
    }
    watch.start();
    startedAtTime.value = DateFormat("HH:mm").format(DateTime.now());
    timer = Timer.periodic(Duration(seconds: 1), updateTime);
  }

  NewScreenTimer() {
    timer = Timer.periodic(Duration(minutes: 1), ScreenTimerUpdate);
    _captureFullScreen();
  }

  stopWatch() {
    startStop.value = true;
    showClearButton.value = true;
    watch.stop();
    timer?.cancel();
    setTime();

    if (startedAtTime.value.isNotEmpty) {
      var elapsed = transformMilliSeconds(watch.elapsedMilliseconds);
      timeEntries.add(TimeEntry(
        clockInTime: startedAtTime.value,
        clockOutTime: DateFormat("HH:mm").format(DateTime.now()),
        elapsedTime: elapsed,
      ));
      saveLocalData();
    }

    watch.reset();
    startedAtTime.value = '';
    elapsedTime.value = '00:00:00';
    breakTimeLeft.value = 30;
    breakTimer?.cancel();
    onBreak.value = false;
    breakPressCount.value = 0;
  }

  clearScreenshots() {
    screenshots.clear();
    showClearButton.value = false;
  }

  setTime() {
    var timeSoFar = watch.elapsedMilliseconds;
    elapsedTime.value = transformMilliSeconds(timeSoFar);
  }

  transformMilliSeconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();
    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  Future<void> _captureFullScreen() async {
    final area = await _plugin.captureEntireScreen();
    final currentTime = DateTime.now();
    if (area != null) {
      screenshots.add(Screenshot(area, elapsedTime.value, currentTime));
    }
  }

  takeABreak() {
    breakPressCount.value += 1;

    if (breakPressCount.value == 1) {
      onBreak.value = true;
      watch.stop();
      timer?.cancel();
      breakTimeLeft.value = 30;
      breakTimer = Timer.periodic(Duration(minutes: 1), (timer) {
        if (breakTimeLeft.value > 0) {
          breakTimeLeft.value -= 1;
        } else {
          breakTimer?.cancel();
          breakTimer = null;
          onBreak.value = false;
          if (!startStop.value) {
            startWatch();
          }
        }
      });
    } else if (breakPressCount.value == 2) {
      breakTimer?.cancel();
      breakTimer = null;
      onBreak.value = false;
      if (!startStop.value) {
        startWatch();
      }
    } else if (breakPressCount.value == 3) {
      breakPressCount.value = 0;
      breakTimeLeft.value = 30;
      breakTimer?.cancel();
      onBreak.value = false;
      if (!startStop.value) {
        startWatch();
      }
      breakTimer = Timer.periodic(Duration(minutes: 1), (timer) {
        if (breakTimeLeft.value > 0) {
          breakTimeLeft.value -= 1;
        } else {
          breakTimer?.cancel();
          breakTimer = null;
          onBreak.value = false;
          if (!startStop.value) {
            startWatch();
          }
        }
      });
    }
  }

  String calculateTotalElapsedTime() {
    Duration totalDuration = Duration();
    for (var entry in timeEntries) {
      if (entry.elapsedTime != null) {
        List<String> timeParts = entry.elapsedTime!.split(':');
        int hours = int.parse(timeParts[0]);
        int minutes = int.parse(timeParts[1]);
        int seconds = int.parse(timeParts[2]);
        totalDuration += Duration(hours: hours, minutes: minutes, seconds: seconds);
      }
    }
    int totalHours = totalDuration.inHours;
    int totalMinutes = totalDuration.inMinutes.remainder(60);
    int totalSeconds = totalDuration.inSeconds.remainder(60);
    return '$totalHours:${totalMinutes.toString().padLeft(2, '0')}:${totalSeconds.toString().padLeft(2, '0')}';
  }
}