import 'package:flutter/material.dart';
import 'package:dappr/models/rating.dart';

class RatingProvider with ChangeNotifier {
  final List<Rating> _userRatings = [];

  List<Rating> get userRatings => _userRatings;

  void addRating(Rating rating) {
    _userRatings.add(rating);
    notifyListeners();
  }

  void clearAllRatings() {
    _userRatings.clear();
    notifyListeners();
  }
}
