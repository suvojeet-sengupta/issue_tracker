import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotificationHistoryScreen extends StatefulWidget {
  const NotificationHistoryScreen({super.key});

  @override
  State<NotificationHistoryScreen> createState() => _NotificationHistoryScreenState();
}

class _NotificationHistoryScreenState extends State<NotificationHistoryScreen> {
  static const platform = MethodChannel('com.suvojeet.issue_tracker_app/notifications');
  List<String> _notificationHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getNotificationHistory();
    _markAllNotificationsAsRead();
  }

  Future<void> _markAllNotificationsAsRead() async {
    try {
      await platform.invokeMethod('markAllNotificationsAsRead');
    } on PlatformException catch (e) {
      print("Failed to mark notifications as read: '${e.message}'.");
    }
  }

  Future<void> _getNotificationHistory() async {
    setState(() {
      _isLoading = true;
    });
    List<String> history = [];
    try {
      final List<dynamic>? result = await platform.invokeMethod('getNotificationHistory');
      if (result != null) {
        history = result.cast<String>();
      }
    } on PlatformException catch (e) {
      print("Failed to get notification history: '${e.message}'.");
    }

    setState(() {
      _notificationHistory = history.reversed.toList(); // Show newest first
      _isLoading = false;
    });
  }

  Future<void> _clearAllNotifications() async {
    try {
      await platform.invokeMethod('clearAllNotifications');
      _getNotificationHistory(); // Refresh the list
    } on PlatformException catch (e) {
      print("Failed to clear all notifications: '${e.message}'.");
    }
  }

  Future<void> _deleteNotification(int index) async {
    try {
      // Assuming the platform method can delete by index or a unique ID
      // For now, we'll pass the notification string itself as a unique identifier
      // You might need to adjust this if your native side uses a different identifier
      await platform.invokeMethod('deleteNotification', {'notification': _notificationHistory[index]});
      _getNotificationHistory(); // Refresh the list
    } on PlatformException catch (e) {
      print("Failed to delete notification: '${e.message}'.");
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
                          _clearAllNotifications();
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
                                key: Key(notification), // Unique key for each dismissible item
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
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    notification,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF1E3A8A),
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              );
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  notification,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF1E3A8A),
                                    fontFamily: 'Poppins',
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