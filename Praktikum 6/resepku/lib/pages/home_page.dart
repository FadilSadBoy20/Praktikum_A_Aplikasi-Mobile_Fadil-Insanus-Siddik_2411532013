import 'package:flutter/material.dart'; 
import 'package:resepku/data/dummy_recipes.dart'; 
import 'package:resepku/pages/settings_page.dart'; 
import 'package:resepku/widgets/favorite_badge_button.dart'; 
import 'package:resepku/widgets/recipe_tile.dart'; 
  
class HomePage extends StatelessWidget { 
  const HomePage({super.key}); 
  
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar( 
        title: const Text('ResepKu'), 
        actions: [
          const FavoriteBadgeButton(),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Pengaturan',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            ),
          ),
        ], 
      ), 
      body: ListView( 
        children: [ 
          for (final recipe in dummyRecipes) RecipeTile(recipe: recipe), 
        ], 
      ), 
    ); 
  } 
}