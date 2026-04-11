package com.rideapp.dezole.controller;

import com.rideapp.dezole.model.entity.Conversation;
import com.rideapp.dezole.model.entity.Message;
import com.rideapp.dezole.service.ChatService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/chat")
@RequiredArgsConstructor
public class ChatController {

    private final ChatService chatService;

    @GetMapping("/conversations")
    public ResponseEntity<List<Conversation>> getConversations() {
        String userId = getCurrentUserId();
        return ResponseEntity.ok(chatService.getConversations(userId));
    }

    @PostMapping("/conversations/{userId}")
    public ResponseEntity<Conversation> getOrCreateConversation(@PathVariable String userId) {
        String currentUserId = getCurrentUserId();
        return ResponseEntity.ok(chatService.getOrCreateConversation(currentUserId, userId));
    }

    @GetMapping("/messages/{conversationId}")
    public ResponseEntity<List<Message>> getMessages(@PathVariable Long conversationId) {
        return ResponseEntity.ok(chatService.getMessages(conversationId));
    }

    @PostMapping("/messages/{conversationId}")
    public ResponseEntity<Message> sendMessage(@PathVariable Long conversationId, @RequestBody Map<String, String> request) {
        String senderId = getCurrentUserId();
        String content = request.get("content");
        return ResponseEntity.ok(chatService.sendMessage(senderId, conversationId, content));
    }

    @PutMapping("/messages/{conversationId}/read")
    public ResponseEntity<Void> markAsRead(@PathVariable Long conversationId) {
        String userId = getCurrentUserId();
        chatService.markAsRead(conversationId, userId);
        return ResponseEntity.ok().build();
    }

    private String getCurrentUserId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return auth.getName();
    }
}
