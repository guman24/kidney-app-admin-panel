enum Routes {
  splash("splash", '/splash'),
  login("login", '/login'),
  dashboard("dashboard", '/dashboard'),
  chats("chats", '/chats'),
  users("users", '/users'),
  olivers("olivers", '/olivers'),
  recipes("recipes", '/recipes'),
  upsertRecipe("upsert-recipe", '/upsert-recipe'),
  recipeDetails("recipe-details", '/recipe-details'),
  exercises("exercises", '/exercises'),
  upsertExercise("upsert-exercise", '/upsert-exercise'),
  exerciseDetails("exercise-details", '/exercise-details'),
  settings("settings", '/settings'),
  news("news", '/news'),
  waitTimes("waitTimes", '/wait-times'),
  save("save", '/save');

  final String name;
  final String path;

  const Routes(this.name, this.path);
}
