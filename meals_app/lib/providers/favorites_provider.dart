import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/model/meal.dart';

class FavoritesMealsNotifier extends StateNotifier<List<Meal>> {
  FavoritesMealsNotifier() : super([]);

  bool toggleFavoriteMealsStatus(Meal meal){
    final isMealFavorite = state.contains(meal);

    if(isMealFavorite){
      state = state.where((m) => m.id != meal.id).toList();
      return false;
    } else {
      state = [...state, meal];
      return true;
    }
  }
}

final favorites = StateNotifierProvider<FavoritesMealsNotifier, List<Meal>>(
  (ref) {
    return FavoritesMealsNotifier();
  },
);
