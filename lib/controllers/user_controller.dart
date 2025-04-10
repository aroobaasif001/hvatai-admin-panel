import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hvatai_admin_panel/models/user_model1.dart';


class UserController extends GetxController {
  RxList<UserModel> allUsers = <UserModel>[].obs;
  RxList<UserModel> newUsers = <UserModel>[].obs;
  RxList<UserModel> blockedUsers = <UserModel>[].obs;
  RxList<UserModel> approvedUsers = <UserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  void loadUsers() {
    FirebaseFirestore.instance
        .collection('UserEntity')
        .snapshots()
        .listen((snapshot) {
      List<UserModel> tempAllUsers = [];
      List<UserModel> tempNewUsers = [];
      List<UserModel> tempBlockedUsers = [];
      List<UserModel> tempApprovedUsers = [];

      for (var doc in snapshot.docs) {
        UserModel user = UserModel.fromJson(doc.data() as Map<String, dynamic>);

        tempAllUsers.add(user);

        if (user.isUserNew == true) {
          tempNewUsers.add(user);
        } else if (user.isBlocked == true) {
          tempBlockedUsers.add(user);
        } else {
          tempApprovedUsers.add(user);
        }
      }

      allUsers.assignAll(tempAllUsers);
      newUsers.assignAll(tempNewUsers);
      blockedUsers.assignAll(tempBlockedUsers);
      approvedUsers.assignAll(tempApprovedUsers);
    });
  }

  Future<void> updateUserStatus(
      String userId, bool isBlocked, bool isUserNew) async {
    try {
      await FirebaseFirestore.instance.collection('UserEntity').doc(userId).update({
        'isBlocked': isBlocked,
        'isUserNew': isUserNew,
      });
    } catch (e) {
      print("Failed to update user $userId: $e");
    }
  }

  void blockUser(String userId) {
    updateUserStatus(userId, true, false);
  }

   void UnblockUser(String userId) {
    updateUserStatus(userId, false, true);
  }

  // void approveUser(String userId) async {
  //   updateUserStatus(userId, false, false);

  // }

  void approveUser(String userId) async {
    try {
      // Update user status
      await updateUserStatus(userId, false, false);

      // Fetch user email from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('UserEntity')
          .doc(userId)
          .get();

      String? userEmail = userDoc.get('email');
      print("User email: $userEmail");

      if (userEmail != null) {
        // Add email details to the mail collection
        await FirebaseFirestore.instance.collection('mail').add({
          'to': userEmail,
          'message': {
            'subject': 'Account Approved',
            'text':
                'Dear User,\n\nYour account has been approved! You can now log in.\n\nThank you!',
          },
        });
        print("Approval email added to the mail collection.");
      } else {
        print("User email is null. Email not sent.");
      }
    } catch (e) {
      print("Error approving user: $e");
    }
  }
}
