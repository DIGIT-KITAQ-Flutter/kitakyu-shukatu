import 'package:flutter/material.dart';
import 'package:kitakyushu_shukatu/models/company.dart';

class FavoriteManager extends ChangeNotifier {
  final Set<Company> _favoriteCompanies = {}; // Set に変更

  List<Company> get favoriteCompanies => _favoriteCompanies.toList();

  void toggleFavorite(Company company) {
    if (_favoriteCompanies.contains(company)) {
      _favoriteCompanies.remove(company);
    } else {
      _favoriteCompanies.add(company);
    }
    notifyListeners(); // 状態が変わったことを通知
  }

  bool isFavorite(Company company) => _favoriteCompanies.contains(company);
}
