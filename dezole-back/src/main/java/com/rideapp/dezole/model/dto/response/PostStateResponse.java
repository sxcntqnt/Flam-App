package com.rideapp.dezole.model.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PostStateResponse {
    private Long id;
    private String content;
    private String imageUrl;
    private String authorId;
    private String authorName;
    private String authorImage;
    private Integer likesCount;
    private Integer commentsCount;
    private Boolean isLikedByCurrentUser;
    private Boolean isLoading;
    private Boolean isSubmitting;
    private String errorMessage;
    private LocalDateTime createdAt;
    private List<CommentResponse> comments;
}
