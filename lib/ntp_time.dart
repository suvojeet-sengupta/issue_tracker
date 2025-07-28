import 'package:ntp/ntp.dart';

Future<DateTime> getNetworkTime() async {
  try {
    final int offset = await NTP.getNtpOffset(localTime: DateTime.now(), lookUpAddress: 'time.google.com');
    final DateTime networkTime = DateTime.now().add(Duration(milliseconds: offset));
    print('Successfully fetched network time: $networkTime');
    return networkTime;
  } catch (e) {
    print('Error fetching network time: $e');
    return DateTime.now();
  }
}