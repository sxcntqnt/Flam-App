import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

enum NotificationType {
  ride,
  wallet,
  chat,
  system,
  alert,
}

class AppNotification {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.isRead = false,
    required this.createdAt,
  });
}

class NotificationState {
  final List<AppNotification> notifications;
  final int unreadCount;
  final bool isLoading;

  const NotificationState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.isLoading = false,
  });

  NotificationState copyWith({
    List<AppNotification>? notifications,
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

class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier() : super(const NotificationState());

  final _notifStateSubject = BehaviorSubject<NotificationState>.seeded(const NotificationState());
  
  Stream<NotificationState> get notificationStateStream => _notifStateSubject.stream;

  Future<void> loadNotifications() async {
    state = state.copyWith(isLoading: true);

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      final mockNotifications = [
        AppNotification(
          id: 'notif-1',
          title: 'Driver Arriving',
          body: 'Your driver is arriving in 2 minutes',
          type: NotificationType.ride,
          createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
        ),
        AppNotification(
          id: 'notif-2',
          title: 'Booking Confirmed',
          body: 'Your seat booking is confirmed',
          type: NotificationType.ride,
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      ];

      state = state.copyWith(
        notifications: mockNotifications,
        unreadCount: mockNotifications.where((n) => !n.isRead).length,
        isLoading: false,
      );
      _notifStateSubject.add(state);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      _notifStateSubject.add(state);
    }
  }

  void markAsRead(String id) {
    final notifications = state.notifications.map((n) {
      if (n.id == id) return AppNotification(
        id: n.id,
        title: n.title,
        body: n.body,
        type: n.type,
        isRead: true,
        createdAt: n.createdAt,
      );
      return n;
    }).toList();

    state = state.copyWith(
      notifications: notifications,
      unreadCount: notifications.where((n) => !n.isRead).length,
    );
    _notifStateSubject.add(state);
  }

  void markAllAsRead() {
    final notifications = state.notifications.map((n) => AppNotification(
      id: n.id,
      title: n.title,
      body: n.body,
      type: n.type,
      isRead: true,
      createdAt: n.createdAt,
    )).toList();

    state = state.copyWith(
      notifications: notifications,
      unreadCount: 0,
    );
    _notifStateSubject.add(state);
  }
}

final notificationProvider = StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  return NotificationNotifier();
});

final unreadNotificationCountProvider = Provider<int>((ref) {
  final notifs = ref.watch(notificationProvider);
  return notifs.unreadCount;
});