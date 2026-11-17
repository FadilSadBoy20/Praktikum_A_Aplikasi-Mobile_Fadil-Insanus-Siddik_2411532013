class Recipe { 
  final int id; 
  final String name; 
  final String cuisine; 
  final String difficulty; 
  final int prepTimeMinutes; 
  final int cookTimeMinutes; 
  final int servings; 
  final int caloriesPerServing; 
  final double rating; 
  final String image; // dipakai mulai Modul 7 
  final List<String> ingredients; 
  
  const Recipe({ 
    required this.id, 
    required this.name, 
    required this.cuisine, 
    required this.difficulty, 
    required this.prepTimeMinutes, 
    required this.cookTimeMinutes, 
    required this.servings, 
    required this.caloriesPerServing, 
    required this.rating, 
    required this.image, 
    required this.ingredients, 
  }); 
  
  int get totalTimeMinutes => prepTimeMinutes + cookTimeMinutes; 
} 
