import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TransactionsAndBidScreen extends StatefulWidget {
  @override
  _TransactionsAndBidScreenState createState() => _TransactionsAndBidScreenState();
}

class _TransactionsAndBidScreenState extends State<TransactionsAndBidScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy - hh:mm a');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions & Bids History'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Purchase & Bidding History',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('products').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No products found'));
                  }

                  // Filter products that have bidders
                  var productsWithBidders = snapshot.data!.docs.where((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    return data.containsKey('bidders') && 
                           data['bidders'] != null && 
                           (data['bidders'] as Map).isNotEmpty;
                  }).toList();

                  if (productsWithBidders.isEmpty) {
                    return Center(child: Text('No bidding history found'));
                  }

                  return ListView.builder(
                    itemCount: productsWithBidders.length,
                    itemBuilder: (context, index) {
                      var product = productsWithBidders[index];
                      var productData = product.data() as Map<String, dynamic>;
                      var bidders = productData['bidders'] as Map<String, dynamic>;

                      return Card(
                        margin: EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productData['category'] ?? 'No Category',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                productData['description'] ?? 'No Description',
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(height: 16),
                              Divider(),
                              Text(
                                'Bidding History',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              ...bidders.entries.map((entry) {
                                return FutureBuilder<DocumentSnapshot>(
                                  future: _firestore.collection('UserEntity').doc(entry.key).get(),
                                  builder: (context, userSnapshot) {
                                    if (userSnapshot.connectionState == ConnectionState.waiting) {
                                      return ListTile(
                                        leading: CircleAvatar(child: Icon(Icons.person)),
                                        title: Text('Loading...'),
                                        subtitle: Text('Bid: ${entry.value}'),
                                      );
                                    }

                                    if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                                      return ListTile(
                                        leading: CircleAvatar(child: Icon(Icons.person)),
                                        title: Text('User ID: ${entry.key}'),
                                        subtitle: Text('Bid: \$${entry.value}'),
                                      );
                                    }

                                    var userData = userSnapshot.data!.data() as Map<String, dynamic>;
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: userData['photoUrl'] != null
                                            ? NetworkImage(userData['photoUrl'])
                                            : null,
                                        child: userData['photoUrl'] == null
                                            ? Icon(Icons.person)
                                            : null,
                                      ),
                                      title: Text(
                                        userData['firstName'] ?? 'User ID: ${entry.key}',
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (userData['email'] != null)
                                            Text(userData['email']),
                                          Text('Bid: \$${entry.value}'),
                                          if (productData['createdAt'] != null)
                                            Text(
                                              'Date: ${_dateFormat.format((productData['createdAt'] as Timestamp).toDate())}',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(Icons.money, color: Colors.blue),
                                        onPressed: () {
                                          _showRefundDialog(context, userData['firstName'], entry.value);
                                        },
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRefundDialog(BuildContext context, String firstName, dynamic amount) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Process Refund'),
        content: Text('Refund \$$amount to user $firstName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement actual refund logic
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Refund processed successfully')),
              );
              Navigator.pop(context);
            },
            child: Text('Confirm Refund'),
          ),
        ],
      ),
    );
  }
}