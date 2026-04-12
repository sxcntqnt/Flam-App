import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

class ChatMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime createdAt;
  final bool isRead;
  final bool isSentByMe;

  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.receiverId,
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
  final String participantImage;
  final String lastMessage;
  final DateTime lastMessageAt;
  final int unreadCount;

  const Conversation({
    required this.id,
    required this.participantId,
    required this.participantName,
    this.participantImage = '',
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

  Future<void> loadConversations() async {
    state = state.copyWith(isLoading: true);
    _chatStateSubject.add(state.copyWith(isLoading: true));

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      final mockConversations = [
        Conversation(
          id: 'conv-1',
          participantId: 'user-1',
          participantName: 'John Doe',
          lastMessage: 'Where are you?',
          lastMessageAt: DateTime.now().subtract(const Duration(minutes: 5)),
          unreadCount: 2,
        ),
        Conversation(
          id: 'conv-2',
          participantId: 'user-2',
          participantName: 'Jane Smith',
          lastMessage: 'Thanks for the ride!',
          lastMessageAt: DateTime.now().subtract(const Duration(hours: 1)),
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
          senderId: 'user-other',
          receiverId: 'driver-1',
          content: 'Hi! I need a ride to Westlands',
          createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
          isRead: true,
          isSentByMe: false,
        ),
        ChatMessage(
          id: 'msg-2',
          conversationId: conversationId,
          senderId: 'driver-1',
          receiverId: 'user-other',
          content: 'Sure! I can pick you up in 5 minutes',
          createdAt: DateTime.now().subtract(const Duration(minutes: 8)),
          isRead: true,
          isSentByMe: true,
        ),
        ChatMessage(
          id: 'msg-3',
          conversationId: conversationId,
          senderId: 'user-other',
          receiverId: 'driver-1',
          content: 'Great! Wait at the entrance',
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
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
        senderId: 'driver-1',
        receiverId: 'user-other',
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

final conversationsProvider = Provider<List<Conversation>>((ref) {
  final chat = ref.watch(chatProvider);
  return chat.conversations;
});

final messagesProvider = Provider<List<ChatMessage>>((ref) {
  final chat = ref.watch(chatProvider);
  return chat.messages;
});

final chatStreamProvider = StreamProvider<ChatState>((ref) {
  final notifier = ref.read(chatProvider.notifier);
  return notifier.chatStateStream;
});