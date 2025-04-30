// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hvatai_admin_panel/admin/approvedUsers/voice_recording_widget.dart';
// import 'package:hvatai_admin_panel/components/Appcolors.dart';
// import 'package:hvatai_admin_panel/controllers/user_controller.dart';
// import 'package:intl/intl.dart';

// class AllUsersScreen extends StatefulWidget {
//   @override
//   _AllUsersScreenState createState() => _AllUsersScreenState();
// }

// class _AllUsersScreenState extends State<AllUsersScreen> {
//   final UserController userController = Get.put(UserController());

//   String? selectedAgeGroup;
//   String? selectedLocation;
//   String searchQuery = '';
//   int currentPage = 0;
//   final int rowsPerPage = 50;

//   final List<String> ageGroups = [
//     'Less than 20',
//     '20-29',
//     '30-39',
//     '40-49',
//     '50+',
//     'Decline',
//   ];

//   final List<String> locations = [
//     'North America',
//     'South America',
//     'Europe',
//     'Africa',
//     'Asia',
//     'Australia',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double fontSize = screenWidth > 1024 ? 18 : (screenWidth > 600 ? 14 : 12);

//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//         title: Text("All Users"),
//       ),
//       body: Obx(() {
//         if (userController.allUsers.isEmpty) {
//           return Center(child: Text("No Users Found"));
//         }

//         final sortedUsers = userController.allUsers
//           ..sort((a, b) {
//             final dateA =
//                 a.createdDate ?? DateTime.fromMillisecondsSinceEpoch(0);
//             final dateB =
//                 b.createdDate ?? DateTime.fromMillisecondsSinceEpoch(0);
//             return dateB.compareTo(dateA);
//           });

//         final filteredUsers = sortedUsers.where((user) {
//           final matchesAgeGroup =
//               selectedAgeGroup == null || user.country == selectedAgeGroup;
//           final matchesLocation =
//               selectedLocation == null || user.city == selectedLocation;
//           final matchesQuery = searchQuery.isEmpty ||
//               (user.name ?? '...')
//                   .toLowerCase()
//                   .contains(searchQuery.toLowerCase());
//           return matchesAgeGroup && matchesLocation && matchesQuery;
//         }).toList();

//         // Pagination logic
//         final startIndex = currentPage * rowsPerPage;
//         final endIndex = (startIndex + rowsPerPage < filteredUsers.length)
//             ? startIndex + rowsPerPage
//             : filteredUsers.length;

//         final paginatedUsers = filteredUsers.sublist(startIndex, endIndex);

