import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridesharing/common/theme.dart';
import 'package:ridesharing/feature/notifications/notifications_provider.dart';

class NotificationsWidget extends ConsumerWidget {
  const NotificationsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsState = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: CustomTheme.lightColor,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: CustomTheme.appColor,
        elevation: 0,
        actions: [
          if (notificationsState.unreadCount > 0)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: () {
                ref.read(notificationsProvider.notifier).markAllAsRead();
              },
            ),
        ],
      ),
      body: notificationsState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : notificationsState.notifications.isEmpty
          ? const Center(child: Text('No notifications'))
          : ListView.builder(
              itemCount: notificationsState.notifications.length,
              itemBuilder: (context, index) {
                final notification = notificationsState.notifications[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: notification['read'] == true
                          ? Colors.grey
                          : CustomTheme.appColor,
                      child: Icon(
                        notification['icon'] ?? Icons.notifications,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      notification['title'] ?? 'Notification',
                      style: TextStyle(
                        fontWeight: notification['read'] == true
                            ? FontWeight.normal
                            : FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(notification['message'] ?? ''),
                        const SizedBox(height: 4),
                        Text(
                          notification['time'] ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    trailing: notification['read'] == true
                        ? null
                        : const Icon(
                            Icons.circle,
                            size: 10,
                            color: CustomTheme.appColor,
                          ),
                    onTap: () {
                      ref
                          .read(notificationsProvider.notifier)
                          .markAsRead(notification['id'] ?? '');
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add sample notification for demo
          ref.read(notificationsProvider.notifier).addNotification({
            'id': DateTime.now().millisecondsSinceEpoch.toString(),
            'title': 'New Ride Available',
            'message': 'A new ride matching your preferences is available',
            'time': 'Just now',
            'read': false,
            'icon': Icons.directions_car,
          });
        },
        backgroundColor: CustomTheme.appColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
