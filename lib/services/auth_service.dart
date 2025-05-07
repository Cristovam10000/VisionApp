import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Login com email e senha
  Future<String?> loginComFirebase(String email, String senha) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      // Pega o ID token gerado pelo Firebase
      final token = await userCredential.user?.getIdToken();
      return token;
    } catch (e) {
      print('Erro ao fazer login: $e');
      return null;
    }
  }
}