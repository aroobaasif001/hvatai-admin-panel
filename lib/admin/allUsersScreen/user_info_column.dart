import 'package:flutter/material.dart';
import 'package:hvatai_admin_panel/models/user_model1.dart';


class UserInfoColumn extends StatelessWidget {
  final String title;
  final UserModel? user;

  UserInfoColumn({required this.title, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0XB2000000),
            fontSize: 13,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          user?.name ?? 'Unknown',
          style: const TextStyle(
            color: Color(0XFF000000),
            fontSize: 12,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.phone_outlined, size: 15),
            SizedBox(width: 10),
            Text(
              user?.phone ?? 'No phone number',
              style: const TextStyle(
                color: Color(0XB2000000),
                fontSize: 10,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        user!.email!.isEmpty ? SizedBox(height: 10) : SizedBox(height: 5),
        user!.email!.isEmpty
            ? SizedBox()
            : FittedBox(
                child: Row(
                  children: [
                    Icon(Icons.email_outlined,
                        size: 15,
                        color: Colors
                            .blue), // Assuming `Themecolor.primary` is blue
                    SizedBox(width: 10),
                    Text(
                      user?.email ?? 'No email',
                      style: const TextStyle(
                        color: Color(0XB2000000),
                        fontSize: 10,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
