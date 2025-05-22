import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hvatai_admin_panel/components/Appcolors.dart';
import 'package:intl/intl.dart';

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
  Future<void> _fetchStreams() async {
    final snapshot = await _firestore.collection('livestreams').get();
    print("✅ Total Streams Fetched: ${snapshot.docs.length}");

    setState(() {
      streams = snapshot.docs.map((doc) {
        final data = doc.data();
        return LiveStream(
          id: doc.id,
          title: data['title'] ?? 'Untitled',
          description: data['description'] ?? '',
          category: data['category'] ?? '',
          channelId: data['channelId'] ?? '',
          isAdmin: data['isAdmin'] ?? false,
          viewsCount: data['viewsCount'] ?? 0,
          timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
          currentFilter: data['currentFilter'],
          currentMusic: data['currentMusic'],
          status: data['status']?.toString().toLowerCase() == 'active'
              ? StreamStatus.active
              : StreamStatus.completed,
          isBlocked: data['isBlocked'] ?? false,
          blockedReason: data['blockedReason'],
        );
      }).toList();
    });
  }

  Future<void> _deleteStream(String streamId) async {
    await _firestore.collection('livestreams').doc(streamId).delete();
    _fetchStreams();
  }

  Future<void> _toggleBlockStream(LiveStream stream) async {
    final isCurrentlyBlocked = stream.isBlocked;
    String reason = '';

    if (!isCurrentlyBlocked) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Block Stream"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Are you sure you want to block this stream?"),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(labelText: "Reason for blocking"),
                onChanged: (value) => reason = value,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await _firestore.collection('livestreams').doc(stream.id).update({
                  'isBlocked': true,
                  'blockedReason': reason,
                });
                _fetchStreams();
              },
              child: const Text("Block"),
            )
          ],
        ),
      );
    } else {
      await _firestore.collection('livestreams').doc(stream.id).update({
        'isBlocked': false,
        'blockedReason': null,
      });
      _fetchStreams();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('Stream Management'),
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
                    onEdit: () {},
                    onEnd: () => _toggleBlockStream(stream),
                    onDelete: () => _deleteStream(stream.id),
                  );
                },
              ),
            ),
          ],
        ),
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
  final StreamStatus status;
  final bool isBlocked;
  final String? blockedReason;

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
    required this.isBlocked,
    this.blockedReason,
  });

  LiveStream copyWith({
    String? title,
    String? description,
    String? category,
    String? currentFilter,
    String? currentMusic,
    StreamStatus? status,
    bool? isBlocked,
    String? blockedReason,
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
      isBlocked: isBlocked ?? this.isBlocked,
      blockedReason: blockedReason ?? this.blockedReason,
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
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: stream.isBlocked ? Colors.red[50] : Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    stream.isBlocked ? 'Blocked' : 'Unblocked',
                    style: TextStyle(
                      color: stream.isBlocked ? Colors.red : Colors.blueAccent,
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
              DateFormat("MMMM d, yyyy 'at' h:mm a").format(stream.timestamp),
            ),
            const SizedBox(height: 16),
            if (stream.blockedReason != null && stream.isBlocked)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('Reason: ${stream.blockedReason}', style: TextStyle(color: Colors.redAccent)),
              ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: onEnd,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: stream.isBlocked ? Colors.green[50] : Colors.red[50],
                    foregroundColor: stream.isBlocked ? Colors.green : Colors.red,
                  ),
                  child: Text(stream.isBlocked ? 'Unblock' : 'Block'),
                ),
                const SizedBox(width: 8),
                // IconButton(
                //   icon: const Icon(Icons.delete, color: Colors.red),
                //   onPressed: onDelete,
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
