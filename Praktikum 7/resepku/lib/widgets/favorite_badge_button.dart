import 'package:flutter/material.dart'; 
import 'package:provider/provider.dart'; 
import 'package:resepku/pages/favorite_page.dart'; 
import 'package:resepku/providers/favorite_provider.dart'; 
  
class FavoriteBadgeButton extends StatelessWidget { 
  const FavoriteBadgeButton({super.key}); 
  
  @override 
  Widget build(BuildContext context) { 
    final count = context.watch<FavoriteProvider>().count; 
  
    return IconButton( 
      tooltip: 'Favorit saya', 
      icon: Badge( 
        isLabelVisible: count > 0, 
        label: Text('$count'), 
        child: const Icon(Icons.favorite), 
      ), 
      onPressed: () => Navigator.push( 
        context, 
        MaterialPageRoute(builder: (context) => const FavoritePage()), 
      ), 
    ); 
  } 
}