import 'package:provider/provider.dart'; 
import 'package:resepku/providers/favorite_provider.dart';
import 'package:flutter/material.dart'; 
import 'package:resepku/models/recipe.dart'; 
import 'package:resepku/widgets/recipe_image.dart'; 
  
class DetailPage extends StatefulWidget { 
  const DetailPage({super.key, required this.recipe}); 
  
  final Recipe recipe; 
  
  @override 
  State<DetailPage> createState() => _DetailPageState(); 
} 
  
class _DetailPageState extends State<DetailPage> { 
  late int _servings; // state lokal: hanya halaman ini yang butuh 
  
  @override 
  void initState() { 
    super.initState(); 
    _servings = widget.recipe.servings; // nilai awal dari data resep 
  } 
  
  void _addServing() { 
    setState(() => _servings++); 
  } 
  
  void _removeServing() { 
    if (_servings > 1) { 
      setState(() => _servings--); 
    } 
  } 
  
  @override 
  Widget build(BuildContext context) { 
    final recipe = widget.recipe; 
    final totalCalories = recipe.caloriesPerServing * _servings;
    final isFavorite = context.watch<FavoriteProvider>().isFavorite(recipe); 
    final textTheme = Theme.of(context).textTheme;

    return Scaffold( 
      body: CustomScrollView(
        slivers: [
          // SliverAppBar dengan foto resep sebagai background
          SliverAppBar(
            pinned: true,
            expandedHeight: 260,
            actions: [
              IconButton(
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                onPressed: () => context.read<FavoriteProvider>().toggle(recipe),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                recipe.name,
                style: const TextStyle(
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3.0,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
              background: RecipeImage(url: recipe.image),
            ),
          ),
          
          // Bagian info, porsi, dan judul bahan
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${recipe.cuisine} • ${recipe.difficulty} • ${recipe.totalTimeMinutes} menit',
                    style: textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Text('Porsi', style: textTheme.titleMedium),
                          const Spacer(),
                          IconButton.filledTonal(
                            onPressed: _servings > 1 ? _removeServing : null,
                            icon: const Icon(Icons.remove),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text('$_servings', style: textTheme.titleLarge),
                          ),
                          IconButton.filledTonal(
                            onPressed: _addServing,
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Total kalori: $totalCalories kkal', style: textTheme.titleMedium),
                  const SizedBox(height: 24),
                  Text('Bahan', style: textTheme.titleLarge),
                ],
              ),
            ),
          ),
          
          // Daftar bahan menggunakan SliverList.builder
          SliverList.builder(
            itemCount: recipe.ingredients.length,
            itemBuilder: (context, index) {
              return ListTile(
                dense: true,
                leading: const Icon(Icons.check_circle_outline),
                title: Text(recipe.ingredients[index]),
              );
            },
          ),
        ],
      ),
    ); 
  } 
}