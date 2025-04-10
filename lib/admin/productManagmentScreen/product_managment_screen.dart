import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hvatai_admin_panel/components/Appcolors.dart';
import 'package:intl/intl.dart';

import '../../product_edit.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  State<ProductManagementScreen> createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<Product> products = []; // List of products to be populated from Firestore

  final List<String> categories = [
    "Akceccyapы",
    "Jewelry",
    "Clothing",
    "Accessories",
  ];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  // Fetch products along with their admin and bidders details
  Future<void> _fetchProducts() async {
    final snapshot = await _firestore.collection('products').get();
    final productList = await Future.wait(snapshot.docs.map((doc) async {
      final productData = doc.data();
      final adminId = productData['id']; // Fetch adminId from the product document
      print('Admin ID: $adminId'); // Debugging line

      final adminSnapshot = await _firestore.collection('UserEntity').doc(adminId).get();
      final adminData = adminSnapshot.data() ?? {}; // Admin details
      print('Admin Data: $adminData'); // Debugging line

      final bidders = Map<String, dynamic>.from(productData['bidders'] ?? {});
      print('Bidders: $bidders'); // Debugging line

      final bidderDetails = await Future.wait(bidders.keys.map((bidderId) async {
        final bidderSnapshot = await _firestore.collection('UserEntity').doc(bidderId).get();
        final bidderData = bidderSnapshot.data() ?? {}; // Fetch bidder data
        final bidPrice = bidders[bidderId]; // Get the bid price associated with the bidder
        print('Bidder Data: $bidderData, Bid Price: $bidPrice'); // Debugging line
        return {
          'user': bidderData, // Bidder data
          'bidPrice': bidPrice, // Bid price
        };
      }));


      return Product(
        id: doc.id, // Use docId for the product itself
        title: productData['title'] ?? '', // Default values if null
        description: productData['description'] ?? '',
        category: productData['category'] ?? '',
        price: _safeToDouble(productData['price']), // Safe conversion for price
        quantity: _safeToInt(productData['quantity']), // Safe conversion for quantity
        images: List<String>.from(productData['images'] ?? []),
        isActive: productData['isActive'] ?? false,
        isSold: productData['isSold'] ?? false,
        liveOnly: productData['liveOnly'] ?? false,
        saleType: productData['saleType'] ?? "Buy Now", // Default value if null
        startingBid: _safeToDouble(productData['startingBid']), // Safe conversion for startingBid
        admin: adminData, // Store admin data here
        bidders: bidderDetails, // Store bidder details here
      );
    }).toList());

    setState(() {
      products.addAll(productList);
    });
  }

  // Safe method to convert to double with default value handling
  double _safeToDouble(dynamic value) {
    if (value is String) {
      return double.tryParse(value) ?? 0.0; // Try parsing string to double, if it fails, return 0.0
    }
    return value?.toDouble() ?? 0.0; // If it's already a double or null, return 0.0
  }

  // Safe method to convert to int with default value handling
  int _safeToInt(dynamic value) {
    if (value is String) {
      return int.tryParse(value) ?? 0; // Try parsing string to int, if it fails, return 0
    }
    return value?.toInt() ?? 0; // If it's already an int or null, return 0
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        title: const Text('Product Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'All Products',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(
                    product: product,
                    onEdit: () => _editProduct(product),
                    onToggleStatus: () => _toggleProductStatus(product),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editProduct(Product product) {
    showDialog(
      context: context,
      builder: (context) => ProductEditDialog(
        product: product,
        categories: categories,
        onSave: (updatedProduct) {
          setState(() {
            final index = products.indexOf(product);
            products[index] = updatedProduct;
          });
        },
      ),
    );
  }

  void _toggleProductStatus(Product product) {
    setState(() {
      final index = products.indexOf(product);
      products[index] = product.copyWith(isActive: !product.isActive);
    });
  }
}

class Product {
  final String id;
  final String title;
  final String description;
  final String category;
  final double price;
  final int quantity;
  final List<String> images;
  bool isActive;
  final bool isSold;
  final bool liveOnly;
  final String saleType;
  final double startingBid;
  final Map<String, dynamic> admin;
  final List<Map<String, dynamic>> bidders;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.quantity,
    required this.images,
    required this.isActive,
    required this.isSold,
    required this.liveOnly,
    required this.saleType,
    required this.startingBid,
    required this.admin,
    required this.bidders,
  });

  Product copyWith({
    String? title,
    String? description,
    String? category,
    double? price,
    int? quantity,
    List<String>? images,
    bool? isActive,
    bool? isSold,
    bool? liveOnly,
    String? saleType,
    double? startingBid,
  }) {
    return Product(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      images: images ?? this.images,
      isActive: isActive ?? this.isActive,
      isSold: isSold ?? this.isSold,
      liveOnly: liveOnly ?? this.liveOnly,
      saleType: saleType ?? this.saleType,
      startingBid: startingBid ?? this.startingBid,
      admin: admin,
      bidders: bidders,
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onToggleStatus;

  const ProductCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product.images.isNotEmpty)
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(product.images.first),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                    ),
                    child: const Icon(Icons.image, size: 40),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: product.isActive
                                  ? Colors.green[50]
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              product.isActive ? 'Active' : 'Inactive',
                              style: TextStyle(
                                color: product.isActive
                                    ? Colors.green
                                    : Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.category, size: 16),
                          const SizedBox(width: 4),
                          Text(product.category),
                          const SizedBox(width: 16),
                          const Icon(Icons.attach_money, size: 16),
                          const SizedBox(width: 4),
                          Text('\$${product.price.toStringAsFixed(2)}'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Admin Details (fetched separately)
                      Text(
                        'Admin: ${product.admin['firstName'] ?? 'N/A'} ${product.admin['lastName'] ?? 'N/A'}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      // Display Bidders Details
                      const Text('Bidders:'),
                      ...product.bidders.map((bidder) {
                        return Row(
                          children: [
                            const Icon(Icons.person, size: 16),
                            const SizedBox(width: 4),
                            Text('${bidder['user']['firstName']} ${bidder['user']['lastName']} - Bid: \$${bidder['bidPrice']}'),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.inventory, size: 16),
                    const SizedBox(width: 4),
                    Text('Qty: ${product.quantity}'),
                    const SizedBox(width: 16),
                    const Icon(Icons.sell, size: 16),
                    const SizedBox(width: 4),
                    Text(product.saleType),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        product.isActive ? Icons.toggle_on : Icons.toggle_off,
                        color: product.isActive ? Colors.blue : Colors.grey,
                        size: 30,
                      ),
                      onPressed: onToggleStatus,
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: onEdit,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
