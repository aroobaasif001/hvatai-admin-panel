import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'admin/streamScreen/stream_managment_screen.dart';

class StreamEditDialog extends StatefulWidget {
  final LiveStream stream;
  final Function(LiveStream) onSave;
  final bool isNew;

  const StreamEditDialog({
    super.key,
    required this.stream,
    required this.onSave,
    this.isNew = false,
  });

  @override
  _StreamEditDialogState createState() => _StreamEditDialogState();
}

class _StreamEditDialogState extends State<StreamEditDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String _category;
  late String? _currentFilter;
  late String? _currentMusic;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.stream.title);
    _descriptionController =
        TextEditingController(text: widget.stream.description);
    _category = widget.stream.category;
    _currentFilter = widget.stream.currentFilter;
    _currentMusic = widget.stream.currentMusic;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isNew ? 'Create New Stream' : 'Edit Stream'),
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
            DropdownButtonFormField<String>(
              value: _category,
              items: const [
                DropdownMenuItem(value: 'Shoes', child: Text('Shoes')),
                DropdownMenuItem(value: 'Clothing', child: Text('Clothing')),
                DropdownMenuItem(value: 'Accessories', child: Text('Accessories')),
              ],
              onChanged: (value) {
                setState(() {
                  _category = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: TextEditingController(text: _currentFilter ?? ''),
              decoration: const InputDecoration(
                labelText: 'Current Filter (optional)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _currentFilter = value.isEmpty ? null : value,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: TextEditingController(text: _currentMusic ?? ''),
              decoration: const InputDecoration(
                labelText: 'Current Music (optional)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _currentMusic = value.isEmpty ? null : value,
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
          onPressed: () async {
            final updatedStream = widget.stream.copyWith(
              title: _titleController.text,
              description: _descriptionController.text,
              category: _category,
              currentFilter: _currentFilter,
              currentMusic: _currentMusic,
            );

            // Save updated data to Firebase
            await _updateStreamInFirebase(updatedStream);

            // After saving to Firebase, invoke onSave callback
            widget.onSave(updatedStream);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  // Function to update stream data in Firestore
  Future<void> _updateStreamInFirebase(LiveStream updatedStream) async {
    await FirebaseFirestore.instance.collection('livestreams').doc(updatedStream.id).update({
      'title': updatedStream.title,
      'description': updatedStream.description,
      'category': updatedStream.category,
      'currentFilter': updatedStream.currentFilter,
      'currentMusic': updatedStream.currentMusic,
     // 'status': updatedStream.status == StreamStatus.active ? 'active' : 'completed',
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
