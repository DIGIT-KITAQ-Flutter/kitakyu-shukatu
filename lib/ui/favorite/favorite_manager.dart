import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kitakyushu_shukatu/models/company.dart';

class FavoriteManager extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Company> _favoriteCompanies = [];

  List<Company> get favoriteCompanies => _favoriteCompanies;

  /// ✅ 【1】Firestoreからお気に入り企業を取得
  Future<void> fetchFavoriteCompanies() async {
    final user = _auth.currentUser;
    if (user == null) return;  // ログインしていない場合はreturn

    // Firestoreからログインユーザーに紐づくデータを取得
    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)  // ←ここでユーザーIDを紐づける
        .collection('favoriteCompanies')
        .get();

    // 取得データをCompanyモデルに変換
    _favoriteCompanies = snapshot.docs.map((doc) {
      final data = doc.data();
      return Company(
        id: doc.id,
        name: data['name'],
        industry: data['industry'],
        location: data['location'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
      );
    }).toList();

    notifyListeners();
  }

  /// ✅ 【2】お気に入り登録/解除
  Future<void> toggleFavorite(Company company) async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Firestoreのパス
    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favoriteCompanies')
        .doc(company.id);

    // すでにお気に入り登録されている場合は削除
    if (_favoriteCompanies.any((c) => c.id == company.id)) {
      await docRef.delete();
      _favoriteCompanies.removeWhere((c) => c.id == company.id);
    } else {
      // お気に入り登録されていない場合は新規追加
      await docRef.set({
        'name': company.name,
        'industry': company.industry,
        'location': company.location,
        'imageUrl': company.imageUrl,
      });
      _favoriteCompanies.add(company);
    }

    notifyListeners();
  }

  /// ✅ 【3】お気に入り済みかどうか判定
  bool isFavorite(Company company) {
    return _favoriteCompanies.any((c) => c.id == company.id);
  }
}
