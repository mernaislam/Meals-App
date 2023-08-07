import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals_app/providers/favorites_provider.dart';
import 'package:meals_app/screen/categories_screen.dart';
import 'package:meals_app/screen/fliters_screen.dart';
import 'package:meals_app/screen/meals_screen.dart';
import 'package:meals_app/widget/drawer.dart';
import 'package:meals_app/providers/filters_provider.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class TabScreen extends ConsumerStatefulWidget {
  const TabScreen({super.key});

  @override
  ConsumerState<TabScreen> createState() {
    return _TabScreenState();
  }
}

class _TabScreenState extends ConsumerState<TabScreen> {
  int currentIndex = 0;

  void _selectedScreen(index) {
    setState(() {
      currentIndex = index;
    });
  }

  void _onSelectedDrawer(String choice) async {
    Navigator.of(context).pop();
    if (choice == 'filters') {
      await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => const FiltersScreen(
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = ref.watch(filteredMealsProvider);
    
    Widget mainContent = CategoriesScreen(
      availableMeals: availableMeals,
    );
    String title = 'Categories';

    if (currentIndex == 1) {
      final favoriteMeals = ref.watch(favorites);
      mainContent = MealsScreen(
        meals: favoriteMeals,
      );
      title = 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: MainDrawer(
        onSelectedDrawer: _onSelectedDrawer,
      ),
      body: mainContent,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: _selectedScreen,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          )
        ],
      ),
    );
  }
}
