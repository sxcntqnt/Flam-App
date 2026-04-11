package com.rideapp.dezole.service;

import com.rideapp.dezole.exception.ResourceNotFoundException;
import com.rideapp.dezole.model.entity.Conversation;
import com.rideapp.dezole.model.entity.Message;
import com.rideapp.dezole.model.entity.User;
import com.rideapp.dezole.repository.ConversationRepository;
import com.rideapp.dezole.repository.MessageRepository;
import com.rideapp.dezole.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ChatService {

    private final ConversationRepository conversationRepository;
    private final MessageRepository messageRepository;
    private final UserRepository userRepository;

    public List<Conversation> getConversations(String userId) {
        return conversationRepository.findByUserId(userId);
    }

    @Transactional
    public Conversation getOrCreateConversation(String userId1, String userId2) {
        return conversationRepository.findByUsers(userId1, userId2)
                .orElseGet(() -> {
                    User user1 = userRepository.findById(userId1)
                            .orElseThrow(() -> new ResourceNotFoundException("User not found: " + userId1));
                    User user2 = userRepository.findById(userId2)
                            .orElseThrow(() -> new ResourceNotFoundException("User not found: " + userId2));
                    
                    Conversation conversation = Conversation.builder()
                            .user1(user1)
                            .user2(user2)
                            .build();
                    return conversationRepository.save(conversation);
                });
    }

    public List<Message> getMessages(Long conversationId) {
        Conversation conversation = conversationRepository.findById(conversationId)
                .orElseThrow(() -> new ResourceNotFoundException("Conversation not found"));
        return messageRepository.findByConversationIdOrderByCreatedAtAsc(conversationId);
    }

    @Transactional
    public Message sendMessage(String senderId, Long conversationId, String content) {
        Conversation conversation = conversationRepository.findById(conversationId)
                .orElseThrow(() -> new ResourceNotFoundException("Conversation not found"));
        User sender = userRepository.findById(senderId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found: " + senderId));

        Message message = Message.builder()
                .conversation(conversation)
                .sender(sender)
                .content(content)
                .isRead(false)
                .build();

        conversation.setLastMessageAt(LocalDateTime.now());
        conversationRepository.save(conversation);

        return messageRepository.save(message);
    }

    @Transactional
    public void markAsRead(Long conversationId, String userId) {
        conversationRepository.findById(conversationId)
                .orElseThrow(() -> new ResourceNotFoundException("Conversation not found"));
        messageRepository.markAsRead(conversationId, userId);
    }
}
