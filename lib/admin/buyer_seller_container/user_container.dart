import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model1.dart';
import '../userDetailScreen/user_details_screen.dart';

class UserContainer extends StatelessWidget {
  final UserModel user;

  UserContainer({
    super.key,
    required this.user,
  });

  Future<void> _blockUser(BuildContext context) async {
    bool confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirm Block'),
        content: Text('Are you sure you want to block ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('Block'),
          ),
        ],
      ),
    );

    if (confirm) {
      try {
        await FirebaseFirestore.instance
            .collection('UserEntity')
            .doc(user.userId)
            .update({'isUserNew': 'blocked'});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${user.name} has been blocked.')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to block user: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;

        double fontSize = screenWidth > 1024
            ? 24
            : screenWidth > 800
                ? 22
                : 16;
        double avatarRadius = screenWidth > 1024 ? 30 : 25;
        double padding = screenWidth > 1200 ? 20 : 15;

        return InkWell(
          // onLongPress: () {
          //   _blockUser(context);
          // },
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return UserDetailsDialog(user: user);
              },
            );
          },

          child: Center(
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: padding),
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                width: screenWidth > 1024 ? screenWidth / 2 : double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: ${user.name ?? "Unknown Name"}',
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            user.email ?? "No Contact Info",
                            style: TextStyle(
                              fontSize: fontSize - 4,
                              color: Color(0xFF777777),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      user.status ?? "Unknown Status",
                      style: TextStyle(
                        fontSize: fontSize - 2,
                        color:
                            user.status == 'blocked' ? Colors.red : Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
