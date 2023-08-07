import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals_app/providers/dummy_provider.dart';
import 'package:meals_app/providers/favorites_provider.dart';
import 'package:meals_app/screen/categories_screen.dart';
import 'package:meals_app/screen/fliters_screen.dart';
import 'package:meals_app/screen/meals_screen.dart';
import 'package:meals_app/widget/drawer.dart';

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
  Map<Filter, bool> _selectedFilters = kInitialFilters;

  void _selectedScreen(index) {
    setState(() {
      currentIndex = index;
    });
  }

  void _onSelectedDrawer(String choice) async {
    Navigator.of(context).pop();
    if (choice == 'filters') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(
            currentFilters: _selectedFilters,
          ),
        ),
      );

      setState(() {
        _selectedFilters = result ?? kInitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dummyProvider = ref.watch(mealProvider);

    final availableMeals = dummyProvider.where((meal) {
      if (_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (_selectedFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();
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
