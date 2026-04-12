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
  final Map<String, dynamic>? data;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.isRead = false,
    required this.createdAt,
    this.data,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    bool? isRead,
    DateTime? createdAt,
    Map<String, dynamic>? data,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      data: data ?? this.data,
    );
  }
}

class NotificationState {
  final List<AppNotification> notifications;
  final int unreadCount;
  final bool isLoading;
  final String? error;

  const NotificationState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.isLoading = false,
    this.error,
  });

  NotificationState copyWith({
    List<AppNotification>? notifications,
    int? unreadCount,
    bool? isLoading,
    String? error,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier() : super(const NotificationState());

  final _notificationStateSubject = BehaviorSubject<NotificationState>.seeded(const NotificationState());
  
  Stream<NotificationState> get notificationStateStream => _notificationStateSubject.stream;

  Future<void> loadNotifications() async {
    state = state.copyWith(isLoading: true);
    _notificationStateSubject.add(state.copyWith(isLoading: true));

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      final mockNotifications = [
        AppNotification(
          id: 'notif-1',
          title: 'New Ride Request',
          body: 'You have a new ride request from CBD to Westlands',
          type: NotificationType.ride,
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
        AppNotification(
          id: 'notif-2',
          title: 'Payment Received',
          body: 'You received KSh 450 for trip #1234',
          type: NotificationType.wallet,
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        AppNotification(
          id: 'notif-3',
          title: 'System Update',
          body: 'App updated to version 2.0.1',
          type: NotificationType.system,
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        ),
      ];

      state = state.copyWith(
        notifications: mockNotifications,
        unreadCount: mockNotifications.where((n) => !n.isRead).length,
        isLoading: false,
      );
      _notificationStateSubject.add(state);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      _notificationStateSubject.add(state);
    }
  }

  void markAsRead(String notificationId) {
    final notifications = state.notifications.map((n) {
      if (n.id == notificationId) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();

    state = state.copyWith(
      notifications: notifications,
      unreadCount: notifications.where((n) => !n.isRead).length,
    );
    _notificationStateSubject.add(state);
  }

  void markAllAsRead() {
    final notifications = state.notifications.map((n) {
      return n.copyWith(isRead: true);
    }).toList();

    state = state.copyWith(
      notifications: notifications,
      unreadCount: 0,
    );
    _notificationStateSubject.add(state);
  }

  void addNotification(AppNotification notification) {
    state = state.copyWith(
      notifications: [notification, ...state.notifications],
      unreadCount: state.unreadCount + 1,
    );
    _notificationStateSubject.add(state);
  }

  void clearAll() {
    state = state.copyWith(
      notifications: [],
      unreadCount: 0,
    );
    _notificationStateSubject.add(state);
  }
}

final notificationProvider = StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  return NotificationNotifier();
});

final unreadCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationProvider);
  return notifications.unreadCount;
});

final notificationStreamProvider = StreamProvider<NotificationState>((ref) {
  final notifier = ref.read(notificationProvider.notifier);
  return notifier.notificationStateStream;
});