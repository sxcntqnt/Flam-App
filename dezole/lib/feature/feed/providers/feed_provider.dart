import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedPost {
  final String id;
  final IconData avatar;
  final String name;
  final String handle;
  final String time;
  final String content;
  final int likes;
  final int comments;
  final bool isPromo;

  const FeedPost({
    required this.id,
    required this.avatar,
    required this.name,
    required this.handle,
    required this.time,
    required this.content,
    required this.likes,
    required this.comments,
    this.isPromo = false,
  });
}

class FeedState {
  final List<FeedPost> posts;
  final bool isLoading;
  final String? error;

  const FeedState({this.posts = const [], this.isLoading = false, this.error});

  FeedState copyWith({List<FeedPost>? posts, bool? isLoading, String? error}) {
    return FeedState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class FeedNotifier extends StateNotifier<FeedState> {
  FeedNotifier() : super(const FeedState()) {
    _loadPosts();
  }

  void _loadPosts() {
    state = state.copyWith(
      posts: [
        const FeedPost(
          id: '1',
          avatar: IconData(0xe3ae, fontFamily: 'MaterialIcons'),
          name: 'Matatu Express',
          handle: '@matatuexpress',
          time: '2 hours ago',
          content:
              'New route launched! Now serving Westlands to CBD every 15 minutes.',
          likes: 45,
          comments: 12,
          isPromo: true,
        ),
        const FeedPost(
          id: '2',
          avatar: IconData(0xe531, fontFamily: 'MaterialIcons'),
          name: 'Jane Wanjiku',
          handle: '@janew',
          time: '4 hours ago',
          content:
              'Just had the smoothest ride experience! Highly recommend the matatu app.',
          likes: 24,
          comments: 5,
        ),
        const FeedPost(
          id: '3',
          avatar: IconData(0xe531, fontFamily: 'MaterialIcons'),
          name: 'Matatu Pro',
          handle: '@matatupro',
          time: '6 hours ago',
          content:
              'Reminder: Traffic advisory for Thika Road today. Plan your trips accordingly.',
          likes: 56,
          comments: 12,
        ),
      ],
    );
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 1));
    _loadPosts();
    state = state.copyWith(isLoading: false);
  }
}

final feedProvider = StateNotifierProvider<FeedNotifier, FeedState>((ref) {
  return FeedNotifier();
});
