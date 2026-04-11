import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfigState {
  final bool showOnboarding;
  final bool isInitialized;

  const AppConfigState({
    this.showOnboarding = true,
    this.isInitialized = false,
  });

  AppConfigState copyWith({bool? showOnboarding, bool? isInitialized}) {
    return AppConfigState(
      showOnboarding: showOnboarding ?? this.showOnboarding,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

class AppConfigNotifier extends StateNotifier<AppConfigState> {
  final SharedPreferences? _prefs;

  AppConfigNotifier(this._prefs) : super(const AppConfigState()) {
    _loadConfig();
  }

  void _loadConfig() {
    final showOnboarding = _prefs?.getBool('showOnboarding') ?? true;
    state = state.copyWith(showOnboarding: showOnboarding, isInitialized: true);
  }

  Future<void> completeOnboarding() async {
    await _prefs?.setBool('showOnboarding', false);
    state = state.copyWith(showOnboarding: false);
  }

  Future<void> resetOnboarding() async {
    await _prefs?.setBool('showOnboarding', true);
    state = state.copyWith(showOnboarding: true);
  }
}

final sharedPreferencesProvider = Provider<SharedPreferences?>((ref) => null);

final appConfigProvider =
    StateNotifierProvider<AppConfigNotifier, AppConfigState>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider);
      return AppConfigNotifier(prefs);
    });
