import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NotificationItem {
  final String title;
  final String body;
  final DateTime timestamp;
  bool isRead; // Added isRead property

  NotificationItem({
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false, // Default to false for new notifications
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      title: json['title'] ?? 'No Title',
      body: json['body'] ?? 'No Body',
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false, // Parse isRead
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead, // Include isRead in toJson
    };
  }
}

class NotificationHistoryScreen extends StatefulWidget {
  const NotificationHistoryScreen({super.key});

  @override
  State<NotificationHistoryScreen> createState() => _NotificationHistoryScreenState();
}

class _NotificationHistoryScreenState extends State<NotificationHistoryScreen> {
  List<NotificationItem> _notificationHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getNotificationHistory();
    _markAllNotificationsAsRead(); // Mark all as read when entering the screen
  }

  Future<void> _getNotificationHistory() async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    List<String> historyStrings = prefs.getStringList('notificationHistory') ?? [];
    List<NotificationItem> history = historyStrings.map((e) => NotificationItem.fromJson(jsonDecode(e))).toList();

    setState(() {
      _notificationHistory = history.reversed.toList(); // Show newest first
      _isLoading = false;
    });
  }

  Future<void> _markAllNotificationsAsRead() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> historyStrings = prefs.getStringList('notificationHistory') ?? [];
    List<NotificationItem> updatedHistory = historyStrings.map((e) {
      NotificationItem item = NotificationItem.fromJson(jsonDecode(e));
      item.isRead = true; // Mark as read
      return item;
    }).toList();
    List<String> updatedHistoryStrings = updatedHistory.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('notificationHistory', updatedHistoryStrings);
    // No need to call _getNotificationHistory here, as it will be called by initState
  }

  Future<void> _clearAllNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('notificationHistory');
    _getNotificationHistory(); // Refresh the list
  }

  Future<void> _deleteNotification(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> historyStrings = prefs.getStringList('notificationHistory') ?? [];
    // Adjust index for reversed list display
    int originalIndex = historyStrings.length - 1 - index;
    if (originalIndex >= 0 && originalIndex < historyStrings.length) {
      historyStrings.removeAt(originalIndex);
      await prefs.setStringList('notificationHistory', historyStrings);
      _getNotificationHistory(); // Refresh the list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E3A8A),
              Color(0xFF3B82F6),
              Color(0xFFF8FAFC),
            ],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_rounded,
                            color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const Text(
                      'Notification History',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    // Clear All Button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.delete_forever_rounded,
                            color: Colors.white),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Clear All Notifications'),
                                content: const Text('Are you sure you want to clear all notifications? This action cannot be undone.'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Clear'),
                                    onPressed: () {
                                      _clearAllNotifications();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ), 
                  ],
                ),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.white)) // Loading indicator
                    : _notificationHistory.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.notifications_off_rounded,
                                  size: 80,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No notifications yet.',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 18,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16.0),
                            itemCount: _notificationHistory.length,
                            itemBuilder: (context, index) {
                              final notification = _notificationHistory[index];
                              return Dismissible(
                                key: Key(notification.timestamp.toIso8601String()), // Unique key for each dismissible item
                                onDismissed: (direction) {
                                  _deleteNotification(index);
                                },
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: const Icon(Icons.delete, color: Colors.white),
                                ),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12.0),
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: notification.isRead ? Colors.white : Colors.blue.shade50, // Different color for unread
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        notification.isRead ? Icons.mark_email_read_rounded : Icons.mark_email_unread_rounded,
                                        color: notification.isRead ? Colors.grey : Theme.of(context).primaryColor,
                                        size: 28,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              notification.title,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                                                color: const Color(0xFF1E3A8A),
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              notification.body,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: notification.isRead ? Colors.grey[700] : const Color(0xFF1E3A8A),
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              '${notification.timestamp.toLocal().day}/${notification.timestamp.toLocal().month}/${notification.timestamp.toLocal().year} ${notification.timestamp.toLocal().hour}:${notification.timestamp.toLocal().minute.toString().padLeft(2, '0')}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );

                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
