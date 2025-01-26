// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:ticket_wise_scanner/provider/ticket_provider.dart';
import 'package:ticket_wise_scanner/screens/ticket_detail_screen.dart';
import 'package:ticket_wise_scanner/services/constants.dart';
import 'package:ticket_wise_scanner/services/utils.dart';

class TicketQRCodeScannerScreen extends StatefulWidget {
  const TicketQRCodeScannerScreen({super.key});

  @override
  _TicketQRCodeScannerScreenState createState() =>
      _TicketQRCodeScannerScreenState();
}

class _TicketQRCodeScannerScreenState extends State<TicketQRCodeScannerScreen> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? _scannedResult;
  QRViewController? _controller;
  bool _isFetching = false;

  @override
  void reassemble() {
    super.reassemble();
    if (defaultTargetPlatform == TargetPlatform.android) {
      _controller?.pauseCamera();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      _controller?.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    _controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (_isFetching) return;

      setState(() {
        _scannedResult = scanData;
      });

      if (_scannedResult?.code != null) {
        _controller?.pauseCamera();
        _onQRCodeScanned(_scannedResult!.code!);
      }
    });
  }

  Future<void> _onQRCodeScanned(String scannedData) async {
    setState(() {
      _isFetching = true;
    });

    try {
      final ticketProvider =
          Provider.of<TicketProvider>(context, listen: false);
      final ticket = await ticketProvider.fetchTicketById(scannedData);

      if (ticket != null) {
        // Navigate to the Ticket Detail screen
        Utils.navigateTo(context, TicketDetailScreen(ticket: ticket));
      } else {
        Utils.showToast("Ticket not found. Please try again.");
      }
    } catch (e) {
      Utils.showToast("Error fetching ticket details: $e");
    } finally {
      setState(() {
        _isFetching = false;
      });
      _controller?.resumeCamera();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Scan Ticket QR Code",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: PrimaryColor,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: _qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.blue,
                borderRadius: 10,
                borderLength: 20,
                borderWidth: 10,
                cutOutSize: 250,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (_scannedResult != null)
                  ? Text(
                      'Last scanned: ${_scannedResult!.code}',
                      style: const TextStyle(fontSize: 16),
                    )
                  : const Text('Awaiting scan...',
                      style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
