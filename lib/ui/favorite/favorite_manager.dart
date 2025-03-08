import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kitakyushu_shukatu/models/company.dart';

class FavoriteManager extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Company> _favoriteCompanies = [];

  List<Company> get favoriteCompanies => _favoriteCompanies;

  /// Firestoreからお気に入り企業を取得
  Future<void> fetchFavoriteCompanies() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favoriteCompanies')
        .get();

    _favoriteCompanies = snapshot.docs.map((doc) {
      final data = doc.data();
      return Company(
        id: doc.id,
        name: data['name'],
        industry: data['industry'],
        location: data['location'],
        imageUrl: data['imageUrl'],
      );
    }).toList();

    notifyListeners();
  }

  /// お気に入り登録/解除
  Future<void> toggleFavorite(Company company) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favoriteCompanies')
        .doc(company.id);

    if (_favoriteCompanies.contains(company)) {
      // すでに登録済みなら解除
      await docRef.delete();
      _favoriteCompanies.remove(company);
    } else {
      // 未登録ならお気に入り登録
      await docRef.set({
        'name': company.name,
        'industry': company.industry,
      });
      _favoriteCompanies.add(company);
    }

    notifyListeners();
  }

  /// お気に入り登録済みかどうかを判定
  bool isFavorite(Company company) {
    return _favoriteCompanies.any((c) => c.id == company.id);
  }
}
