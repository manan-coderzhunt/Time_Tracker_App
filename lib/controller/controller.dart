import 'dart:async';
import 'package:flutter_screen_capture/flutter_screen_capture.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


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
  var screenshots = <Screenshot>[].obs;
  Stopwatch watch = Stopwatch();
  Timer? timer;
  Timer? breakTimer;
  var startStop = true.obs;
  var showClearButton = false.obs;
  var startedAtTime = ''.obs;
  var elapsedTime = '00:00:00'.obs;
  var breakTimeLeft = 30.obs;
  var timeEntries = <TimeEntry>[].obs;

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
    watch.start();
    watch.reset();
    startedAtTime.value = DateFormat("HH:mm").format(DateTime.now());
    timer = Timer.periodic(const Duration(seconds: 1), updateTime);
  }

  NewScreenTimer() {
    timer = Timer.periodic(const Duration(seconds: 5), ScreenTimerUpdate);
    _captureFullScreen();
  }

  stopWatch() {
    startStop.value = true;
    showClearButton.value = true;
    // watch.reset();
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
    }

    startedAtTime.value = '';
    elapsedTime.value = '00:00:00'; // Reset elapsed time
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
    if (breakTimer == null) {
      watch.stop();
      // timer?.cancel();
      breakTimeLeft.value = 30;
      breakTimer = Timer.periodic(Duration(minutes: 1), (timer) {
        if (breakTimeLeft.value > 0) {
          breakTimeLeft.value -= 1;
        } else {
          breakTimer?.cancel();
          breakTimer = null;
          watch.stop();
        }
      });
    } else {
      breakTimer?.cancel();
      breakTimer = null;
      watch.start();
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
        totalDuration +=
            Duration(hours: hours, minutes: minutes, seconds: seconds);
      }
    }
// Format total duration into HH:mm:ss format
    int totalHours = totalDuration.inHours;
    int totalMinutes = totalDuration.inMinutes.remainder(60);
    int totalSeconds = totalDuration.inSeconds.remainder(60);
    return '$totalHours:${totalMinutes.toString().padLeft(2, '0')}:${totalSeconds.toString().padLeft(2, '0')}';
  }
}

