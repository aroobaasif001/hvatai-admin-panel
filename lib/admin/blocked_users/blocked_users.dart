import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


import '../../components/Appcolors.dart';
import '../../controllers/user_controller.dart';
import '../approvedUsers/voice_recording_widget.dart';

class BlockedSellerScreen extends StatefulWidget {
  @override
  _BlockedSellerScreenState createState() => _BlockedSellerScreenState();
}

class _BlockedSellerScreenState extends State<BlockedSellerScreen> {
  final UserController userController = Get.put(UserController());
  String? selectedAgeGroup;
  String? selectedLocation;
  String searchQuery = '';
  int currentPage = 0;
  final int rowsPerPage = 50;

  final List<String> ageGroups = [
    'Less than 20',
    '20-29',
    '30-39',
    '40-49',
    '50+',
    'Decline',
  ];

  final List<String> locations = [
    'North America',
    'South America',
    'Europe',
    'Africa',
    'Asia',
    'Australia',
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth > 1024 ? 18 : (screenWidth > 600 ? 14 : 12);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text("Blocked Users"),
      ),
      body: Obx(() {
        if (userController.blockedUsers.isEmpty) {
          return const Center(child: Text("No Blocked Users"));
        }
        final sortedUsers = userController.blockedUsers
          ..sort((a, b) {
            final dateA =
                a.createdDate ?? DateTime.fromMillisecondsSinceEpoch(0);
            final dateB =
                b.createdDate ?? DateTime.fromMillisecondsSinceEpoch(0);
            return dateB.compareTo(dateA);
          });
        final filteredUsers = sortedUsers.where((user) {
          final matchesAgeGroup =
              selectedAgeGroup == null || user.country == selectedAgeGroup;
          final matchesLocation =
              selectedLocation == null || user.city == selectedLocation;
          final matchesQuery = searchQuery.isEmpty ||
              (user.name ?? '...')
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase());
          return matchesAgeGroup && matchesLocation && matchesQuery;
        }).toList();
        final startIndex = currentPage * rowsPerPage;
        final endIndex = (startIndex + rowsPerPage < filteredUsers.length)
            ? startIndex + rowsPerPage
            : filteredUsers.length;

        final paginatedUsers = filteredUsers.sublist(startIndex, endIndex);

        return Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Search by Name',
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColor.primary),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColor.primary),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColor.primary),
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: AppColor.primary,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                                currentPage = 0;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 12),
                        // Expanded(
                        //   flex: 2,
                        //   child: DropdownButtonFormField<String>(
                        //     decoration: InputDecoration(
                        //       labelText: 'Age Group',
                        //       border: OutlineInputBorder(),
                        //     ),
                        //     items: ageGroups.map((age) {
                        //       return DropdownMenuItem<String>(
                        //         value: age,
                        //         child: Text(age),
                        //       );
                        //     }).toList(),
                        //     value: selectedAgeGroup,
                        //     onChanged: (value) {
                        //       setState(() {
                        //         selectedAgeGroup = value;
                        //         currentPage = 0;
                        //       });
                        //     },
                        //   ),
                        // ),
                        // SizedBox(width: 12),
                        // Expanded(
                        //   flex: 2,
                        //   child: DropdownButtonFormField<String>(
                        //     decoration: InputDecoration(
                        //       labelText: 'Location',
                        //       border: OutlineInputBorder(),
                        //     ),
                        //     items: locations.map((location) {
                        //       return DropdownMenuItem<String>(
                        //         value: location,
                        //         child: Text(location),
                        //       );
                        //     }).toList(),
                        //     value: selectedLocation,
                        //     onChanged: (value) {
                        //       setState(() {
                        //         selectedLocation = value;
                        //         currentPage = 0;
                        //       });
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "Total Count: ${filteredUsers.length}",
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primary,
                    ),
                  ),
                ),
                if (filteredUsers.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "No results found",
                      style: TextStyle(
                        fontSize: fontSize,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 20,
                          headingRowColor: MaterialStateColor.resolveWith(
                            (states) => AppColor.primary,
                          ),
                          border: TableBorder.all(
                            color: Colors.grey.shade400,
                            width: 1,
                          ),
                          columns: [
                            DataColumn(
                              label: Text(
                                'Name',
                                style: TextStyle(
                                  fontSize: fontSize,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Email',
                                style: TextStyle(
                                  fontSize: fontSize,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Gender',
                                style: TextStyle(
                                  fontSize: fontSize,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Age Group',
                                style: TextStyle(
                                  fontSize: fontSize,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // DataColumn(
                            //   label: Text(
                            //     'Voice',
                            //     style: TextStyle(
                            //       fontSize: fontSize,
                            //       color: Colors.white,
                            //       fontWeight: FontWeight.bold,
                            //     ),
                            //   ),
                            // ),
                            // DataColumn(
                            //   label: Text(
                            //     'Occupation',
                            //     style: TextStyle(
                            //       fontSize: fontSize,
                            //       color: Colors.white,
                            //       fontWeight: FontWeight.bold,
                            //     ),
                            //   ),
                            // ),
                            DataColumn(
                              label: Text(
                                'Location',
                                style: TextStyle(
                                  fontSize: fontSize,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Actions',
                                style: TextStyle(
                                  fontSize: fontSize,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                          rows: paginatedUsers.map((user) {
                            final String voiceRecordingUrl =
                                user.voiceRecording.toString();
                            return DataRow(cells: [
                              DataCell(
                                Text(
                                  user.name ?? "Unknown Name",
                                  style: TextStyle(
                                    fontSize: fontSize - 4,
                                    color: const Color(0xFF333333),
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  user.email ?? "No Contact Info",
                                  style: TextStyle(
                                    fontSize: fontSize - 4,
                                    color: const Color(0xFF777777),
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  user.gender ?? "Unknown Gender",
                                  style: TextStyle(
                                    fontSize: fontSize - 4,
                                    color: const Color(0xFF777777),
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  user.country ?? "Unknown Age Group",
                                  style: TextStyle(
                                    fontSize: fontSize - 4,
                                    color: const Color(0xFF777777),
                                  ),
                                ),
                              ),
                              // DataCell(VoiceRecordingWidget(
                              //   audioUrl: voiceRecordingUrl,
                              // )),
                              // DataCell(
                              //   Text(
                              //     user.occupation ?? "Unknown Occupation",
                              //     style: TextStyle(
                              //       fontSize: fontSize - 4,
                              //       color: const Color(0xFF777777),
                              //     ),
                              //   ),
                              // ),
                              DataCell(
                                Text(
                                  user.city ?? "Unknown Location",
                                  style: TextStyle(
                                    fontSize: fontSize - 4,
                                    color: const Color(0xFF777777),
                                  ),
                                ),
                              ),
                               DataCell(
                                Row(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        _showConfirmationDialog(
                                          context,
                                          "Unblock User",
                                          "Are you sure you want to Unblock this user?",
                                          () {
                                            userController
                                                .UnblockUser(user.userId!);
                                            Get.snackbar("User Unblocked",
                                                "${user.name} has been Unblocked.");
                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                      child: const Text('UnBlock',
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                    // TextButton(
                                    //   onPressed: () {
                                    //     _showConfirmationDialog(
                                    //       context,
                                    //       "Approve User",
                                    //       "Are you sure you want to approve this user?",
                                    //       () {
                                    //         userController
                                    //             .approveUser(user.userId!);
                                    //         Get.snackbar("User Approved",
                                    //             "${user.name} has been approved.");
                                    //         Navigator.pop(context);
                                    //       },
                                    //     );
                                    //   },
                                    //   child: const Text('Approve',
                                    //       style:
                                    //           TextStyle(color: Colors.green)),
                                    // ),
                                  ],
                                ),
                              ),
                            ]);
                          }).toList(),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (currentPage > 0)
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  currentPage--;
                                });
                              },
                              child: const Text("Previous"),
                            ),
                          SizedBox(width: 12),
                          if (endIndex < filteredUsers.length)
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  currentPage++;
                                });
                              },
                              child: const Text("Next"),
                            ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
    void _showConfirmationDialog(
    BuildContext context,
    String title,
    String content,
    VoidCallback onConfirm,
  ) {
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
            onPressed: onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
            ),
            child: const Text("Yes", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
