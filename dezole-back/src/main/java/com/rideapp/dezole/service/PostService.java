package com.rideapp.dezole.service;

import com.rideapp.dezole.exception.ResourceNotFoundException;
import com.rideapp.dezole.model.dto.response.CommentResponse;
import com.rideapp.dezole.model.dto.response.PostStateResponse;
import com.rideapp.dezole.model.entity.Post;
import com.rideapp.dezole.model.entity.PostComment;
import com.rideapp.dezole.model.entity.User;
import com.rideapp.dezole.repository.PostCommentRepository;
import com.rideapp.dezole.repository.PostRepository;
import com.rideapp.dezole.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PostService {

    private final PostRepository postRepository;
    private final PostCommentRepository postCommentRepository;
    private final UserRepository userRepository;

    public List<PostStateResponse> getAllPosts(String currentUserId) {
        return postRepository.findAllByOrderByCreatedAtDesc()
                .stream()
                .map(post -> mapToPostStateResponse(post, currentUserId))
                .collect(Collectors.toList());
    }

    public PostStateResponse getPostById(Long postId, String currentUserId) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new ResourceNotFoundException("Post not found"));
        return mapToPostStateResponse(post, currentUserId);
    }

    @Transactional
    public PostStateResponse createPost(String authorEmail, String content, String imageUrl) {
        User author = userRepository.findByEmail(authorEmail)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        Post post = Post.builder()
                .author(author)
                .content(content)
                .imageUrl(imageUrl)
                .likesCount(0)
                .commentsCount(0)
                .isSubmitting(true)
                .build();

        post = postRepository.save(post);
        post.clearLoading();

        return mapToPostStateResponse(post, author.getId());
    }

    @Transactional
    public PostStateResponse likePost(Long postId, String currentUserId) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new ResourceNotFoundException("Post not found"));

        if (post.isLikedByUser(currentUserId)) {
            post.removeLike(currentUserId);
        } else {
            post.addLike(currentUserId);
        }

        post = postRepository.save(post);
        return mapToPostStateResponse(post, currentUserId);
    }

    @Transactional
    public PostStateResponse commentOnPost(Long postId, String authorEmail, String content) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new ResourceNotFoundException("Post not found"));

        User author = userRepository.findByEmail(authorEmail)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        PostComment comment = PostComment.builder()
                .post(post)
                .author(author)
                .content(content)
                .build();

        post.addComment(comment);
        post = postRepository.save(post);

        return mapToPostStateResponse(post, authorEmail);
    }

    @Transactional
    public void deletePost(Long postId, String currentUserId) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new ResourceNotFoundException("Post not found"));

        if (!post.getAuthor().getId().equals(currentUserId)) {
            throw new RuntimeException("Not authorized to delete this post");
        }

        postRepository.delete(post);
    }

    public List<CommentResponse> getPostComments(Long postId) {
        return postCommentRepository.findByPostIdOrderByCreatedAtAsc(postId)
                .stream()
                .map(this::mapToCommentResponse)
                .collect(Collectors.toList());
    }

    private PostStateResponse mapToPostStateResponse(Post post, String currentUserId) {
        return PostStateResponse.builder()
                .id(post.getId())
                .content(post.getContent())
                .imageUrl(post.getImageUrl())
                .authorId(post.getAuthor().getId())
                .authorName(post.getAuthor().getFullName())
                .authorImage(post.getAuthor().getProfileImage())
                .likesCount(post.getLikesCount())
                .commentsCount(post.getCommentsCount())
                .isLikedByCurrentUser(post.isLikedByUser(currentUserId))
                .isLoading(post.getIsLoading())
                .isSubmitting(post.getIsSubmitting())
                .errorMessage(post.getErrorMessage())
                .createdAt(post.getCreatedAt())
                .comments(post.getCommentsList().stream()
                        .map(this::mapToCommentResponse)
                        .collect(Collectors.toList()))
                .build();
    }

    private CommentResponse mapToCommentResponse(PostComment comment) {
        return CommentResponse.builder()
                .id(comment.getId())
                .content(comment.getContent())
                .authorId(comment.getAuthor().getId())
                .authorName(comment.getAuthor().getFullName())
                .authorImage(comment.getAuthor().getProfileImage())
                .createdAt(comment.getCreatedAt())
                .build();
    }
}
