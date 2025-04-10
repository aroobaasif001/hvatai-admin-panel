import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'admin/productManagmentScreen/product_managment_screen.dart';

class ProductEditDialog extends StatefulWidget {
  final Product product;
  final List<String> categories;
  final Function(Product) onSave;
  final bool isNew;

  const ProductEditDialog({
    super.key,
    required this.product,
    required this.categories,
    required this.onSave,
    this.isNew = false,
  });

  @override
  _ProductEditDialogState createState() => _ProductEditDialogState();
}

class _ProductEditDialogState extends State<ProductEditDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;
  late String _category;
  late String _saleType;
  late bool _isActive;
  late bool _liveOnly;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product.title);
    _descriptionController =
        TextEditingController(text: widget.product.description);
    _priceController =
        TextEditingController(text: widget.product.price.toStringAsFixed(2));
    _quantityController =
        TextEditingController(text: widget.product.quantity.toString());
    _category = widget.product.category.isNotEmpty
        ? widget.product.category
        : widget.categories.isNotEmpty
        ? widget.categories[0]
        : '';
    _saleType = widget.product.saleType;
    _isActive = widget.product.isActive;
    _liveOnly = widget.product.liveOnly;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isNew ? 'Add New Product' : 'Edit Product'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      border: OutlineInputBorder(),
                      prefixText: '\$',
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Ensure no duplicate values in category dropdown
            // DropdownButtonFormField<String>(
            //   value: _category.isNotEmpty ? _category : null,
            //   items: widget.categories.map((category) {
            //     return DropdownMenuItem(
            //       value: category,
            //       child: Text(category),
            //     );
            //   }).toList(),
            //   onChanged: (value) {
            //     setState(() {
            //       _category = value!;
            //     });
            //   },
            //   decoration: const InputDecoration(
            //     labelText: 'Category',
            //     border: OutlineInputBorder(),
            //   ),
            // ),
            const SizedBox(height: 16),
            // Sale Type dropdown (ensure unique values)
            DropdownButtonFormField<String>(
              value: _saleType.isNotEmpty ? _saleType : null,
              items: const [
                DropdownMenuItem(value: "Buy Now", child: Text("Buy Now")),
                DropdownMenuItem(value: "Auction", child: Text("Auction")),
              ],
              onChanged: (value) {
                setState(() {
                  _saleType = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Sale Type',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Active Product'),
              value: _isActive,
              onChanged: (value) {
                setState(() {
                  _isActive = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Live Stream Only'),
              value: _liveOnly,
              onChanged: (value) {
                setState(() {
                  _liveOnly = value ?? false;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final updatedProduct = widget.product.copyWith(
              title: _titleController.text,
              description: _descriptionController.text,
              category: _category,
              price: double.tryParse(_priceController.text) ?? 0,
              quantity: int.tryParse(_quantityController.text) ?? 1,
              isActive: _isActive,
              liveOnly: _liveOnly,
              saleType: _saleType,
            );
            _updateProduct(updatedProduct);
            widget.onSave(updatedProduct);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
  void _updateProduct(Product updatedProduct) async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(updatedProduct.id) // Use the correct product ID here
          .update({
        'title': updatedProduct.title,
        'description': updatedProduct.description,
        'category': updatedProduct.category,
        'price': updatedProduct.price,
        'quantity': updatedProduct.quantity,
        'isActive': updatedProduct.isActive,
        'liveOnly': updatedProduct.liveOnly,
        'saleType': updatedProduct.saleType,
      });
      print("Product updated successfully!");
    } catch (e) {
      print("Error updating product: $e");
    }
  }


  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
}
