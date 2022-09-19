import 'dart:async';
import 'dart:io';

class InternetConnectionChecker {
  static Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  // If any of the pings returns true then you have internet (for sure). If none do, you probably don't.
//   Future<bool> _checkInternetAccess() {
//     /// We use a mix of IPV4 and IPV6 here in case some networks only accept one of the types.
//     /// Only tested with an IPV4 only network so far (I don't have access to an IPV6 network).
//     final List<InternetAddress> dnss = [
//       InternetAddress('8.8.8.8', type: InternetAddressType.IPv4), // Google
//       InternetAddress('2001:4860:4860::8888',
//           type: InternetAddressType.IPv6), // Google
//       InternetAddress('1.1.1.1', type: InternetAddressType.IPv4), // CloudFlare
//       InternetAddress('2606:4700:4700::1111',
//           type: InternetAddressType.IPv6), // CloudFlare
//       InternetAddress('208.67.222.222',
//           type: InternetAddressType.IPv4), // OpenDNS
//       InternetAddress('2620:0:ccc::2',
//           type: InternetAddressType.IPv6), // OpenDNS
//       InternetAddress('180.76.76.76', type: InternetAddressType.IPv4), // Baidu
//       InternetAddress('2400:da00::6666',
//           type: InternetAddressType.IPv6), // Baidu
//     ];

//     final Completer<bool> completer = Completer<bool>();

//     int callsReturned = 0;
//     void onCallReturned(bool isAlive) {
//       if (completer.isCompleted) return;

//       if (isAlive) {
//         completer.complete(true);
//       } else {
//         callsReturned++;
//         if (callsReturned >= dnss.length) {
//           completer.complete(false);
//         }
//       }
//     }

//     dnss.forEach((dns) => _pingDns(dns).then(onCallReturned));

//     return completer.future;
//   }

//   Future<bool> _pingDns(InternetAddress dnsAddress) async {
//     const int dnsPort = 53;
//     const Duration timeout = Duration(seconds: 3);

//     Socket socket;
//     try {
//       socket = await Socket.connect(dnsAddress, dnsPort, timeout: timeout);
//       socket.destroy();
//       return true;
//     } on SocketException {
//       // socket.destroy();
//       print('SocketException');
//     }
//     return false;
//   }
}
