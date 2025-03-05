import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kitakyushu_shukatu/ui/Auth/view/auth_page.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // データがまだロードされていない場合はローディングを表示
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // ユーザーがログインしていない場合はログイン画面を表示
          if (!snapshot.hasData) {
            return AuthPage();
          }

          final user = snapshot.data!; // ログイン済みのユーザー情報を取得

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.account_circle, size: 100),
                Text(
                  "ログイン中: ${user.email}",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                  child: const Text("ログアウト"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
