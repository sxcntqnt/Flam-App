import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

class ChatMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime createdAt;
  final bool isRead;
  final bool isSentByMe;

  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.createdAt,
    this.isRead = false,
    required this.isSentByMe,
  });
}

class Conversation {
  final String id;
  final String participantId;
  final String participantName;
  final String participantRole;
  final String lastMessage;
  final DateTime lastMessageAt;
  final int unreadCount;

  const Conversation({
    required this.id,
    required this.participantId,
    required this.participantName,
    required this.participantRole,
    required this.lastMessage,
    required this.lastMessageAt,
    this.unreadCount = 0,
  });
}

class ChatState {
  final List<Conversation> conversations;
  final List<ChatMessage> messages;
  final String? activeConversationId;
  final bool isLoading;
  final bool isSending;
  final String? error;

  const ChatState({
    this.conversations = const [],
    this.messages = const [],
    this.activeConversationId,
    this.isLoading = false,
    this.isSending = false,
    this.error,
  });

  ChatState copyWith({
    List<Conversation>? conversations,
    List<ChatMessage>? messages,
    String? activeConversationId,
    bool? isLoading,
    bool? isSending,
    String? error,
  }) {
    return ChatState(
      conversations: conversations ?? this.conversations,
      messages: messages ?? this.messages,
      activeConversationId: activeConversationId ?? this.activeConversationId,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      error: error ?? this.error,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(const ChatState());

  final _chatStateSubject = BehaviorSubject<ChatState>.seeded(const ChatState());
  
  Stream<ChatState> get chatStateStream => _chatStateSubject.stream;

  Future<void> loadConversations(String orgId) async {
    state = state.copyWith(isLoading: true);
    _chatStateSubject.add(state.copyWith(isLoading: true));

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      final mockConversations = [
        const Conversation(
          id: 'conv-1',
          participantId: 'driver-1',
          participantName: 'John Driver',
          participantRole: 'Driver',
          lastMessage: 'Driver report submitted',
          lastMessageAt: DateTime.now().subtract(const Duration(minutes: 10)),
        ),
        const Conversation(
          id: 'conv-2',
          participantId: 'driver-2',
          participantName: 'Mary Driver',
          participantRole: 'Driver',
          lastMessage: ' vehicle issue resolved',
          lastMessageAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        const Conversation(
          id: 'conv-3',
          participantId: 'member-1',
          participantName: 'James Member',
          participantRole: 'Member',
          lastMessage: 'Booking confirmed',
          lastMessageAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];

      state = state.copyWith(
        conversations: mockConversations,
        isLoading: false,
      );
      _chatStateSubject.add(state);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      _chatStateSubject.add(state);
    }
  }

  Future<void> loadMessages(String conversationId) async {
    state = state.copyWith(
      isLoading: true,
      activeConversationId: conversationId,
    );
    _chatStateSubject.add(state.copyWith(isLoading: true));

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      final mockMessages = [
        ChatMessage(
          id: 'msg-1',
          conversationId: conversationId,
          senderId: 'driver-1',
          senderName: 'John Driver',
          content: 'Hello, I have an issue with my vehicle',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          isRead: true,
          isSentByMe: false,
        ),
        ChatMessage(
          id: 'msg-2',
          conversationId: conversationId,
          senderId: 'admin-1',
          senderName: 'Admin',
          content: 'Sure, what seems to be the problem?',
          createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
          isRead: true,
          isSentByMe: true,
        ),
        ChatMessage(
          id: 'msg-3',
          conversationId: conversationId,
          senderId: 'driver-1',
          senderName: 'John Driver',
          content: 'The engine is making a strange noise',
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
          isRead: false,
          isSentByMe: false,
        ),
      ];

      state = state.copyWith(
        messages: mockMessages,
        isLoading: false,
      );
      _chatStateSubject.add(state);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      _chatStateSubject.add(state);
    }
  }

  Future<void> sendMessage(String content) async {
    if (state.activeConversationId == null) return;
    
    state = state.copyWith(isSending: true);
    _chatStateSubject.add(state.copyWith(isSending: true));

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      final newMessage = ChatMessage(
        id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
        conversationId: state.activeConversationId!,
        senderId: 'admin-1',
        senderName: 'Admin',
        content: content,
        createdAt: DateTime.now(),
        isRead: true,
        isSentByMe: true,
      );

      state = state.copyWith(
        messages: [...state.messages, newMessage],
        isSending: false,
      );
      _chatStateSubject.add(state);
    } catch (e) {
      state = state.copyWith(
        isSending: false,
        error: e.toString(),
      );
      _chatStateSubject.add(state);
    }
  }

  void clearActiveConversation() {
    state = state.copyWith(
      activeConversationId: null,
      messages: [],
    );
    _chatStateSubject.add(state);
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier();
});

final conversationsListProvider = Provider<List<Conversation>>((ref) {
  final chat = ref.watch(chatProvider);
  return chat.conversations;
});

final activeChatMessagesProvider = Provider<List<ChatMessage>>((ref) {
  final chat = ref.watch(chatProvider);
  return chat.messages;
});

final chatStreamProvider = StreamProvider<ChatState>((ref) {
  final notifier = ref.read(chatProvider.notifier);
  return notifier.chatStateStream;
});