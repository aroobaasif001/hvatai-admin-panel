// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:voice_buddies_web/components/Appcolors.dart';
// import 'package:voice_buddies_web/components/snackbar.dart';
// import 'package:voice_buddies_web/models/user_model1.dart';

// class ApprovedSellerDetailedScreen extends StatelessWidget {
//   final UserModel user;

//   const ApprovedSellerDetailedScreen({Key? key, required this.user})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;

//     double containerHeight = screenWidth > 1024
//         ? MediaQuery.of(context).size.height / 4
//         : MediaQuery.of(context).size.height / 5;
//     double containerWidth = screenWidth > 1024
//         ? MediaQuery.of(context).size.width / 4
//         : MediaQuery.of(context).size.width / 1.7;

//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.white),
//         centerTitle: true,
//         title: Text(
//           user.name ?? 'User Details',
//           style: TextStyle(
//             fontSize: screenWidth > 1024 ? 22 : 16,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: AppColor.primary,
//       ),
//       body: SingleChildScrollView(
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             double horizontalPadding = constraints.maxWidth < 600
//                 ? MediaQuery.of(context).size.width / 20
//                 : constraints.maxWidth < 1200
//                     ? MediaQuery.of(context).size.width / 10
//                     : MediaQuery.of(context).size.width / 8;

//             double verticalPadding = MediaQuery.of(context).size.height / 40;

//             return Center(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(
//                     vertical: verticalPadding, horizontal: horizontalPadding),
//                 child: Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   elevation: 8,
//                   shadowColor: Colors.black.withOpacity(0.2),
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(
//                         horizontal: horizontalPadding / 2,
//                         vertical: verticalPadding),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         _buildDetailRow('Name: ', user.name, context),
//                         SizedBox(height: 10),
//                         _buildDetailRow('Phone Number: ', user.phone, context),
//                         SizedBox(height: 10),
//                         _buildDetailRow('Email: ', user.email, context),
//                         SizedBox(height: verticalPadding),
//                         _buildActionButtons(context, user),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String? value, BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: screenWidth > 1024 ? 20 : 16,
//             fontWeight: FontWeight.bold,
//             color: Colors.blue,
//           ),
//         ),
//         Flexible(
//           child: Text(
//             value ?? 'N/A',
//             style: TextStyle(
//               fontSize: screenWidth > 1024 ? 20 : 14,
//               color: Colors.black87,
//             ),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildActionButtons(BuildContext context, UserModel user) {
//     return user.status == "verified"
//         ? _buildBlockButton(context, user)
//         : user.status == "pending"
//             ? Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   _buildBlockButton(context, user),
//                   SizedBox(width: 5.0),
//                   _buildApproveButton(context, user),
//                 ],
//               )
//             : user.status == "new"
//                 ? Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       _buildPendingButton(context, user),
//                       SizedBox(width: 10.0),
//                       _buildApproveButton(context, user),
//                     ],
//                   )
//                 : _buildUnblockButton(context, user);
//   }

//   Widget _buildBlockButton(BuildContext context, UserModel user) {
//     return _buildMaterialButton(
//       context,
//       label: "Block User",
//       color: Colors.red,
//       onPressed: () => _showConfirmationDialog(
//         context,
//         "Block User",
//         "Are you sure you want to block this user?",
//         () {
//           Navigator.pop(context);
//           snackbar("Done", "User blocked successfully");
//         },
//       ),
//     );
//   }

//   Widget _buildApproveButton(BuildContext context, UserModel user) {
//     return _buildMaterialButton(
//       context,
//       label: "Approve User",
//       color: Colors.green,
//       onPressed: () => _showConfirmationDialog(
//         context,
//         "Approve User",
//         "Are you sure you want to approve this user?",
//         () {
//           Navigator.pop(context);
//           snackbar("Done", "User approved successfully");
//         },
//       ),
//     );
//   }

//   Widget _buildPendingButton(BuildContext context, UserModel user) {
//     return _buildMaterialButton(
//       context,
//       label: "Set Pending User",
//       color: Colors.yellow[700]!,
//       onPressed: () => _showConfirmationDialog(
//         context,
//         "Pending User",
//         "Are you sure you want to set this user to pending?",
//         () {
//           Navigator.pop(context);
//           snackbar("Done", "User set to pending successfully");
//         },
//       ),
//     );
//   }

//   Widget _buildUnblockButton(BuildContext context, UserModel user) {
//     return _buildMaterialButton(
//       context,
//       label: "Unblock User",
//       color: Colors.green,
//       onPressed: () => _showConfirmationDialog(
//         context,
//         "Unblock User",
//         "Are you sure you want to unblock this user?",
//         () {
//           Navigator.pop(context);
//           snackbar("Done", "User unblocked successfully");
//         },
//       ),
//     );
//   }

//   Widget _buildMaterialButton(BuildContext context,
//       {required String label,
//       required Color color,
//       required VoidCallback onPressed}) {
//     return MaterialButton(
//       color: color,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       onPressed: onPressed,
//       child: Text(
//         label,
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 14,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }

//   void _showConfirmationDialog(BuildContext context, String title,
//       String content, VoidCallback onConfirm) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text(title),
//         content: Text(content),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text("Cancel"),
//           ),
//           SizedBox(width: 12.0),
//           ElevatedButton(
//             onPressed: onConfirm,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColor.primary,
//             ),
//             child: Text("Yes", style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }
// }


