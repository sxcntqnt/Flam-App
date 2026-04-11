import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatMessage {
  final String id;
  final String senderName;
  final String message;
  final String time;
  final bool isOnline;
  final int unread;

  const ChatMessage({
    required this.id,
    required this.senderName,
    required this.message,
    required this.time,
    required this.isOnline,
    required this.unread,
  });
}

class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? searchQuery;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.searchQuery,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? searchQuery,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery,
    );
  }

  List<ChatMessage> get filteredMessages {
    if (searchQuery == null || searchQuery!.isEmpty) return messages;
    return messages
        .where(
          (m) =>
              m.senderName.toLowerCase().contains(searchQuery!.toLowerCase()) ||
              m.message.toLowerCase().contains(searchQuery!.toLowerCase()),
        )
        .toList();
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(const ChatState()) {
    _loadMessages();
  }

  void _loadMessages() {
    state = state.copyWith(
      messages: [
        const ChatMessage(
          id: '1',
          senderName: 'John Kamau',
          message: 'Your ride is arriving in 5 mins',
          time: '2:30 PM',
          isOnline: true,
          unread: 2,
        ),
        const ChatMessage(
          id: '2',
          senderName: 'Sarah Nyambura',
          message: 'Thank you for the ride!',
          time: 'Yesterday',
          isOnline: false,
          unread: 0,
        ),
        const ChatMessage(
          id: '3',
          senderName: 'Matatu Express',
          message: 'Route update: Thika Road',
          time: 'Yesterday',
          isOnline: true,
          unread: 5,
        ),
        const ChatMessage(
          id: '4',
          senderName: 'Support Team',
          message: 'How can we help you?',
          time: 'Mon',
          isOnline: false,
          unread: 0,
        ),
      ],
    );
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void markAsRead(String messageId) {
    final updatedMessages = state.messages.map((m) {
      if (m.id == messageId) {
        return ChatMessage(
          id: m.id,
          senderName: m.senderName,
          message: m.message,
          time: m.time,
          isOnline: m.isOnline,
          unread: 0,
        );
      }
      return m;
    }).toList();
    state = state.copyWith(messages: updatedMessages);
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier();
});
