import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hvatai_admin_panel/admin/approvedUsers/voice_recording_widget.dart';
import 'package:hvatai_admin_panel/components/Appcolors.dart';
import 'package:hvatai_admin_panel/controllers/user_controller.dart';
import 'package:intl/intl.dart';


class AllUsersScreen extends StatefulWidget {
  @override
  _AllUsersScreenState createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
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
        title: Text("All Users"),
      ),
      body: Obx(() {
        if (userController.allUsers.isEmpty) {
          return Center(child: Text("No Users Found"));
        }

        final sortedUsers = userController.allUsers
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

        // Pagination logic
        final startIndex = currentPage * rowsPerPage;
        final endIndex = (startIndex + rowsPerPage < filteredUsers.length)
            ? startIndex + rowsPerPage
            : filteredUsers.length;

        final paginatedUsers = filteredUsers.sublist(startIndex, endIndex);

        return Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Search Row
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
                          flex: 3,
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
                                currentPage = 0; // Reset page on search
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 12),
                //         Expanded(
                //           flex: 2,
                //           child: DropdownButtonFormField<String>(
                //             decoration: InputDecoration(
                //               labelText: 'Age Group',
                //               border: OutlineInputBorder(),
                //             ),
                //             items: ageGroups.map((age) {
                //               return DropdownMenuItem<String>(
                //                 value: age,
                //                 child: Text(age),
                //               );
                //             }).toList(),
                //             value: selectedAgeGroup,
                //             onChanged: (value) {
                //               setState(() {
                //                 selectedAgeGroup = value;
                //                 currentPage = 0; // Reset page on filter change
                //               });
                //             },
                //           ),
                //         ),
                //         SizedBox(width: 12),
                //         Expanded(
                //           flex: 2,
                //           child: DropdownButtonFormField<String>(
                //             decoration: InputDecoration(
                //               labelText: 'Location',
                //               border: OutlineInputBorder(),
                //             ),
                //             items: locations.map((location) {
                //               return DropdownMenuItem<String>(
                //                 value: location,
                //                 child: Text(location),
                //               );
                //             }).toList(),
                //             value: selectedLocation,
                //             onChanged: (value) {
                //               setState(() {
                //                 selectedLocation = value;
                //                 currentPage = 0; // Reset page on filter change
                //               });
                //             },
                //           ),
                //         ),
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
                // "No Results" Message
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
                      // Data Table
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
                                  fontSize: fontSize - 2,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Email',
                                style: TextStyle(
                                  fontSize: fontSize - 2,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Gender',
                                style: TextStyle(
                                  fontSize: fontSize - 2,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Country',
                                style: TextStyle(
                                  fontSize: fontSize - 4,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // DataColumn(
                            //   label: Text(
                            //     'Voice',
                            //     style: TextStyle(
                            //       fontSize: fontSize - 2,
                            //       color: Colors.white,
                            //       fontWeight: FontWeight.bold,
                            //     ),
                            //   ),
                            // ),
                            // DataColumn(
                            //   label: Text(
                            //     'Occupation',
                            //     style: TextStyle(
                            //       fontSize: fontSize - 2,
                            //       color: Colors.white,
                            //       fontWeight: FontWeight.bold,
                            //     ),
                            //   ),
                            // ),
                            DataColumn(
                              label: Text(
                                'City',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: fontSize - 2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // DataColumn(
                            //   label: Text(
                            //     'Created Date',
                            //     style: TextStyle(
                            //       color: Colors.white,
                            //       fontSize: fontSize - 2,
                            //       fontWeight: FontWeight.bold,
                            //     ),
                            //   ),
                            // ),
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
                                  user.gender ?? "Unknown Status",
                                  style: TextStyle(
                                    fontSize: fontSize - 4,
                                    color: const Color(0xFF777777),
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  user.country ?? "Unknown Status",
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
                              //     user.occupation ?? "Unknown Status",
                              //     style: TextStyle(
                              //       fontSize: fontSize - 4,
                              //       color: const Color(0xFF777777),
                              //     ),
                              //   ),
                              // ),
                              DataCell(
                                Text(
                                  user.city ?? "Unknown Status",
                                  style: TextStyle(
                                    fontSize: fontSize - 4,
                                    color: const Color(0xFF777777),
                                  ),
                                ),
                              ),
                              // DataCell(
                              //   Text(
                              //     user.createdDate != null
                              //         ? DateFormat('dd MMM yyyy, HH:mm')
                              //             .format(user.createdDate!)
                              //         : "No Date",
                              //     style: TextStyle(
                              //       fontSize: fontSize - 4,
                              //       color: const Color(0xFF777777),
                              //     ),
                              //   ),
                              // ),
                            ]);
                          }).toList(),
                        ),
                      ),
                      // Pagination Controls
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
}
