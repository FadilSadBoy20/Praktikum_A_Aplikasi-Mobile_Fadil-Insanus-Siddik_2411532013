import 'package:flutter/material.dart'; 
import 'package:provider/provider.dart'; 
import 'package:resepku/providers/favorite_provider.dart'; 
  
class FavoritePage extends StatelessWidget { 
  const FavoritePage({super.key}); 

  void _showClearConfirmationDialog(BuildContext context, FavoriteProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Semua Favorit'),
        content: const Text('Apakah Anda yakin ingin menghapus semua resep favorit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              provider.clear();
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
  
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar(
        title: const Text('Favorit Saya'),
        actions: [
          Consumer<FavoriteProvider>(
            builder: (context, favorite, child) {
              return IconButton(
                icon: const Icon(Icons.delete_sweep),
                tooltip: 'Hapus semua',
                onPressed: favorite.count > 0
                    ? () => _showClearConfirmationDialog(context, favorite)
                    : null,
              );
            },
          ),
        ],
      ), 
      body: Consumer<FavoriteProvider>( 
        builder: (context, favorite, child) { 
          if (favorite.count == 0) { 
            return const Center( 
              child: Text( 
                'Belum ada resep favorit.\nTekan ikon hati di daftar resep.', 
                textAlign: TextAlign.center, 
              ), 
            ); 
          } 
          return ListView( 
            children: [ 
              for (final recipe in favorite.items) 
                ListTile( 
                  title: Text(recipe.name), 
                  subtitle: Text(recipe.cuisine), 
                  trailing: IconButton( 
                    icon: const Icon(Icons.delete_outline), 
                    onPressed: () => favorite.toggle(recipe), 
                  ), 
                ), 
            ], 
          ); 
        }, 
      ), 
    ); 
  } 
}