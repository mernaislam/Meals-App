import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/model/meal.dart';
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

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() {
    return _TabScreenState();
  }
}

class _TabScreenState extends State<TabScreen> {
  int currentIndex = 0;
  final List<Meal> _favoriteMeals = [];
  Map<Filter, bool> _selectedFilters = kInitialFilters;

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }

  void _toggleFavoriteMealsStatus(Meal meal) {
    final isExist = _favoriteMeals.contains(meal);
    if (isExist) {
      setState(() {
        _favoriteMeals.remove(meal);
        _showMessage('Meal is no longer a favorite');
      });
    } else {
      setState(() {
        _favoriteMeals.add(meal);
        _showMessage('Marked as a favorite!');
      });
    }
  }

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
          builder: (ctx) => FiltersScreen(currentFilters: _selectedFilters,),
        ),
      );

      setState(() {
        _selectedFilters = result ?? kInitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = dummyMeals.where((meal) {
      if(_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree){
        return false;
      }
      if(_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree){
        return false;
      }
      if(_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian){
        return false;
      }
      if(_selectedFilters[Filter.vegan]! && !meal.isVegan){
        return false;
      }
      return true;
    }
    ).toList();
    Widget mainContent = CategoriesScreen(
      onToggleFavorite: _toggleFavoriteMealsStatus,
      availableMeals: availableMeals,
    );
    String title = 'Categories';

    if (currentIndex == 1) {
      mainContent = MealsScreen(
        meals: _favoriteMeals,
        onToggleFavorite: _toggleFavoriteMealsStatus,
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
              icon: Icon(Icons.category), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites')
        ],
      ),
    );
  }
}
