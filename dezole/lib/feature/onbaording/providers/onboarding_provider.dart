import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dezole/common/constant/assets.dart';

class OnboardingPage {
  final String imageAsset;
  final String title;
  final String description;

  const OnboardingPage({
    required this.imageAsset,
    required this.title,
    required this.description,
  });
}

class OnboardingState {
  final int currentPage;
  final int totalPages;
  final bool isAnimating;
  final bool isComplete;

  const OnboardingState({
    this.currentPage = 0,
    this.totalPages = 3,
    this.isAnimating = false,
    this.isComplete = false,
  });

  OnboardingState copyWith({
    int? currentPage,
    int? totalPages,
    bool? isAnimating,
    bool? isComplete,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isAnimating: isAnimating ?? this.isAnimating,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  double get progress => (currentPage + 1) / totalPages;
  bool get isLastPage => currentPage == totalPages - 1;
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final List<OnboardingPage> _pages;
  final Function(int) onPageChanged;

  OnboardingNotifier({
    required List<OnboardingPage> pages,
    required this.onPageChanged,
  }) : _pages = pages,
       super(const OnboardingState(totalPages: 3)) {
    _progressStream();
  }

  void _progressStream() {
    Stream.periodic(const Duration(milliseconds: 100)).take(1).listen((_) {});
  }

  void goToPage(int page) {
    if (page < 0 || page >= state.totalPages) return;
    state = state.copyWith(currentPage: page);
    onPageChanged(page);
  }

  void nextPage() {
    if (state.isLastPage) {
      state = state.copyWith(isComplete: true);
      return;
    }
    goToPage(state.currentPage + 1);
  }

  void previousPage() {
    if (state.currentPage > 0) goToPage(state.currentPage - 1);
  }

  OnboardingPage get currentPageData {
    return _pages[state.currentPage.clamp(0, _pages.length - 1)];
  }

  static final List<OnboardingPage> defaultPages = [
    const OnboardingPage(
      imageAsset: Assets.anywhereYouAreImage,
      title: 'Anywhere you are',
      description:
          'Sell houses easily with the help of Listenoryx and to make this line big I am writing more.',
    ),
    const OnboardingPage(
      imageAsset: Assets.atAnytimeImage,
      title: 'At anytime',
      description:
          'Sell houses easily with the help of Listenoryx and to make this line big I am writing more.',
    ),
    const OnboardingPage(
      imageAsset: Assets.frame1Image,
      title: 'Book your car',
      description:
          'Sell houses easily with the help of Listenoryx and to make this line big I am writing more.',
    ),
  ];
}

final onboardingNotifierProvider =
    StateNotifierProvider.autoDispose<OnboardingNotifier, OnboardingState>((
      ref,
    ) {
      return OnboardingNotifier(
        pages: OnboardingNotifier.defaultPages,
        onPageChanged: (page) {},
      );
    });

final onboardingPagesProvider = Provider<List<OnboardingPage>>((ref) {
  return OnboardingNotifier.defaultPages;
});
