class Rating {
  final String userName;
  final String comment;
  final double ratingValue;
  final String recipeId; // <-- pastikan nama ini, bukan 'id'

  Rating({
    required this.userName,
    required this.comment,
    required this.ratingValue,
    required this.recipeId,
  });
}