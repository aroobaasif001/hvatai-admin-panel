import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hvatai_admin_panel/admin/approvedUsers/approved_user_screen.dart';
import 'package:hvatai_admin_panel/components/Appcolors.dart';
import 'package:hvatai_admin_panel/screens/loginScreens/login_screen.dart';
import '../allUsersScreen/all_user_screen.dart';
import '../analyticsScreen/analytics_screen.dart';
import '../blocked_users/blocked_users.dart';
import '../newUserScreen/new_users_screen.dart';
import '../productManagmentScreen/product_managment_screen.dart';
import '../streamScreen/stream_managment_screen.dart';
import '../transactionAndBids/transactions_and_bid_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey();

  int currentPage = 0;

  final List<Widget> pages = [
    AnalyticsScreen(),
    AllUsersScreen(),
  //  NewUsersScreen(),
    BlockedSellerScreen(),
    StreamManagementScreen(),
    ProductManagementScreen(),
   // TransactionsAndBidScreen(),

    // BlockedSellerScreen(),
  ];
  void changePage(int index) {
    setState(() {
      currentPage = index;
    });
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColor.primary,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: AppColor.primary),
              child: Center(child: Container()
                  //  Image.asset(
                  //   'assets/logo1.png',
                  //   height: 80,
                  // ),
                  ),
            ),
            _buildDrawerTile(
              context,
              icon: Icons.analytics_outlined,
              title: 'Analytics',
              index: 0,
            ),
            _buildDrawerTile(
              context,
              icon: Icons.person_3_outlined,
              title: 'All Users',
              index: 1,
            ),
            // _buildDrawerTile(
            //   context,
            //   icon: Icons.new_label,
            //   title: 'New Users',
            //   index: 2,
            // ),
            _buildDrawerTile(
              context,
              icon: Icons.block_outlined,
              title: 'Blocked Users',
              index: 2,
            ),
            _buildDrawerTile(
              context,
              icon: Icons.approval_rounded,
              title: 'Streams Management',
              index: 3,
            ),
            _buildDrawerTile(
              context,
              icon: Icons.new_label_rounded,
              title: 'Product Management',
              index: 4,
            ),
            // _buildDrawerTile(
            //   context,
            //   icon: Icons.money_outlined,
            //   title: 'Transactions & Bids',
            //   index: 5,
            // ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.primary,
        centerTitle: false,
        title: Text(
          'Welcome Admin 👋',
          style: TextStyle(
            color: AppColor.whiteColor,
            fontSize: 15,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu, color: AppColor.whiteColor),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Error signing out. Please try again.")),
                  );
                }
              },
              icon: Icon(
                Icons.logout_outlined,
                color: Colors.white,
              ))
        ],
      ),
      drawer: _buildDrawer(context),
      body: pages[currentPage],
    );
  }

  Widget _buildDrawerTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required int index,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: currentPage == index ? Colors.white : Colors.white54,
        size: 30,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: currentPage == index ? Colors.white : Colors.white70,
        ),
      ),
      onTap: () {
        changePage(index);

        Navigator.pop(context);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      tileColor: currentPage == index ? AppColor.primary : Color(0xFF2E3A59),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    );
  }
}
