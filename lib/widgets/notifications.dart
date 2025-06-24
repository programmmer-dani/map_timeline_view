import 'package:flutter/material.dart';

class NotificationCenterWidget extends StatelessWidget {
  final List<NotificationMessage> messages = const [
    NotificationMessage(
      sender: 'System',
      subject: 'Project deadline extended',
      body: 'The deadline for Project Atlas has been extended by 2 weeks.',
      isRead: false,
    ),
    NotificationMessage(
      sender: 'Admin',
      subject: 'New policy update',
      body:
          'Please review the new remote work policy in the documents section.',
      isRead: true,
    ),
    NotificationMessage(
      sender: 'HR',
      subject: 'Team event on Friday',
      body: 'You are invited to the team-building event this Friday at 4 PM.',
      isRead: false,
    ),
  ];

  const NotificationCenterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: messages.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final message = messages[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            title: Text(
              message.subject,
              style: TextStyle(
                fontSize: 14,
                fontWeight:
                    message.isRead ? FontWeight.normal : FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'From: ${message.sender}',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: const Icon(Icons.chevron_right, size: 18),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => NotificationDetailScreen(message: message),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class NotificationDetailScreen extends StatelessWidget {
  final NotificationMessage message;

  const NotificationDetailScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Notification Detail')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'From: ${message.sender}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              message.subject,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(message.body, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 20),
            const Text(
              'Reply:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Write your reply...',
                isDense: true,
                contentPadding: const EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reply sent (pretend)!')),
                  );
                },
                child: const Text('Send'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationMessage {
  final String sender;
  final String subject;
  final String body;
  final bool isRead;

  const NotificationMessage({
    required this.sender,
    required this.subject,
    required this.body,
    required this.isRead,
  });
}
