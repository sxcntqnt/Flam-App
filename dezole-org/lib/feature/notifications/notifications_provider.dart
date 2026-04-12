import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

// Notification state model
class NotificationState {
  final List<Map<String, dynamic>> notifications;
  final int unreadCount;
  final bool isLoading;

  NotificationState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.isLoading = false,
  });

  NotificationState copyWith({
    List<Map<String, dynamic>>? notifications,
    int? unreadCount,
    bool? isLoading,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Notification provider using Riverpod
final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, NotificationState>((ref) {
      return NotificationsNotifier();
    });

class NotificationsNotifier extends StateNotifier<NotificationState> {
  NotificationsNotifier() : super(NotificationState());

  // Streams for reactive updates using RxDart
  final _notificationsController =
      BehaviorSubject<List<Map<String, dynamic>>>.seeded([]);
  final _unreadCountController = BehaviorSubject<int>.seeded(0);
  final _loadingController = BehaviorSubject<bool>.seeded(false);

  Stream<List<Map<String, dynamic>>> get notificationsStream =>
      _notificationsController.stream;
  Stream<int> get unreadCountStream => _unreadCountController.stream;
  Stream<bool> get isLoadingStream => _loadingController.stream;

  // Add notification
  void addNotification(Map<String, dynamic> notification) {
    final newNotifications = [notification, ...state.notifications];
    final newUnreadCount =
        state.unreadCount + (notification['read'] == false ? 1 : 0);
    state = state.copyWith(
      notifications: newNotifications,
      unreadCount: newUnreadCount,
    );
    _notificationsController.add(newNotifications);
    _unreadCountController.add(newUnreadCount);
  }

  // Mark notification as read
  void markAsRead(String notificationId) {
    final updatedNotifications = state.notifications.map((notification) {
      if (notification['id'] == notificationId) {
        return {...notification, 'read': true};
      }
      return notification;
    }).toList();

    final unreadCount = updatedNotifications
        .where((n) => n['read'] == false)
        .length;
    state = state.copyWith(
      notifications: updatedNotifications,
      unreadCount: unreadCount,
    );
    _notificationsController.add(updatedNotifications);
    _unreadCountController.add(unreadCount);
  }

  // Mark all as read
  void markAllAsRead() {
    final updatedNotifications = state.notifications
        .map((notification) => {...notification, 'read': true})
        .toList();

    state = state.copyWith(notifications: updatedNotifications, unreadCount: 0);
    _notificationsController.add(updatedNotifications);
    _unreadCountController.add(0);
  }

  // Set loading state
  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
    _loadingController.add(isLoading);
  }

  // Clear notifications
  void clearNotifications() {
    state = state.copyWith(notifications: [], unreadCount: 0);
    _notificationsController.add([]);
    _unreadCountController.add(0);
  }

  // Dispose controllers
  @override
  void dispose() {
    _notificationsController.close();
    _unreadCountController.close();
    _loadingController.close();
    super.dispose();
  }
}