//         return Center(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 // Search Row
//                 ConstrainedBox(
//                   constraints: BoxConstraints(
//                     maxWidth: MediaQuery.of(context).size.width * 0.6,
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 12.0, vertical: 8.0),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           flex: 3,
//                           child: TextField(
//                             decoration: InputDecoration(
//                               labelText: 'Search by Name',
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(color: AppColor.primary),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(color: AppColor.primary),
//                               ),
//                               border: OutlineInputBorder(
//                                 borderSide: BorderSide(color: AppColor.primary),
//                               ),
//                               prefixIcon: Icon(
//                                 Icons.search,
//                                 color: AppColor.primary,
//                               ),
//                             ),
//                             onChanged: (value) {
//                               setState(() {
//                                 searchQuery = value;
//                                 currentPage = 0; // Reset page on search
//                               });
//                             },
//                           ),
//                         ),
//                         SizedBox(width: 12),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8.0),
//                   child: Text(
//                     "Total Count: ${filteredUsers.length}",
//                     style: TextStyle(
//                       fontSize: fontSize,
//                       fontWeight: FontWeight.bold,
//                       color: AppColor.primary,
//                     ),
//                   ),
//                 ),
//                 // "No Results" Message
//                 if (filteredUsers.isEmpty)
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Text(
//                       "No results found",
//                       style: TextStyle(
//                         fontSize: fontSize,
//                         color: Colors.red,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   )
//                 else
//                   Column(
//                     children: [
//                       // Data Table
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: DataTable(
//                           columnSpacing: 20,
//                           headingRowColor: MaterialStateColor.resolveWith(
//                             (states) => AppColor.primary,
//                           ),
//                           border: TableBorder.all(
//                             color: Colors.grey.shade400,
//                             width: 1,
//                           ),
//                           columns: [
//                             DataColumn(
//                               label: Text(
//                                 'Name',
//                                 style: TextStyle(
//                                   fontSize: fontSize - 2,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             DataColumn(
//                               label: Text(
//                                 'Email',
//                                 style: TextStyle(
//                                   fontSize: fontSize - 2,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             DataColumn(
//                               label: Text(
//                                 'Gender',
//                                 style: TextStyle(
//                                   fontSize: fontSize - 2,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             DataColumn(
//                               label: Text(
//                                 'Country',
//                                 style: TextStyle(
//                                   fontSize: fontSize - 4,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             // DataColumn(
//                             //   label: Text(
//                             //     'Voice',
//                             //     style: TextStyle(
//                             //       fontSize: fontSize - 2,
//                             //       color: Colors.white,
//                             //       fontWeight: FontWeight.bold,
//                             //     ),
//                             //   ),
//                             // ),
//                             // DataColumn(
//                             //   label: Text(
//                             //     'Occupation',
//                             //     style: TextStyle(
//                             //       fontSize: fontSize - 2,
//                             //       color: Colors.white,
//                             //       fontWeight: FontWeight.bold,
//                             //     ),
//                             //   ),
//                             // ),
//                             DataColumn(
//                               label: Text(
//                                 'City',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: fontSize - 2,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             // DataColumn(
//                             //   label: Text(
//                             //     'Created Date',
//                             //     style: TextStyle(
//                             //       color: Colors.white,
//                             //       fontSize: fontSize - 2,
//                             //       fontWeight: FontWeight.bold,
//                             //     ),
//                             //   ),
//                             // ),
//                           ],
//                           rows: paginatedUsers.map((user) {
//                             final String voiceRecordingUrl =
//                                 user.voiceRecording.toString();
//                             return DataRow(cells: [
//                               DataCell(
//                                 Text(
//                                   user.name ?? "Unknown Name",
//                                   style: TextStyle(
//                                     fontSize: fontSize - 4,
//                                     color: const Color(0xFF333333),
//                                   ),
//                                 ),
//                               ),
//                               DataCell(
//                                 Text(
//                                   user.email ?? "No Contact Info",
//                                   style: TextStyle(
//                                     fontSize: fontSize - 4,
//                                     color: const Color(0xFF777777),
//                                   ),
//                                 ),
//                               ),
//                               DataCell(
//                                 Text(
//                                   user.gender ?? "Unknown Status",
//                                   style: TextStyle(
//                                     fontSize: fontSize - 4,
//                                     color: const Color(0xFF777777),
//                                   ),
//                                 ),
//                               ),
//                               DataCell(
//                                 Text(
//                                   user.country ?? "Unknown Status",
//                                   style: TextStyle(
//                                     fontSize: fontSize - 4,
//                                     color: const Color(0xFF777777),
//                                   ),
//                                 ),
//                               ),
//                               // DataCell(VoiceRecordingWidget(
//                               //   audioUrl: voiceRecordingUrl,
//                               // )),
//                               // DataCell(
//                               //   Text(
//                               //     user.occupation ?? "Unknown Status",
//                               //     style: TextStyle(
//                               //       fontSize: fontSize - 4,
//                               //       color: const Color(0xFF777777),
//                               //     ),
//                               //   ),
//                               // ),
//                               DataCell(
//                                 Text(
//                                   user.city ?? "Unknown Status",
//                                   style: TextStyle(
//                                     fontSize: fontSize - 4,
//                                     color: const Color(0xFF777777),
//                                   ),
//                                 ),
//                               ),
//                               // DataCell(
//                               //   Text(
//                               //     user.createdDate != null
//                               //         ? DateFormat('dd MMM yyyy, HH:mm')
//                               //             .format(user.createdDate!)
//                               //         : "No Date",
//                               //     style: TextStyle(
//                               //       fontSize: fontSize - 4,
//                               //       color: const Color(0xFF777777),
//                               //     ),
//                               //   ),
//                               // ),
//                             ]);
//                           }).toList(),
//                         ),
//                       ),
//                       // Pagination Controls
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           if (currentPage > 0)
//                             ElevatedButton(
//                               onPressed: () {
//                                 setState(() {
//                                   currentPage--;
//                                 });
//                               },
//                               child: const Text("Previous"),
//                             ),
//                           SizedBox(width: 12),
//                           if (endIndex < filteredUsers.length)
//                             ElevatedButton(
//                               onPressed: () {
//                                 setState(() {
//                                   currentPage++;
//                                 });
//                               },
//                               child: const Text("Next"),
//                             ),
//                         ],
//                       ),
//                     ],
//                   ),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hvatai_admin_panel/components/Appcolors.dart';
// import 'package:hvatai_admin_panel/controllers/user_controller.dart';

// class AllUsersScreen extends StatefulWidget {
//   @override
//   _AllUsersScreenState createState() => _AllUsersScreenState();
// }

// class _AllUsersScreenState extends State<AllUsersScreen> {
//   final UserController userController = Get.put(UserController());

//   String searchName = '';
//   String searchEmail = '';
//   String searchCountry = '';
//   String searchCity = '';
//   int currentPage = 0;
//   final int rowsPerPage = 15;

//   String? sortBy;
//   bool ascending = true;

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double fontSize = screenWidth > 1024 ? 18 : (screenWidth > 600 ? 14 : 12);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("All Users"),
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//       ),
//       body: Obx(() {
//         if (userController.allUsers.isEmpty) {
//           return Center(child: Text("No Users Found"));
//         }

//         var users = userController.allUsers;

//         // Filtering
//         final filtered = users.where((user) {
//           return (user.name?.toLowerCase().contains(searchName.toLowerCase()) ?? false) &&
//                  (user.email?.toLowerCase().contains(searchEmail.toLowerCase()) ?? false) &&
//                  (user.country?.toLowerCase().contains(searchCountry.toLowerCase()) ?? false) &&
//                  (user.city?.toLowerCase().contains(searchCity.toLowerCase()) ?? false);
//         }).toList();

//         // Sorting
//         if (sortBy != null) {
//           filtered.sort((a, b) {
//             var valA = getField(a, sortBy!);
//             var valB = getField(b, sortBy!);
//             return ascending
//               ? valA.compareTo(valB)
//               : valB.compareTo(valA);
//           });
//         }

//         final total = filtered.length;
//         final start = currentPage * rowsPerPage;
//         final end = (start + rowsPerPage > total) ? total : start + rowsPerPage;
//         final pageData = filtered.sublist(start, end);

//         return Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.all(12),
//               child: Wrap(
//                 spacing: 12,
//                 runSpacing: 12,
//                 children: [
//                   buildSearchField('Name', searchName, (val) => setState(() => searchName = val)),
//                   buildSearchField('Email', searchEmail, (val) => setState(() => searchEmail = val)),
//                   buildSearchField('Country', searchCountry, (val) => setState(() => searchCountry = val)),
//                   buildSearchField('City', searchCity, (val) => setState(() => searchCity = val)),
//                 ],
//               ),
//             ),
//             Text("Total Users: \$total", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             Expanded(
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: DataTable(
//                   sortAscending: ascending,
//                   sortColumnIndex: getSortColumnIndex(),
//                   headingRowColor: MaterialStateColor.resolveWith((_) => AppColor.primary),
//                   columns: [
//                     buildColumn('Name', 0),
//                     buildColumn('Email', 1),
//                     buildColumn('Country', 2),
//                     buildColumn('City', 3),
//                     DataColumn(label: Text('Actions', style: TextStyle(color: Colors.white))),
//                   ],
//                   rows: pageData.map((user) => DataRow(cells: [
//                     DataCell(Text(user.name ?? '-')),
//                     DataCell(Text(user.email ?? '-')),
//                     DataCell(Text(user.country ?? '-')),
//                     DataCell(Text(user.city ?? '-')),
//                     DataCell(Row(children: [
//                       TextButton(
//                         onPressed: () => blockUser(user.userId!),
//                         child: Text('Block', style: TextStyle(color: Colors.red)),
//                       ),
//                       TextButton(
//                         onPressed: () => _showUserDetailsDialog(context,user.toJson()),
//                         child: Text('View', style: TextStyle(color: Colors.blue)),
//                       ),
//                     ])),
//                   ])).toList(),
//                 ),
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   onPressed: currentPage > 0 ? () => setState(() => currentPage--) : null,
//                   child: Text("Previous"),
//                 ),
//                 SizedBox(width: 12),
//                 ElevatedButton(
//                   onPressed: end < total ? () => setState(() => currentPage++) : null,
//                   child: Text("Next"),
//                 ),
//               ],
//             )
//           ],
//         );
//       }),
//     );
//   }

//   DataColumn buildColumn(String title, int index) {
//     return DataColumn(
//       label: Text(title, style: TextStyle(color: Colors.white)),
//       onSort: (_, __) {
//         setState(() {
//           if (sortBy == title.toLowerCase()) {
//             ascending = !ascending;
//           } else {
//             sortBy = title.toLowerCase();
//             ascending = true;
//           }
//         });
//       },
//     );
//   }

//   int? getSortColumnIndex() {
//     switch (sortBy) {
//       case 'name': return 0;
//       case 'email': return 1;
//       case 'country': return 2;
//       case 'city': return 3;
//     }
//     return null;
//   }

//   Widget buildSearchField(String hint, String value, Function(String) onChanged) {
//     return SizedBox(
//       width: 220,
//       child: TextField(
//         decoration: InputDecoration(
//           labelText: hint,
//           border: OutlineInputBorder(),
//         ),
//         onChanged: onChanged,
//       ),
//     );
//   }

//   Comparable getField(dynamic user, String field) {
//     switch (field) {
//       case 'name': return user.name ?? '';
//       case 'email': return user.email ?? '';
//       case 'country': return user.country ?? '';
//       case 'city': return user.city ?? '';
//     }
//     return '';
//   }

//   void blockUser(String userId) {
//     userController.blockUser(userId);
//     Get.snackbar("Blocked", "User \$userId has been blocked");
//   }

// void _showUserDetailsDialog(BuildContext context, Map<String, dynamic> userData) {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: const Text('User Details'),
//         content: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _infoRow('Name', '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}'),
//               _infoRow('Email', userData['email']),
//               _infoRow('Gender', userData['gender']),
//               _infoRow('Country', userData['country']),
//               _infoRow('City', userData['city']),
//               _infoRow('Street', userData['street']),
//               _infoRow('Apartment', userData['apartment']),
//               _infoRow('Interests', (userData['interests'] as List?)?.join(', ')),
//               _infoRow('Detailed Interests', (userData['detailedInterests'] as List?)?.join(', ')),
//               _infoRow('Blocked', userData['isBlocked'] == true ? 'Yes' : 'No'),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Close'),
//           ),
//         ],
//       );
//     },
//   );
// }

// Widget _infoRow(String label, dynamic value) {
//   return Padding(
//     padding: const EdgeInsets.only(bottom: 8.0),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
//         Expanded(child: Text(value?.toString() ?? 'N/A')),
//       ],
//     ),
//   );
// }

// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hvatai_admin_panel/components/Appcolors.dart';
import 'package:hvatai_admin_panel/controllers/user_controller.dart';

class AllUsersScreen extends StatefulWidget {
  @override
  _AllUsersScreenState createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  final UserController userController = Get.put(UserController());

  String searchName = '';
  String searchEmail = '';
  String searchCountry = '';
  String searchCity = '';
  String? selectedBlockedStatus = 'All';
  int currentPage = 0;
  final int rowsPerPage = 15;

  String? sortBy;
  bool ascending = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth > 1024 ? 18 : (screenWidth > 600 ? 14 : 12);

    return Scaffold(
      appBar: AppBar(
        title: Text("All Users"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (userController.allUsers.isEmpty) {
          return Center(child: Text("No Users Found"));
        }

        var users = userController.allUsers;

        final filtered = users.where((user) {
          final matchesName =
              user.name?.toLowerCase().contains(searchName.toLowerCase()) ??
                  false;
          final matchesEmail =
              user.email?.toLowerCase().contains(searchEmail.toLowerCase()) ??
                  false;
          final matchesCountry = user.country
                  ?.toLowerCase()
                  .contains(searchCountry.toLowerCase()) ??
              false;
          final matchesCity =
              user.city?.toLowerCase().contains(searchCity.toLowerCase()) ??
                  false;
          final isBlocked = user.isBlocked ?? false;
          final matchesBlocked = selectedBlockedStatus == 'All' ||
              (selectedBlockedStatus == 'Blocked' && isBlocked) ||
              (selectedBlockedStatus == 'Unblocked' && !isBlocked);

          return matchesName &&
              matchesEmail &&
              matchesCountry &&
              matchesCity &&
              matchesBlocked;
        }).toList();

        if (sortBy != null) {
          filtered.sort((a, b) {
            var valA = getField(a, sortBy!);
            var valB = getField(b, sortBy!);
            return ascending ? valA.compareTo(valB) : valB.compareTo(valA);
          });
        }

        final total = filtered.length;
        final start = currentPage * rowsPerPage;
        final end = (start + rowsPerPage > total) ? total : start + rowsPerPage;
        final pageData = filtered.sublist(start, end);

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  buildSearchField('Name', searchName,
                      (val) => setState(() => searchName = val)),
                  buildSearchField('Email', searchEmail,
                      (val) => setState(() => searchEmail = val)),
                  buildSearchField('Country', searchCountry,
                      (val) => setState(() => searchCountry = val)),
                  buildSearchField('City', searchCity,
                      (val) => setState(() => searchCity = val)),
                  DropdownButton<String>(
                    value: selectedBlockedStatus,
                    items: ['All', 'Blocked', 'Unblocked'].map((status) {
                      return DropdownMenuItem(
                          value: status, child: Text(status));
                    }).toList(),
                    onChanged: (val) =>
                        setState(() => selectedBlockedStatus = val),
                  ),
                ],
              ),
            ),
            Text("Total Users: $total",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  sortAscending: ascending,
                  sortColumnIndex: getSortColumnIndex(),
                  headingRowColor:
                      MaterialStateColor.resolveWith((_) => AppColor.primary),
                  columns: [
                    buildColumn('Name', 0),
                    buildColumn('Email', 1),
                    buildColumn('Country', 2),
                    buildColumn('City', 3),
                    DataColumn(
                        label: Text('Actions',
                            style: TextStyle(color: Colors.white))),
                  ],
                  rows: pageData
                      .map((user) => DataRow(cells: [
                            DataCell(Text(user.name ?? '-')),
                            DataCell(Text(user.email ?? '-')),
                            DataCell(Text(user.country ?? '-')),
                            DataCell(Text(user.city ?? '-')),
                            DataCell(Row(children: [
                              TextButton(
                                onPressed: () {
                                  if (user.isBlocked == true) {
                                    _showConfirmationDialog(
                                      context,
                                      title: "Unblock User",
                                      content:
                                          "Are you sure you want to unblock this user?",
                                      onConfirm: () =>
                                          unblockUser(user.userId!,user.name!),
                                    );
                                  } else {
                                    _showConfirmationDialog(
                                      context,
                                      title: "Block User",
                                      content:
                                          "Are you sure you want to block this user?",
                                      onConfirm: () => blockUser(user.userId!,user.name!),
                                    );
                                  }
                                },
                                child: Text(
                                  user.isBlocked == true ? 'Unblock' : 'Block',
                                  style: TextStyle(
                                      color: user.isBlocked == true
                                          ? Colors.green
                                          : Colors.red),
                                ),
                              ),
                              TextButton(
                                onPressed: () => _showUserDetailsDialog(
                                    context, user.toJson()),
                                child: Text('View',
                                    style: TextStyle(color: Colors.blue)),
                              ),
                            ])),
                          ]))
                      .toList(),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: currentPage > 0
                      ? () => setState(() => currentPage--)
                      : null,
                  child: Text("Previous"),
                ),
                SizedBox(width: 12),
                ElevatedButton(
                  onPressed:
                      end < total ? () => setState(() => currentPage++) : null,
                  child: Text("Next"),
                ),
              ],
            )
          ],
        );
      }),
    );
  }

  DataColumn buildColumn(String title, int index) {
    return DataColumn(
      label: Text(title, style: TextStyle(color: Colors.white)),
      onSort: (_, __) {
        setState(() {
          if (sortBy == title.toLowerCase()) {
            ascending = !ascending;
          } else {
            sortBy = title.toLowerCase();
            ascending = true;
          }
        });
      },
    );
  }

  int? getSortColumnIndex() {
    switch (sortBy) {
      case 'name':
        return 0;
      case 'email':
        return 1;
      case 'country':
        return 2;
      case 'city':
        return 3;
    }
    return null;
  }

  Widget buildSearchField(
      String hint, String value, Function(String) onChanged) {
    return SizedBox(
      width: 220,
      child: TextField(
        decoration: InputDecoration(
          labelText: hint,
          border: OutlineInputBorder(),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Comparable getField(dynamic user, String field) {
    switch (field) {
      case 'name':
        return user.name ?? '';
      case 'email':
        return user.email ?? '';
      case 'country':
        return user.country ?? '';
      case 'city':
        return user.city ?? '';
    }
    return '';
  }

  void blockUser(String userId,String name) {
    userController.blockUser(userId);
    Get.snackbar("Blocked", "User $name has been blocked");
  }

  void unblockUser(String userId,String name) {
    userController.UnblockUser(userId);
    Get.snackbar("Unblocked", "User $name has been unblocked");
  }

  void _showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColor.primary),
            child: const Text("Yes", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showUserDetailsDialog(
      BuildContext context, Map<String, dynamic> userData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('User Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow('Name',
                    '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}'),
                _infoRow('Email', userData['email']),
                _infoRow('Gender', userData['gender']),
                _infoRow('Country', userData['country']),
                _infoRow('City', userData['city']),
                _infoRow('Street', userData['street']),
                _infoRow('Apartment', userData['apartment']),
                _infoRow(
                    'Interests', (userData['interests'] as List?)?.join(', ')),
                _infoRow('Detailed Interests',
                    (userData['detailedInterests'] as List?)?.join(', ')),
                _infoRow(
                    'Blocked', userData['isBlocked'] == true ? 'Yes' : 'No'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _infoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value?.toString() ?? 'N/A')),
        ],
      ),
    );
  }
}
