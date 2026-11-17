import 'package:flutter/material.dart'; 
import 'package:provider/provider.dart'; 
import 'package:resepku/models/recipe.dart'; 
import 'package:resepku/pages/detail_page.dart'; 
import 'package:resepku/providers/favorite_provider.dart'; 
import 'package:resepku/widgets/recipe_image.dart'; 
  
class RecipeGridCard extends StatelessWidget { 
  const RecipeGridCard({super.key, required this.recipe}); 
  
  final Recipe recipe; 
  
  @override 
  Widget build(BuildContext context) { 
    final isFavorite = context.watch<FavoriteProvider>().isFavorite(recipe); 
    final textTheme = Theme.of(context).textTheme; 
  
    return Card( 
      clipBehavior: Clip.antiAlias, // gambar ikut terpotong sesuai sudut Card 
      child: InkWell( 
        onTap: () => Navigator.push( 
          context, 
          MaterialPageRoute(builder: (context) => DetailPage(recipe: recipe)), 
        ), 
        child: Column( 
          crossAxisAlignment: CrossAxisAlignment.stretch, 
          children: [ 
            Expanded( 
              child: Stack( 
                fit: StackFit.expand, 
                children: [ 
                  RecipeImage(url: recipe.image, cacheWidth: 500), 
                  Positioned( 
                    top: 4, 
                    right: 4, 
                    child: IconButton.filledTonal( 
                      icon: Icon( 
                        isFavorite ? Icons.favorite : Icons.favorite_border, 
                        color: isFavorite ? Colors.red : null, 
                      ), 
                      onPressed: () => 
                          context.read<FavoriteProvider>().toggle(recipe), 
                    ), 
                  ), 
                ], 
              ), 
            ), 
            Padding( 
              padding: const EdgeInsets.all(8), 
              child: Column( 
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [ 
                  Text( 
                    recipe.name, 
                    maxLines: 1, 
                    overflow: TextOverflow.ellipsis, 
                    style: textTheme.titleSmall, 
                  ), 
                  const SizedBox(height: 2), 
                  Text( 
                    '★ ${recipe.rating} • ${recipe.totalTimeMinutes} menit', 
                    style: textTheme.bodySmall, 
                  ),
                  ], 
              ), 
            ), 
          ], 
        ), 
      ), 
    ); 
  } 
} 