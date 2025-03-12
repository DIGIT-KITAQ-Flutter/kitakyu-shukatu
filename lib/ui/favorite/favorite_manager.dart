import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kitakyushu_shukatu/models/company.dart';

class FavoriteManager extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Company> _favoriteCompanies = [];

  List<Company> get favoriteCompanies => _favoriteCompanies;

  /// ✅ 【1】お気に入り企業を取得
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
        location: data['location'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
        progress: data['progress'] ?? '進行度',
      );
    }).toList();

    notifyListeners();
  }

  /// ✅ 【2】進行度タグをFirestoreに保存
  Future<void> updateProgress(Company company, String progress) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favoriteCompanies')
        .doc(company.id)
        .update({
      'progress': progress,
    });

    // ローカルデータを更新
    company.progress = progress;
    notifyListeners();
  }

  /// ✅ 【3】お気に入り登録/解除
  Future<void> toggleFavorite(Company company) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favoriteCompanies')
        .doc(company.id);

    if (_favoriteCompanies.any((c) => c.id == company.id)) {
      await docRef.delete();
      _favoriteCompanies.removeWhere((c) => c.id == company.id);
    } else {
      await docRef.set({
        'name': company.name,
        'industry': company.industry,
        'location': company.location,
        'imageUrl': company.imageUrl,
        'progress': '進行度',
      });
      _favoriteCompanies.add(company);
    }

    notifyListeners();
  }
    bool isFavorite(Company company) {
    return _favoriteCompanies.any((c) => c.id == company.id);
  }
}
