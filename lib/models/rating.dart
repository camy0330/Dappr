class Rating {
  final String userName;
  final String comment;
  final double ratingValue;
  final String recipeId; // Ensure this name is used consistently

  Rating({
    required this.userName,
    required this.comment,
    required this.ratingValue,
    required this.recipeId,
  });

  // Factory constructor to create a Rating object from a JSON map
  // This is used when loading data from SharedPreferences
  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      userName: json['userName'] as String,
      comment: json['comment'] as String,
      ratingValue: json['ratingValue'] as double,
      recipeId: json['recipeId'] as String,
    );
  }

  // Method to convert a Rating object to a JSON map
  // This is used when saving data to SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'comment': comment,
      'ratingValue': ratingValue,
      'recipeId': recipeId,
    };
  }
}