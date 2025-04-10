import 'package:flutter/material.dart';
import '../../models/user_model1.dart';

class UserDetailsDialog extends StatelessWidget {
  final UserModel user;

  const UserDetailsDialog({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "User Details",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Table(
              border: TableBorder.all(
                color: Colors.grey,
                style: BorderStyle.solid,
                width: 1,
              ),
              children: [
                _buildTableRow('Name:', user.name ?? "N/A"),
                _buildTableRow('Email:', user.email ?? "N/A"),
                _buildTableRow('User ID:', user.userId ?? "N/A"),
                _buildTableRow('AgeGroup:', user.country ?? "N/A"),
                _buildTableRow('Gender:', user.gender ?? "N/A"),
                _buildTableRow('Location:', user.city ?? "N/A"),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () =>
                    Navigator.of(context).pop(), // Close the dialog
                child: const Text("Close"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create a table row
  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(value),
        ),
      ],
    );
  }
}
