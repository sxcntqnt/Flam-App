import 'package:flutter_riverpod/flutter_riverpod.dart';

enum BottomNavTab { home, feed, chat, calendar, profile }

class BottomNavState {
  final BottomNavTab currentTab;
  final int stackIndex;

  const BottomNavState({
    this.currentTab = BottomNavTab.home,
    this.stackIndex = 0,
  });

  BottomNavState copyWith({BottomNavTab? currentTab, int? stackIndex}) {
    return BottomNavState(
      currentTab: currentTab ?? this.currentTab,
      stackIndex: stackIndex ?? this.stackIndex,
    );
  }
}

class BottomNavNotifier extends StateNotifier<BottomNavState> {
  BottomNavNotifier() : super(const BottomNavState());

  void setTab(BottomNavTab tab) {
    state = state.copyWith(currentTab: tab, stackIndex: tab.index);
  }

  void reset() => state = const BottomNavState();
}

final bottomNavProvider =
    StateNotifierProvider<BottomNavNotifier, BottomNavState>((ref) {
      return BottomNavNotifier();
    });

final currentTabProvider = Provider<BottomNavTab>((ref) {
  return ref.watch(bottomNavProvider).currentTab;
});

final currentIndexProvider = Provider<int>((ref) {
  return ref.watch(bottomNavProvider).stackIndex;
});
