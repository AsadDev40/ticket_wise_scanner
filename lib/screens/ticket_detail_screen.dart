// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket_wise_scanner/model/ticket_model.dart';
import 'package:ticket_wise_scanner/provider/ticket_provider.dart';
import 'package:ticket_wise_scanner/screens/ticket_scanner_screen.dart';
import 'package:ticket_wise_scanner/services/constants.dart';
import 'package:ticket_wise_scanner/services/utils.dart';

class TicketDetailScreen extends StatefulWidget {
  final TicketModel ticket;

  const TicketDetailScreen({super.key, required this.ticket});

  @override
  _TicketDetailScreenState createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ticketProvider = Provider.of<TicketProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: PrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Ticket Details',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: widget.ticket.status == 'closed'
          ? _buildClosedTicketView()
          : _buildTicketDetailsView(ticketProvider),
    );
  }

  Widget _buildClosedTicketView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.close,
            color: Colors.red,
            size: 100,
          ),
          SizedBox(height: 16),
          Text(
            'This ticket is already used and cannot be used again.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketDetailsView(TicketProvider ticketProvider) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                buildInfoCard(
                  Icons.person,
                  'Name',
                  widget.ticket.customername,
                ),
                buildInfoCard(
                  Icons.title,
                  'Event Title',
                  widget.ticket.eventTitle,
                ),
                buildInfoCard(
                  Icons.badge,
                  'Ticket Id',
                  widget.ticket.ticketId,
                ),
                buildInfoCard(
                  Icons.alarm,
                  'Event Start Time',
                  widget.ticket.starttime.toString(),
                ),
                buildInfoCard(
                  Icons.alarm,
                  'Event End Time',
                  widget.ticket.endtime.toString(),
                ),
                buildInfoCard(
                  Icons.location_city,
                  'City',
                  widget.ticket.city.toString(),
                ),
                buildInfoCard(
                  Icons.location_on,
                  'Location',
                  widget.ticket.location.toString(),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
            SizedBox(
              height: 60,
              width: 110,
              child: ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(PrimaryColor),
                ),
                onPressed: () async {
                  await ticketProvider.updateTicketStatus(
                      widget.ticket.ticketId, 'closed');
                  Utils.pushAndRemovePrevious(
                      context, const TicketQRCodeScannerScreen());
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build info cards
  Widget buildInfoCard(IconData icon, String label, String value) {
    return Card(
      color: PrimaryColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 28),
        title: Text(
          label,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
