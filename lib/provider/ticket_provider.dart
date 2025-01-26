import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ticket_wise_scanner/model/ticket_model.dart';

class TicketProvider extends ChangeNotifier {
  final CollectionReference ticketCollection =
      FirebaseFirestore.instance.collection('tickets');

  Future<TicketModel?> fetchTicketById(String ticketId) async {
    try {
      QuerySnapshot snapshot = await ticketCollection
          .where('ticketId', isEqualTo: ticketId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return TicketModel.fromJson(
            snapshot.docs.first.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error fetching ticket by ID: $e');
    }
  }

  Future<void> updateTicketStatus(String ticketId, String newStatus) async {
    try {
      // Find the ticket by ticketId
      QuerySnapshot snapshot = await ticketCollection
          .where('ticketId', isEqualTo: ticketId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Get the document ID of the ticket
        String docId = snapshot.docs.first.id;

        // Update the status field of the ticket
        await ticketCollection.doc(docId).update({'status': newStatus});

        notifyListeners();
      } else {
        throw Exception('Ticket not found.');
      }
    } catch (e) {
      throw Exception('Error updating ticket status: $e');
    }
  }
}
