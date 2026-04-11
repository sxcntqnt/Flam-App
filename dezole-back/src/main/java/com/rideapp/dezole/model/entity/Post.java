package com.rideapp.dezole.model.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Entity
@Table(name = "posts")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Post {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "author_id", nullable = false)
    private User author;

    @Column(nullable = false, length = 2000)
    private String content;

    private String imageUrl;

    @Builder.Default
    private Integer likesCount = 0;

    @Builder.Default
    private Integer commentsCount = 0;

    @ElementCollection
    @CollectionTable(name = "post_likes", joinColumns = @JoinColumn(name = "post_id"))
    @Column(name = "user_id")
    @Builder.Default
    private Set<String> likedByUserIds = new HashSet<>();

    @OneToMany(mappedBy = "post", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<PostComment> commentsList = new ArrayList<>();

    @Builder.Default
    private Boolean isLoading = false;

    @Builder.Default
    private Boolean isSubmitting = false;

    private String errorMessage;

    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }

    public void addLike(String userId) {
        if (!likedByUserIds.contains(userId)) {
            likedByUserIds.add(userId);
            likesCount = likedByUserIds.size();
        }
    }

    public void removeLike(String userId) {
        if (likedByUserIds.remove(userId)) {
            likesCount = likedByUserIds.size();
        }
    }

    public boolean isLikedByUser(String userId) {
        return likedByUserIds.contains(userId);
    }

    public void addComment(PostComment comment) {
        commentsList.add(comment);
        commentsCount = commentsList.size();
    }

    public void markAsLoading() {
        this.isLoading = true;
        this.errorMessage = null;
    }

    public void markAsSubmitting() {
        this.isSubmitting = true;
        this.errorMessage = null;
    }

    public void clearLoading() {
        this.isLoading = false;
        this.isSubmitting = false;
    }
}
