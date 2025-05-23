import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hvatai_admin_panel/components/Appcolors.dart';
import 'package:intl/intl.dart';

class AdminPaymentsScreen extends StatelessWidget {
  const AdminPaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text("All Payments",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: AppColor.primary,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('payments')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No payments found."));
          }

          final payments = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: payments.length,
            itemBuilder: (context, index) {
              final data = payments[index].data() as Map<String, dynamic>;

              final amount = data['amount'] ?? '—';
              final currency = data['currency'] ?? '—';
              final userEmail = data['userEmail'] ?? '—';
              final paymentMethod = data['paymentMethod'] ?? '—';
              final timestamp = data['timestamp'] != null
                  ? (data['timestamp'] as Timestamp).toDate()
                  : null;

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading:  CircleAvatar(
                    backgroundColor: AppColor.primary,
                    child: Icon(Icons.payment, color: Colors.white),
                  ),
                  title: Text(
                    "₽ $amount ",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text("User: $userEmail"),
                      Text("Method: $paymentMethod"),
                      if (timestamp != null)
                        Text("Date: ${DateFormat('yyyy-MM-dd – hh:mm a').format(timestamp)}"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
