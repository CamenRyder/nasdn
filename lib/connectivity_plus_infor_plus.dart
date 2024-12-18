import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  String connectionStatus = 'Checking...';
  String appVersion = 'Loading...';
  String buildNumber = 'Loading...';

  @override
  void initState() {
    super.initState();
    _getConnectionStatus();
    _getAppInfo();
  }

  // Kiểm tra kết nối mạng
  Future<void> _getConnectionStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        connectionStatus = 'Connected to Mobile Network';
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        connectionStatus = 'Connected to WiFi';
      });
    } else {
      setState(() {
        connectionStatus = 'No internet connection';
      });
    }
  }

  // Lấy thông tin bản build và phiên bản ứng dụng
  Future<void> _getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Info & Connectivity'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Connectivity Status: $connectionStatus',
              style: const  TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              'App Version: $appVersion',
              style:const TextStyle(fontSize: 18),
            ),
            Text(
              'Build Number: $buildNumber',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
