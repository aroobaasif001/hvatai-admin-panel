import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'widget/stat_card.dart';
import 'widget/top_nav_bar_widget.dart';

class AnalyticsScreen extends StatefulWidget {
  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int userCount = 0;
  int streamCount = 0;
  int productCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    try {
      var usersSnapshot = await _firestore.collection('UserEntity').get();
      var streamsSnapshot = await _firestore.collection('livestreams').get();
      var productsSnapshot = await _firestore.collection('products').get();

      setState(() {
        userCount = usersSnapshot.docs.length;
        streamCount = streamsSnapshot.docs.length;
        productCount = productsSnapshot.docs.length;
      });
    } catch (e) {
      print("Error fetching stats: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(80),
      //   child: TopNavBar(),
      // ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
             
                Divider(thickness: 1, color: Colors.grey[300]),
                Text(
                  'General Statistics',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    StatCard(
                      title: "Total Users",
                      value: "$userCount",
                      icon: FontAwesomeIcons.users,
                      borderColor: Colors.blue,
                    ),
                    StatCard(
                      title: "Total Streams",
                      value: "$streamCount",
                      icon: FontAwesomeIcons.video,
                      borderColor: Colors.purple,
                    ),
                    StatCard(
                      title: "Total Products",
                      value: "$productCount",
                      icon: FontAwesomeIcons.box,
                      borderColor: Colors.green,
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}