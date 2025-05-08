import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Login com email e senha
  Future<String?> loginComFirebase(String email, String senha) async {
    try {
      // essa parte do codigo  envia o email e a senha para o back end(firabase) e retorna o token JWT
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      // Pega o ID token gerado pelo Firebase
      // usa esse objeto retornado para solicitar o ID token através do método getIdToken()
      if (userCredential.user == null) {
        return null; // Retorna null se o usuário não for encontrado
      } else {
         final token = await userCredential.user?.getIdToken();
         return token;
      }
     
    } catch (e) {
      print('Erro ao fazer login: $e');
      return null;
    }
  }
}

