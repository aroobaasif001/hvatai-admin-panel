import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hvatai_admin_panel/components/Appcolors.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({Key? key}) : super(key: key);

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _subcategoryController = TextEditingController();
  final List<String> _subcategories = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _addSubcategory() {
    final sub = _subcategoryController.text.trim();
    if (sub.isNotEmpty) {
      setState(() {
        _subcategories.add(sub);
        _subcategoryController.clear();
      });
    }
  }

  Future<void> _saveCategory() async {
    final categoryName = _categoryController.text.trim();
    if (categoryName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category name is required')),
      );
      return;
    }

    await _firestore.collection('categories').doc(categoryName).set({
      'name': categoryName, // Save as field 'name'
      'subcategories': _subcategories,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Category saved successfully')),
    );

    setState(() {
      _categoryController.clear();
      _subcategoryController.clear();
      _subcategories.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Add Product Category', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: AppColor.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(
                labelText: 'Category Name *',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _subcategoryController,
                    decoration: InputDecoration(
                      labelText: 'Subcategory (optional)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addSubcategory,
                  child: const Text('Add',style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColor.primary),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_subcategories.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Subcategories:',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: _subcategories
                    .map((sub) => Chip(
                  label: Text(sub),
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () {
                    setState(() => _subcategories.remove(sub));
                  },
                ))
                    .toList(),
              ),
              const SizedBox(height: 20),
            ],
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveCategory,
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text('Save Category', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor: AppColor.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
