import 'package:flutter/material.dart'; 
  
/// Foto resep dari internet, lengkap dengan loading state dan error state. 
class RecipeImage extends StatelessWidget { 
  const RecipeImage({super.key, required this.url, this.cacheWidth}); 
  
  final String url; 
  
  /// Lebar (pixel) saat gambar di-decode. Gambar kecil cukup di-decode kecil, 
  /// sehingga memory yang dipakai jauh lebih sedikit. 
  final int? cacheWidth; 
  
  @override 
  Widget build(BuildContext context) { 
    return Image.network( 
      url, 
      fit: BoxFit.cover, 
      cacheWidth: cacheWidth, 
      // Loading state: tampil selama gambar masih diunduh. 
      loadingBuilder: (context, child, loadingProgress) { 
        if (loadingProgress == null) return child; // unduhan selesai 
        // Loading State 
        return ColoredBox( 
          color: Theme.of(context).colorScheme.surfaceContainerHighest, 
          child: const Center(child: Icon(Icons.restaurant_menu)), 
        ); 
      }, 
      // Error state: tampil jika URL salah atau tidak ada koneksi. 
      errorBuilder: (context, error, stackTrace) { 
        return Image.asset('assets/images/placeholder.png', fit: BoxFit.cover); 
      }, 
    ); 
  } 
}