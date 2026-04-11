import 'package:flutter_riverpod/flutter_riverpod.dart';

class ComplainState {
  final String? topic;
  final String? description;
  final bool isSubmitting;
  final bool isSubmitted;
  final String? error;

  const ComplainState({
    this.topic,
    this.description,
    this.isSubmitting = false,
    this.isSubmitted = false,
    this.error,
  });

  ComplainState copyWith({
    String? topic,
    String? description,
    bool? isSubmitting,
    bool? isSubmitted,
    String? error,
  }) {
    return ComplainState(
      topic: topic ?? this.topic,
      description: description ?? this.description,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      error: error,
    );
  }
}

class ComplainNotifier extends StateNotifier<ComplainState> {
  ComplainNotifier() : super(const ComplainState());

  void setTopic(String? topic) => state = state.copyWith(topic: topic);

  void setDescription(String? desc) =>
      state = state.copyWith(description: desc);

  Future<bool> submit() async {
    if (state.topic == null || state.topic!.isEmpty) {
      state = state.copyWith(error: 'Please select a topic');
      return false;
    }
    if (state.description == null || state.description!.length < 10) {
      state = state.copyWith(
        error: 'Please describe your complaint (min 10 chars)',
      );
      return false;
    }
    state = state.copyWith(isSubmitting: true, error: null);
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(isSubmitting: false, isSubmitted: true);
    return true;
  }

  void reset() => state = const ComplainState();
}

final complainProvider = StateNotifierProvider<ComplainNotifier, ComplainState>(
  (ref) {
    return ComplainNotifier();
  },
);
