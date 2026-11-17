import 'package:resepku/models/recipe.dart'; 
  
const List<Recipe> dummyRecipes = [ 
  Recipe( 
    id: 1, name: 'Classic Margherita Pizza', cuisine: 'Italian', difficulty: 'Easy', 
    prepTimeMinutes: 20, cookTimeMinutes: 15, servings: 4, caloriesPerServing: 300, 
    rating: 4.6, image: 'https://cdn.dummyjson.com/recipe-images/1.webp', 
    ingredients: ['Pizza dough', 'Tomato sauce', 'Fresh mozzarella cheese', 
        'Fresh basil leaves', 'Olive oil', 'Salt and pepper to taste'], 
  ), 
  Recipe( 
    id: 2, name: 'Vegetarian Stir-Fry', cuisine: 'Asian', difficulty: 'Medium', 
    prepTimeMinutes: 15, cookTimeMinutes: 20, servings: 3, caloriesPerServing: 250, 
    rating: 4.7, image: 'https://cdn.dummyjson.com/recipe-images/2.webp', 
    ingredients: ['Tofu, cubed', 'Broccoli florets', 'Carrots, sliced', 
        'Bell peppers, sliced', 'Soy sauce', 'Ginger, minced', 'Garlic, minced', 
        'Sesame oil', 'Cooked rice for serving'], 
  ), 
  Recipe( 
    id: 3, name: 'Chocolate Chip Cookies', cuisine: 'American', difficulty: 'Easy', 
    prepTimeMinutes: 15, cookTimeMinutes: 10, servings: 24, caloriesPerServing: 150, 
    rating: 4.9, image: 'https://cdn.dummyjson.com/recipe-images/3.webp', 
    ingredients: ['All-purpose flour', 'Butter, softened', 'Brown sugar', 
        'White sugar', 'Eggs', 'Vanilla extract', 'Baking soda', 'Salt', 
        'Chocolate chips'], 
  ), 
  Recipe( 
    id: 4, name: 'Chicken Alfredo Pasta', cuisine: 'Italian', difficulty: 'Medium', 
    prepTimeMinutes: 15, cookTimeMinutes: 20, servings: 4, caloriesPerServing: 500, 
    rating: 4.9, image: 'https://cdn.dummyjson.com/recipe-images/4.webp', 
    ingredients: ['Fettuccine pasta', 'Chicken breast, sliced', 'Heavy cream', 
        'Parmesan cheese, grated', 'Garlic, minced', 'Butter', 
        'Salt and pepper to taste', 'Fresh parsley for garnish'], 
  ), 
  Recipe( 
    id: 5, name: 'Mango Salsa Chicken', cuisine: 'Mexican', difficulty: 'Easy', 
    prepTimeMinutes: 15, cookTimeMinutes: 25, servings: 3, caloriesPerServing: 380, 
    rating: 4.9, image: 'https://cdn.dummyjson.com/recipe-images/5.webp', 
    ingredients: ['Chicken thighs', 'Mango, diced', 'Red onion, finely chopped', 
        'Cilantro, chopped', 'Lime juice', 'Jalapeño, minced', 
        'Salt and pepper to taste', 'Cooked rice for serving'], 
  ), 
  Recipe( 
    id: 6, name: 'Quinoa Salad with Avocado', cuisine: 'Mediterranean', 
    difficulty: 'Easy', prepTimeMinutes: 20, cookTimeMinutes: 15, servings: 4, 
    caloriesPerServing: 280, rating: 4.4, 
    image: 'https://cdn.dummyjson.com/recipe-images/6.webp', 
    ingredients: ['Quinoa, cooked', 'Avocado, diced', 'Cherry tomatoes, halved', 
        'Cucumber, diced', 'Red bell pepper, diced', 'Feta cheese, crumbled', 
        'Lemon vinaigrette dressing', 'Salt and pepper to taste'], 
  ), 
]; 