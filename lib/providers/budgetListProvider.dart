import 'package:flutter_riverpod/flutter_riverpod.dart';

final itemListProvider = StateNotifierProvider<ItemListNotifier, List<String>>((ref) {
  return ItemListNotifier();
});

class ItemListNotifier extends StateNotifier<List<String>> {
  ItemListNotifier() : super([]);

  void addItem(String item) {
    state = [...state, item];
  }

  void removeItem(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i != index) state[i],
    ];
  }
}
// Compare this snippet from lib/providers/budgetListProvider.dart: