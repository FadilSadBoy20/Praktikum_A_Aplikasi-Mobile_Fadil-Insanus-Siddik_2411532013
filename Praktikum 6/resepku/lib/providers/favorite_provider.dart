import 'package:flutter/foundation.dart'; 
import 'package:resepku/models/recipe.dart'; 
  
class FavoriteProvider extends ChangeNotifier { 
  final List<Recipe> _items = []; 
  
  // Dari luar hanya boleh dibaca, tidak boleh diubah langsung 
  List<Recipe> get items => List.unmodifiable(_items); 
  int get count => _items.length; 
  
  bool isFavorite(Recipe recipe) => _items.any((r) => r.id == recipe.id); 
  
  void toggle(Recipe recipe) { 
    if (isFavorite(recipe)) { 
      _items.removeWhere((r) => r.id == recipe.id); 
    } else { 
      _items.add(recipe); 
    } 
    notifyListeners(); // beri tahu semua widget yang "mendengarkan" 
  } 
  
  void clear() { 
    _items.clear(); 
    notifyListeners(); 
  } 
}