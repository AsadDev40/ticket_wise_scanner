import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ticket_wise_scanner/screens/ticket_scanner_screen.dart';
import 'package:ticket_wise_scanner/services/app_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProvider(
        child: MaterialApp(
      builder: EasyLoading.init(),
      home: const TicketQRCodeScannerScreen(),
    ));
  }
}
