import 'package:flutter/material.dart';
import '../../../services/auth_firebase.dart';
import '../../../services/auth_backend.dart';
import '../../../services/auth_token_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  String? _mensagem;
  Map<String, dynamic>? _perfil;

  void _fazerLogin() async {
  final cpf = emailController.text.trim(); // Agora isso é o CPF
  final senha = senhaController.text;

  final emailFake = '$cpf@app.com'; // Converte CPF para e-mail

  // 1) Login no Firebase → ID token
  final firebaseToken = await AuthService().loginComFirebase(emailFake, senha);
  if (firebaseToken == null) {
    setState(() {
      _mensagem = 'Erro ao fazer login no Firebase.';
    });
    return;
  }

  // 2) Envia o Firebase token pro FastAPI → JWT próprio
  final backendJwt = await postWithToken(firebaseToken);
  if (backendJwt == null) {
    setState(() {
      _mensagem = 'Falha na autenticação com o back-end.';
    });
    return;
  }

  // 3) Usa o JWT do seu back-end pra puxar o perfil
  final perfil = await getUserProfile(backendJwt);
  if (perfil == null) {
    setState(() {
      _mensagem = 'Não foi possível obter o perfil.';
    });
    return;
  }

  // 4) Sucesso: atualiza UI
  setState(() {
    _perfil = perfil;
    _mensagem = 'Bem-vindo, ${perfil['nome']}!';
  });

  AuthTokenService().setToken(backendJwt);
  Navigator.pushReplacementNamed(
    context,
    '/home',
    arguments: perfil,
  );
}


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login + Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'CPF'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: senhaController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fazerLogin,
              child: const Text('Login e Puxar Perfil'),
            ),
            const SizedBox(height: 20),
            if (_mensagem != null)
              Text(_mensagem!, style: const TextStyle(color: Colors.blue)),
            const SizedBox(height: 20),
            if (_perfil != null) ...[
              Text('ID: ${_perfil!['id']}'),
              Text('Nome: ${_perfil!['nome']}'),
              Text('Email: ${_perfil!['email']}'),
            ],
          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'auth_firebase.dart';
// import 'auth_backend.dart';

// // Cria um widget StatefulWidget chamado LoginPage
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   // Widgets Stateful são usados quando o estado da interface precisa mudar (como mostrar mensagens de erro)
//   // o metodo createState cria o estado do widget
//   State<LoginPage> createState() => _LoginPageState();
// }


// class _LoginPageState extends State<LoginPage> {
//   final emailController = TextEditingController();
//   final senhaController = TextEditingController();

//   String? _mensagem;
//   Map<String, dynamic>? _perfil;

// void _fazerLogin() async {
//   final email = emailController.text.trim();
//   final senha = senhaController.text;

//   //Aqui está a conexão com o primeiro código, o Firebase
//   final token = await AuthService().loginComFirebase(email, senha);
//   print('TOKEN FIREBASE: $token'); // Aqui você pode ver o token que foi gerado pelo Firebase

//   if (token != null) {
//     // Enviando para o backend e recebendo o JWT da API
//     //
//     final jwt = await postWithToken(token);

    
//     if (jwt != null) {
//       setState(() {
//         _mensagem = 'Login com sucesso! JWT: $jwt';
//       });
//     } else {
//       setState(() {
//         _mensagem = 'Falha na autenticação com o back-end.';
//       });
//     }
//   } else {
//     setState(() {
//       _mensagem = 'Erro ao fazer login no Firebase.';
//     });
//   }
//   // 3) Agora puxa o perfil usando o mesmo Firebase token
//     final perfil = await getUserProfile(firebaseToken);
//     if (perfil == null) {
//       setState(() => _mensagem = 'Não foi possível obter o perfil.');
//       return;
//     }

//     // 4) Tudo certo: guarda o perfil e exibe
//     setState(() {
//       _perfil = perfil;
//       _mensagem = 'Bem-vindo, ${perfil['nome']}!';
//     });
// }


  
//    @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Login + Perfil')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
//             TextField(controller: senhaController, decoration: const InputDecoration(labelText: 'Senha'), obscureText: true),
//             const SizedBox(height: 20),
//             ElevatedButton(onPressed: _fazerLogin, child: const Text('Login e Puxar Perfil')),
//             const SizedBox(height: 20),
//             if (_mensagem != null) Text(_mensagem!, style: const TextStyle(color: Colors.blue)),
//             const SizedBox(height: 20),
//             if (_perfil != null) ...[
//               Text('ID: ${_perfil!['id']}'),
//               Text('Nome: ${_perfil!['nome']}'),
//               Text('Email: ${_perfil!['email']}'),
//               // e por aí vai conforme o JSON retornado
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }












