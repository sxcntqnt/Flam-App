package com.rideapp.dezole.controller;

import com.rideapp.dezole.model.dto.response.CommentResponse;
import com.rideapp.dezole.model.dto.response.PostStateResponse;
import com.rideapp.dezole.service.PostService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/posts")
@RequiredArgsConstructor
public class PostController {

    private final PostService postService;

    @GetMapping
    public ResponseEntity<List<PostStateResponse>> getAllPosts() {
        String email = getCurrentUserEmail();
        return ResponseEntity.ok(postService.getAllPosts(email));
    }

    @GetMapping("/{id}")
    public ResponseEntity<PostStateResponse> getPostById(@PathVariable Long id) {
        String email = getCurrentUserEmail();
        return ResponseEntity.ok(postService.getPostById(id, email));
    }

    @GetMapping("/{id}/comments")
    public ResponseEntity<List<CommentResponse>> getPostComments(@PathVariable Long id) {
        return ResponseEntity.ok(postService.getPostComments(id));
    }

    @PostMapping
    public ResponseEntity<PostStateResponse> createPost(@RequestBody Map<String, String> request) {
        String email = getCurrentUserEmail();
        String content = request.get("content");
        String imageUrl = request.get("imageUrl");
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(postService.createPost(email, content, imageUrl));
    }

    @PostMapping("/{id}/like")
    public ResponseEntity<PostStateResponse> likePost(@PathVariable Long id) {
        String email = getCurrentUserEmail();
        return ResponseEntity.ok(postService.likePost(id, email));
    }

    @PostMapping("/{id}/comment")
    public ResponseEntity<PostStateResponse> commentOnPost(
            @PathVariable Long id,
            @RequestBody Map<String, String> request) {
        String email = getCurrentUserEmail();
        String content = request.get("content");
        return ResponseEntity.ok(postService.commentOnPost(id, email, content));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletePost(@PathVariable Long id) {
        String email = getCurrentUserEmail();
        postService.deletePost(id, email);
        return ResponseEntity.noContent().build();
    }

    private String getCurrentUserEmail() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return auth.getName();
    }
}
