import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hvatai_admin_panel/components/Appcolors.dart';
import 'package:intl/intl.dart';

import '../../stream_edit.dart';

class StreamManagementScreen extends StatefulWidget {
  const StreamManagementScreen({super.key});

  @override
  State<StreamManagementScreen> createState() => _StreamManagementScreenState();
}

class _StreamManagementScreenState extends State<StreamManagementScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<LiveStream> streams = [];

  @override
  void initState() {
    super.initState();
    _fetchStreams();
  }

  // Fetch streams from Firestore
  Future<void> _fetchStreams() async {
    final snapshot = await _firestore.collection('livestreams').get();
    setState(() {
      streams = snapshot.docs.map((doc) {
        final data = doc.data();
        return LiveStream(
          id: doc.id,
          title: data['title'],
          description: data['description'],
          category: data['category'],
          channelId: data['channelId'],
          isAdmin: data['isAdmin'],
          viewsCount: data['viewsCount'],
          timestamp: (data['timestamp'] as Timestamp).toDate(),
          currentFilter: data['currentFilter'],
          currentMusic: data['currentMusic'],
          status: data['status'] == 'active' ? StreamStatus.active : StreamStatus.completed,
        );
      }).toList();
    });
  }

  // Delete a stream from Firestore
  Future<void> _deleteStream(String streamId) async {
    await _firestore.collection('livestreams').doc(streamId).delete();
    _fetchStreams(); // Refresh the list after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: AppColor.primary,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('Stream Management'),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.search),
          //   onPressed: () {},
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //   child: CircleAvatar(
          //     backgroundImage: NetworkImage(
          //       "https://images.unsplash.com/photo-1541516160071-4bb0c5af65ba?fm=jpg&q=60&w=3000&ixlib=b-4.0.3&ixid=M3wxMjA3fDB8MHxZZWFyY",
          //     ),
          //   ),
          // ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Active Streams',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: streams.length,
                itemBuilder: (context, index) {
                  final stream = streams[index];
                  return StreamCard(
                    stream: stream,
                    onEdit: () => _editStream(stream),
                    onEnd: () => _endStream(stream),
                    onDelete: () => _deleteStream(stream.id), // Add delete functionality
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: _createNewStream,
            //   child: const Text('Create New Stream'),
            // ),
          ],
        ),
      ),
    );
  }

  void _editStream(LiveStream stream) {
    showDialog(
      context: context,
      builder: (context) => StreamEditDialog(
        stream: stream,
        onSave: (updatedStream) {
          setState(() {
            final index = streams.indexOf(stream);
            streams[index] = updatedStream;
          });
        },
      ),
    );
  }

  void _endStream(LiveStream stream) {
    setState(() {
      final index = streams.indexOf(stream);
      streams[index] = stream.copyWith(status: StreamStatus.completed);
    });
  }

  void _createNewStream() {
    final newStream = LiveStream(
      id: "NEW${DateTime.now().millisecondsSinceEpoch}",
      title: "New Stream",
      description: "",
      category: "Shoes",
      channelId: "NEWCH",
      isAdmin: true,
      viewsCount: 0,
      timestamp: DateTime.now(),
      currentFilter: null,
      currentMusic: null,
      status: StreamStatus.active,
    );

    showDialog(
      context: context,
      builder: (context) => StreamEditDialog(
        stream: newStream,
        onSave: (createdStream) {
          setState(() {
            streams.add(createdStream);
          });
        },
        isNew: true,
      ),
    );
  }
}

enum StreamStatus { active, completed }

class LiveStream {
  final String id;
  final String title;
  final String description;
  final String category;
  final String channelId;
  final bool isAdmin;
  final int viewsCount;
  final DateTime timestamp;
  final String? currentFilter;
  final String? currentMusic;
  StreamStatus status;

  LiveStream({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.channelId,
    required this.isAdmin,
    required this.viewsCount,
    required this.timestamp,
    required this.currentFilter,
    required this.currentMusic,
    required this.status,
  });

  LiveStream copyWith({
    String? title,
    String? description,
    String? category,
    String? currentFilter,
    String? currentMusic,
    StreamStatus? status,
  }) {
    return LiveStream(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      channelId: channelId,
      isAdmin: isAdmin,
      viewsCount: viewsCount,
      timestamp: timestamp,
      currentFilter: currentFilter ?? this.currentFilter,
      currentMusic: currentMusic ?? this.currentMusic,
      status: status ?? this.status,
    );
  }
}

class StreamCard extends StatelessWidget {
  final LiveStream stream;
  final VoidCallback onEdit;
  final VoidCallback onEnd;
  final VoidCallback onDelete;

  const StreamCard({
    super.key,
    required this.stream,
    required this.onEdit,
    required this.onEnd,
    required this.onDelete,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  stream.title,
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
                    color: stream.status == StreamStatus.active
                        ? Colors.blue[50]
                        : Colors.orange[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                  //  stream.status == StreamStatus.active
                     //   ?
                    'Active',
                     //   : 'Completed',
                    style: TextStyle(
                      color: stream.status == StreamStatus.active
                          ? Colors.blue
                          : Colors.orange,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(stream.description),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.category, size: 16),
                const SizedBox(width: 4),
                Text(stream.category),
                const SizedBox(width: 16),
                const Icon(Icons.people, size: 16),
                const SizedBox(width: 4),
                Text('${stream.viewsCount} views'),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              DateFormat('MMMM d, yyyy \'at\' h:mm a').format(stream.timestamp),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                OutlinedButton(
                  onPressed: onEdit,
                  child: const Text('Edit'),
                ),
                const SizedBox(width: 8),
                if (stream.status == StreamStatus.active)
                  ElevatedButton(
                    onPressed: onEnd,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[50],
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('End Stream'),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


