import 'dart:async';

import 'package:quiver/async.dart';

class GeneralFunction{
  static void timeOut() {
    Timer _timer;
    int _start = 60;
    int _current = 60;

    startTimer() {
      CountdownTimer countDownTimer = new CountdownTimer(
        new Duration(seconds: _start),
        new Duration(seconds: 1),
      );

      var sub = countDownTimer.listen(null);
      sub.onData((duration) {
        _current = _start - duration.elapsed.inSeconds; ;
      });

      sub.onDone(() {
        sub.cancel();
      });
      print(_current);
      return _current;
    }
  }


}